import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/smoking_data_provider.dart';
import '../providers/motivation_provider.dart';
import '../widgets/progress_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/motivation_card.dart';
import '../widgets/goals_card.dart';
import '../widgets/setup_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigarayı Bırak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const SetupDialog(),
            ),
          ),
        ],
      ),
      body: Consumer2<SmokingDataProvider, MotivationProvider>(
        builder: (context, smokingData, motivationData, child) {
          if (smokingData.quitDate == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/quit_smoke.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const SetupDialog(),
                    ),
                    child: const Text('Sigarayı Bırakma Yolculuğuna Başla'),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: const [
              ProgressCard(),
              SizedBox(height: 16),
              StatsCard(),
              SizedBox(height: 16),
              MotivationCard(),
              SizedBox(height: 16),
              GoalsCard(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(
          color: Colors.white,
          Icons.add,
        ),
        backgroundColor: Colors.grey[850]!,
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Hedef Ekle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Hedef',
            hintText: 'Hedefini buraya yaz',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<MotivationProvider>().addGoal(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
