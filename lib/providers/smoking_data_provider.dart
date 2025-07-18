import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmokingDataProvider with ChangeNotifier {
  DateTime? _quitDate;
  int _dailyCigarettes = 0;
  double _pricePerPack = 0.0;
  final int _cigarettesPerPack = 20;

  DateTime? get quitDate => _quitDate;
  int get dailyCigarettes => _dailyCigarettes;
  double get pricePerPack => _pricePerPack;
  int get cigarettesPerPack => _cigarettesPerPack;

  double get moneySaved {
    if (_quitDate == null) return 0.0;
    final daysSinceQuit = DateTime.now().difference(_quitDate!).inDays;
    final cigarettesSaved = daysSinceQuit * _dailyCigarettes;
    return (cigarettesSaved / _cigarettesPerPack) * _pricePerPack;
  }

  int get cigarettesSaved {
    if (_quitDate == null) return 0;
    final daysSinceQuit = DateTime.now().difference(_quitDate!).inDays;
    return daysSinceQuit * _dailyCigarettes;
  }

  Future<void> setQuitDate(DateTime date) async {
    _quitDate = date;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quit_date', date.toIso8601String());
    notifyListeners();
  }

  Future<void> setDailyCigarettes(int count) async {
    _dailyCigarettes = count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_cigarettes', count);
    notifyListeners();
  }

  Future<void> setPricePerPack(double price) async {
    _pricePerPack = price;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('price_per_pack', price);
    notifyListeners();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final quitDateStr = prefs.getString('quit_date');
    if (quitDateStr != null) {
      _quitDate = DateTime.parse(quitDateStr);
    }
    _dailyCigarettes = prefs.getInt('daily_cigarettes') ?? 0;
    _pricePerPack = prefs.getDouble('price_per_pack') ?? 0.0;
    notifyListeners();
  }

  // Verileri temizlemek için yardımcı method
  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quit_date');
    await prefs.remove('daily_cigarettes');
    await prefs.remove('price_per_pack');
    
    _quitDate = null;
    _dailyCigarettes = 0;
    _pricePerPack = 0.0;
    notifyListeners();
  }

  // Sigarayı bırakma tarihini kontrol etmek için getter
  bool get hasQuitDate => _quitDate != null;

  // Sigarayı bıraktığından beri geçen gün sayısı
  int get daysSinceQuit {
    if (_quitDate == null) return 0;
    return DateTime.now().difference(_quitDate!).inDays;
  }
}
