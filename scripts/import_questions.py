import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json
import csv
import argparse
import os
import sys

def init_firebase(service_account_path):
    """Firebase Admin SDKの初期化"""
    if not os.path.exists(service_account_path):
        print(f"Error: サービスアカウントの鍵ファイルが見つかりません: {service_account_path}")
        print("Firebase Console > プロジェクト設定 > サービスアカウント からJSONファイルを生成してください。")
        sys.exit(1)
    
    cred = credentials.Certificate(service_account_path)
    firebase_admin.initialize_app(cred)
    return firestore.client()

def import_from_json(db, file_path):
    """JSONファイルからインポート"""
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if not isinstance(data, list):
        print("Error: JSONはリスト形式である必要があります。")
        return
    
    return data

def import_from_csv(db, file_path):
    """CSVファイルからインポート"""
    questions = []
    with open(file_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        for row in reader:
            # optionsはセミコロン区切りを想定
            options = [opt.strip() for opt in row.get('options', '').split(';') if opt.strip()]
            
            question = {
                'id': row.get('id'),
                'text': row.get('text'),
                'options': options,
                'correctOptionIndex': int(row.get('correctOptionIndex', 0)),
                'explanation': row.get('explanation', ''),
                'category': row.get('category', '未分類')
            }
            if row.get('imageUrl'):
                question['imageUrl'] = row.get('imageUrl').strip()
            if row.get('explanationImageUrl'):
                question['explanationImageUrl'] = row.get('explanationImageUrl').strip()
            questions.append(question)
    return questions

def upload_to_firestore(db, questions):
    """Firestoreへ一括アップロード（バッチ処理）"""
    batch = db.batch()
    count = 0
    total = len(questions)
    
    print(f"{total} 件のデータをアップロード中...")
    
    for q in questions:
        doc_id = q.get('id')
        # IDが指定されていればそれを使用、なければ自動生成
        if doc_id:
            doc_ref = db.collection('questions').document(doc_id)
        else:
            doc_ref = db.collection('questions').document()
            
        # インポート時にIDフィールド自体は含めない（あるいはFirestoreで管理）
        data = {k: v for k, v in q.items() if k != 'id' and v is not None}
        batch.set(doc_ref, data)
        
        count += 1
        # Firestoreのバッチ制限（500件）に合わせてコミット
        if count % 500 == 0:
            batch.commit()
            batch = db.batch()
            print(f"{count}/{total} 件完了...")
            
    batch.commit()
    print(f"完了！合計 {count} 件のデータを Firestore に保存しました。")

def main():
    parser = argparse.ArgumentParser(description='Firebase Firestore への問題データ一括インポートツール')
    parser.add_argument('--file', required=True, help='インポートするファイルパス (JSON or CSV)')
    parser.add_argument('--key', default='service-account.json', help='サービスアカウント鍵ファイル (default: service-account.json)')
    parser.add_argument('--format', choices=['json', 'csv'], help='ファイル形式 (指定なしの場合は拡張子から判断)')
    
    args = parser.parse_args()
    
    # 形式判断
    fmt = args.format
    if not fmt:
        if args.file.endswith('.json'):
            fmt = 'json'
        elif args.file.endswith('.csv'):
            fmt = 'csv'
        else:
            print("Error: ファイル形式を特定できません。--format [json|csv] を指定してください。")
            return

    # Firebase初期化
    db = init_firebase(args.key)
    
    # データ読み込み
    try:
        if fmt == 'json':
            questions = import_from_json(db, args.file)
        else:
            questions = import_from_csv(db, args.file)
    except Exception as e:
        print(f"データの読み込み中にエラーが発生しました: {e}")
        return

    # アップロード
    if questions:
        upload_to_firestore(db, questions)

if __name__ == "__main__":
    main()
