import 'package:shared_preferences/shared_preferences.dart';

class JobData {
  double hoursWorked;
  double moneyEarned;
  double hourlyRate;
  String currency;
  double shiftHours;
  bool isShiftActive = false;
  DateTime? shiftStartTime;

  JobData({
    required this.hoursWorked,
    required this.moneyEarned,
    required this.hourlyRate,
    required this.currency,
    required this.shiftHours,
  });

  Future<void> startShift() async {
    if (!isShiftActive) {
      isShiftActive = true;
      shiftStartTime ??= DateTime.now();
      await saveData();
    }
  }

  Future<void> pauseShift() async {
    if (isShiftActive && shiftStartTime != null) {
      final shiftEndTime = DateTime.now();
      final workedDuration = shiftEndTime.difference(shiftStartTime!).inSeconds;
      hoursWorked += workedDuration / 3600;
      moneyEarned += (workedDuration / 3600) * hourlyRate;
      isShiftActive = false;
      shiftStartTime = null;
      await saveData();
    }
  }

  Future<void> endShift() async {
    if (isShiftActive && shiftStartTime != null) {
      final shiftEndTime = DateTime.now();
      final workedDuration = shiftEndTime.difference(shiftStartTime!).inSeconds;
      hoursWorked += workedDuration / 3600;
      moneyEarned += (workedDuration / 3600) * hourlyRate;
      isShiftActive = false;
      shiftStartTime = null;
      await saveData();
    }
  }

  void resetData() {
    hoursWorked = 0;
    moneyEarned = 0.0;
    isShiftActive = false;
    shiftStartTime = null;
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('hoursWorked', hoursWorked);
    prefs.setDouble('moneyEarned', moneyEarned);
    prefs.setDouble('hourlyRate', hourlyRate);
    prefs.setString('currency', currency);
    prefs.setDouble('shiftHours', shiftHours);
    prefs.setBool('isShiftActive', isShiftActive);
    prefs.setString('shiftStartTime', shiftStartTime?.toIso8601String() ?? '');
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hoursWorked = prefs.getDouble('hoursWorked') ?? 0;
    moneyEarned = prefs.getDouble('moneyEarned') ?? 0.0;
    hourlyRate = prefs.getDouble('hourlyRate') ?? 27.7;
    currency = prefs.getString('currency') ?? 'PLN';
    shiftHours = prefs.getDouble('shiftHours') ?? 8.5;
    isShiftActive = prefs.getBool('isShiftActive') ?? false;
    final shiftStartTimeString = prefs.getString('shiftStartTime') ?? '';
    if (shiftStartTimeString.isNotEmpty) {
      shiftStartTime = DateTime.parse(shiftStartTimeString);
    }
  }
}
