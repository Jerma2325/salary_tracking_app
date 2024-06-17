import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyStats = [
    {
      'day': 'Monday',
      'hours': 8,
      'earnings': 120.0,
    },
    {
      'day': 'Tuesday',
      'hours': 7,
      'earnings': 105.0,
    },
    // Add more days as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: ListView.builder(
        itemCount: weeklyStats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(weeklyStats[index]['day']),
            subtitle: Text(
                'Hours Worked: ${weeklyStats[index]['hours']}, Earnings: \$${weeklyStats[index]['earnings']}'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('${weeklyStats[index]['day']} Details'),
                    content: Text(
                        'Hours Worked: ${weeklyStats[index]['hours']}\nEarnings: \$${weeklyStats[index]['earnings']}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
