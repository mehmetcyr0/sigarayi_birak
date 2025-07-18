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
          if (!smokingData.hasQuitDate) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.smoke_free,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sigarayı Bırak',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sağlıklı bir yaşam için ilk adımı at',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
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
        backgroundColor: Colors.grey[850]!,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
