import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_stats.dart';
import '../auth/auth_provider.dart';

class FirestorePaths {
  static const users = 'users';
  static String userDoc(String uid) => 'users/$uid';
  static const statsField = 'stats';
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final mypageStatsProvider = StreamProvider<UserStats>((ref) {
  ref.onDispose(() {
    debugPrint('mypageStatsProvider disposed');
  });

  final authState = ref.watch(authNotifierProvider);
  final firestore = ref.watch(firestoreProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(const UserStats());
      
      return firestore
          .collection(FirestorePaths.users)
          .doc(user.uid)
          .snapshots()
          .map((snapshot) {
            if (!snapshot.exists) return const UserStats();
            final data = snapshot.data();
            final statsData = data?[FirestorePaths.statsField];
            
            if (statsData is! Map<String, dynamic>) {
              return const UserStats();
            }
            return UserStats.fromMap(statsData);
          })
          .handleError((error, stackTrace) {
            debugPrint('UserStats stream error: $error');
          });
    },
    loading: () => const Stream.empty(),
    error: (e, s) => Stream.error(e, s),
  );
});
