import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../history/history_screen.dart';
import 'home_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: 'ホーム',
          ),
        ),
        PersistentTabConfig(
          screen: const HistoryScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.history),
            title: '学習履歴',
          ),
        ),
        PersistentTabConfig(
          screen: const Center(child: Text('マイページ')),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: 'マイページ',
          ),
        ),
        PersistentTabConfig(
          screen: const Center(child: Text('設定')),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: '設定',
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
