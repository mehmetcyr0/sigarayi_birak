import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MotivationProvider with ChangeNotifier {
  List<String> _achievements = [];
  List<String> _goals = [];
  int _motivationStreak = 0;
  DateTime? _lastMotivationDate;

  List<String> get achievements => _achievements;
  List<String> get goals => _goals;
  int get motivationStreak => _motivationStreak;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _achievements = prefs.getStringList('achievements') ?? [];
    _goals = prefs.getStringList('goals') ?? [];
    _motivationStreak = prefs.getInt('motivation_streak') ?? 0;
    final lastDateStr = prefs.getString('last_motivation_date');
    if (lastDateStr != null) {
      _lastMotivationDate = DateTime.parse(lastDateStr);
    }
    notifyListeners();
  }

  Future<void> addAchievement(String achievement) async {
    _achievements.add(achievement);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('achievements', _achievements);
    notifyListeners();
  }

  Future<void> addGoal(String goal) async {
    _goals.add(goal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', _goals);
    notifyListeners();
  }

  Future<void> removeGoal(int index) async {
    _goals.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('goals', _goals);
    notifyListeners();
  }

  Future<void> updateMotivationStreak() async {
    final now = DateTime.now();
    if (_lastMotivationDate == null) {
      _motivationStreak = 1;
    } else {
      final difference = now.difference(_lastMotivationDate!).inDays;
      if (difference == 1) {
        _motivationStreak++;
      } else if (difference > 1) {
        _motivationStreak = 1;
      }
    }
    _lastMotivationDate = now;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('motivation_streak', _motivationStreak);
    await prefs.setString('last_motivation_date', now.toIso8601String());
    notifyListeners();
  }
}
