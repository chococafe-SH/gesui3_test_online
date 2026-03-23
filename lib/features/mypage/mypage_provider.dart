import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user_stats.dart';
import '../auth/auth_provider.dart';

final mypageStatsProvider = StreamProvider<UserStats>((ref) {
  final user = ref.watch(authNotifierProvider).value;
  if (user == null) return Stream.value(const UserStats());

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return const UserStats();
        final data = snapshot.data();
        if (data == null || !data.containsKey('stats')) return const UserStats();
        return UserStats.fromMap(data['stats'] as Map<String, dynamic>);
      });
});
