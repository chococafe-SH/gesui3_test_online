import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString('unlocked_until');
    if (timeStr != null) {
      _unlockedUntil = DateTime.tryParse(timeStr);
      _setupExpiryTimer();
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
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unlocked_until', _unlockedUntil!.toIso8601String());
    
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
