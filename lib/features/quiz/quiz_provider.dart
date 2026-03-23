import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/models/quiz_models.dart';
import '../../core/repositories/user_repository_provider.dart';
import '../auth/auth_provider.dart';

part 'quiz_provider.g.dart';

@Riverpod(keepAlive: true)
class QuizNotifier extends _$QuizNotifier {
  @override
  QuizState build() {
    return const QuizState(questions: []);
  }

  void startQuiz(List<Question> questions) {
    state = QuizState(questions: questions);
  }

  /// 選択肢を選択 → フィードバック表示状態に遷移
  void selectOption(int optionIndex) {
    if (state.isCompleted || state.showingFeedback) return;

    final newAnswers = Map<int, int>.from(state.answers);
    newAnswers[state.currentIndex] = optionIndex;

    state = state.copyWith(
      answers: newAnswers,
      showingFeedback: true,
    );
  }

  /// フィードバック確認後、次の問題へ進む or クイズ完了
  Future<void> confirmAnswer() async {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        showingFeedback: false,
      );
    } else {
      state = state.copyWith(isCompleted: true, showingFeedback: false);
      await _saveResult();
    }
  }

  Future<void> _saveResult() async {
    final user = ref.read(authNotifierProvider).value;
    if (user == null) return;

    final repository = ref.read(userRepositoryProvider);
    
    int correctCount = 0;
    final List<Map<String, dynamic>> records = [];

    for (int i = 0; i < state.questions.length; i++) {
      final question = state.questions[i];
      final selected = state.answers[i];
      
      if (selected == null) continue; // 未回答の場合はスキップ
      
      final isCorrect = selected == question.correctOptionIndex;
      
      if (isCorrect) correctCount++;
      
      records.add({
        'questionId': question.id,
        'selectedOption': selected,
        'isCorrect': isCorrect,
        'category': question.category ?? '未分類',
      });
    }

    if (records.isEmpty) return; // 何も回答していなければスキップ


    final category = state.questions.isNotEmpty 
        ? state.questions.first.category ?? '未分類' 
        : '不明';

    try {
      await repository.saveQuizResult(
        user.uid,
        category,
        records,
        state.questions.length, // 回答数ではなくクイズ全体の総数を記録
        correctCount,
      );
    } catch (e) {
      // 保存失敗をUIに通知（オフライン時はFirestoreキューに入っているため問題なし）
      state = state.copyWith(saveError: '結果の保存に失敗しました: $e');
      print('Failed to save quiz result: $e');
    }
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
        showingFeedback: false,
      );
    }
  }

  /// 途中退出時に、ここまでの回答結果を保存する
  Future<void> abortQuiz() async {
    if (state.answers.isNotEmpty && !state.isCompleted) {
      // まず完了状態にする（これ以降の回答を防止）
      state = state.copyWith(isCompleted: true, showingFeedback: false);
      try {
        await _saveResult().timeout(const Duration(seconds: 15));
      } catch (e) {
        print('abortQuiz: Error saving results: $e');
        // 保存失敗しても状態は完了のまま
      }
    } else {
      // 回答がない場合でも完了状態にする
      state = state.copyWith(isCompleted: true);
    }
  }

  void reset() {
    state = QuizState(questions: state.questions);
  }
}


// オンライン問題取得用
@riverpod
Future<List<Question>> onlineQuestions(OnlineQuestionsRef ref, String category) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchQuestions(category);
}

// サンプルデータ供給用
@riverpod
List<Question> sampleQuestions(SampleQuestionsRef ref) {

  return [
    const Question(
      id: 'q1',
      text: '下水道法において、公共下水道の設置及び管理は原則として誰が行うものとされているか？',
      options: ['国', '地方公共団体（市町村等）', '民間事業者', '都道府県知事'],
      correctOptionIndex: 1,
      explanation: '下水道法第3条により、公共下水道の設置、改築、修繕、維持その他の管理は、市町村が行うものとされています。',
      category: '下水道法',
    ),
    const Question(
      id: 'q2',
      text: '活性汚泥法において、曝気槽内の微生物濃度を示す指標として一般的に用いられるものはどれか？',
      options: ['BOD', 'COD', 'MLSS', 'DO'],
      correctOptionIndex: 2,
      explanation: 'MLSS（活性汚泥浮遊物質）は、曝気槽内の混合液中の浮遊物濃度を指し、微生物量の目安として最も一般的に用いられます。',
      category: '下水処理',
    ),
    const Question(
      id: 'q3',
      text: '下水道第3種技術検定の対象となるのは、主にどのような業務か？',
      options: ['下水道の設計', '下水道の工事監督', '下水道の維持管理', '下水道の計画立案'],
      correctOptionIndex: 2,
      explanation: '第3種技術検定は、主に下水道施設の維持管理（運転管理・点検整備など）に関する技術を問うものです。',
      category: '検定概要',
    ),
  ];
}

// 復習（苦手な問題）専用プロバイダ
@riverpod
Future<List<Question>> weakQuestions(WeakQuestionsRef ref, List<String> weakIds, bool isPremium) async {
  if (weakIds.isEmpty) return [];
  final repository = ref.watch(userRepositoryProvider);
  // 全問題を取得してIDでフィルタリング
  final allQuestions = await repository.fetchQuestions('全て', isPremium: isPremium);
  return allQuestions.where((q) => weakIds.contains(q.id)).toList();
}
