import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final premiumNotifierProvider = ChangeNotifierProvider<PremiumNotifier>((ref) {
  return PremiumNotifier().._init();
});

class PremiumNotifier extends ChangeNotifier {
  bool _isPurchasedPremium = false;
  DateTime? _unlockedUntil;
  Timer? _expiryTimer;

  bool get isPremium {
    if (_isPurchasedPremium) return true;
    if (_unlockedUntil != null && DateTime.now().isBefore(_unlockedUntil!)) {
      return true;
    }
    return false;
  }

  DateTime? get unlockedUntil => _unlockedUntil;

  static const _storage = FlutterSecureStorage();
  static const _unlockedKey = 'unlocked_until';

  Future<void> _init() async {
    try {
      // 古い平文データを安全なストレージに移行して削除
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('unlocked_until')) {
        final oldTimeStr = prefs.getString('unlocked_until');
        if (oldTimeStr != null) {
          await _storage.write(key: _unlockedKey, value: oldTimeStr);
        }
        await prefs.remove('unlocked_until');
      }

      final timeStr = await _storage.read(key: _unlockedKey);
      if (timeStr != null) {
        _unlockedUntil = DateTime.tryParse(timeStr);
        _setupExpiryTimer();
      }
    } catch (e) {
      debugPrint('Secure storage init error: $e');
    }
    notifyListeners();
  }

  void setPremium(bool value) {
    _isPurchasedPremium = value;
    notifyListeners();
  }

  Future<void> addRewardTime(Duration duration) async {
    final now = DateTime.now();
    if (_unlockedUntil == null || _unlockedUntil!.isBefore(now)) {
      _unlockedUntil = now.add(duration);
    } else {
      _unlockedUntil = _unlockedUntil!.add(duration);
    }
    
    try {
      await _storage.write(key: _unlockedKey, value: _unlockedUntil!.toIso8601String());
    } catch (e) {
      debugPrint('Failed to save reward to secure storage: $e');
    }
    
    _setupExpiryTimer();
    notifyListeners();
  }

  void _setupExpiryTimer() {
    _expiryTimer?.cancel();
    if (_unlockedUntil == null) return;
    
    final durationUntilExpiry = _unlockedUntil!.difference(DateTime.now());
    if (durationUntilExpiry.isNegative) {
      _unlockedUntil = null;
      notifyListeners();
    } else {
      _expiryTimer = Timer(durationUntilExpiry, () {
        _unlockedUntil = null;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}
