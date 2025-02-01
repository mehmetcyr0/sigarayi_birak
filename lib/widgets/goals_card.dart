import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/motivation_provider.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hedeflerim',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Consumer<MotivationProvider>(
              builder: (context, provider, child) {
                if (provider.goals.isEmpty) {
                  return const Center(
                    child: Text(
                      'Henüz hedef eklemedin.\nYeni hedef eklemek için + butonuna tıkla!',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.goals.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.flag),
                      title: Text(provider.goals[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        onPressed: () {
                          provider.addAchievement(provider.goals[index]);
                          provider.removeGoal(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tebrikler! Hedefe ulaştın!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}