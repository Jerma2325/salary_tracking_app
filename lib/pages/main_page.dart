import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grind_app/models/job_data.dart';
import 'package:grind_app/widgets/rainbow_progress_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grind_app/pages/exchangeRate_page.dart';
import 'package:grind_app/pages/statistics_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  JobData jobData = JobData(
    hoursWorked: 0,
    moneyEarned: 0.0,
    hourlyRate: 27.7,
    currency: 'PLN',
    shiftHours: 8.5,
  );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    jobData.loadData().then((_) {
      setState(() {});
      if (jobData.isShiftActive && jobData.shiftStartTime != null) {
        _startShiftTimer();
      }
    });
  }

  void _startShiftTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final shiftDuration =
            DateTime.now().difference(jobData.shiftStartTime!).inSeconds;
        jobData.hoursWorked = shiftDuration / 3600;
        jobData.moneyEarned = (shiftDuration / 3600) * jobData.hourlyRate;

        if (jobData.hoursWorked >= jobData.shiftHours) {
          _pauseShiftAutomatically();
        }
      });
    });
  }

  void startShift() {
    if (!jobData.isShiftActive) {
      jobData.startShift().then((_) {
        _startShiftTimer();
        setState(() {});
      });
    }
  }

  void pauseShift() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    jobData.pauseShift().then((_) {
      setState(() {});
    });
  }

  void endShift() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    jobData.resetData();
    jobData.saveData().then((_) {
      setState(() {});
    });
  }

  void _pauseShiftAutomatically() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    jobData.pauseShift().then((_) {
      _saveShiftToStatistics();
      setState(() {});
    });
  }

  void _saveShiftToStatistics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> statistics = prefs.getStringList('statistics') ?? [];
    String newEntry = 'Date: ${DateTime.now().toIso8601String()}, '
        'Hours Worked: ${jobData.hoursWorked.toStringAsFixed(2)}, '
        'Money Earned: ${jobData.moneyEarned.toStringAsFixed(2)} ${getCurrencySymbol()}';
    statistics.add(newEntry);
    prefs.setStringList('statistics', statistics);
  }

  String getCurrencySymbol() {
    switch (jobData.currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'AUD':
        return 'A\$';
      case 'CAD':
        return 'C\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'SEK':
        return 'kr';
      case 'NZD':
        return 'NZ\$';
      case 'PLN':
        return 'zł';
      default:
        return 'zł';
    }
  }

  String getRemainingShiftTime() {
    double remainingHours = jobData.shiftHours - jobData.hoursWorked;
    int hours = remainingHours.toInt();
    int minutes = ((remainingHours - hours) * 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  double getProgress() {
    double progress = jobData.hoursWorked / jobData.shiftHours;
    return progress > 1.0 ? 1.0 : progress;
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    jobData.saveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              jobData.loadData().then((_) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Time Left',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 40),
            CustomPaint(
              size: Size(150, 75), // Adjusted size for a rainbow arc
              painter: RainbowProgressPainter(progress: getProgress()),
              child: Container(
                width: 150,
                height: 75,
                alignment: Alignment.center,
                child: Text(
                  getRemainingShiftTime(),
                  style: TextStyle(
                      fontSize: 16, color: Colors.black), // Adjust font size
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Money Earned: ${getCurrencySymbol()}${jobData.moneyEarned.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Hourly Rate: ${getCurrencySymbol()}${jobData.hourlyRate.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Hours Worked: ${jobData.hoursWorked.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: startShift,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.play_arrow, size: 30),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: pauseShift,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.pause, size: 30),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: endShift,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.stop, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: 'statistics', // Unique hero tag
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsPage()),
              );
            },
            child: Icon(Icons.bar_chart),
          ),
          FloatingActionButton(
            heroTag: 'exchangeRates', // Unique hero tag
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExchangeRatesPage()),
              );
            },
            child: Icon(Icons.monetization_on),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
