import 'package:flutter/material.dart';

class MeditationScreen extends StatelessWidget {
  MeditationScreen({super.key});

  final List<MeditationSession> sessions = [
    MeditationSession(
      title: 'Basic Breathing',
      duration: '5 min',
      description: 'Learn basic breathing techniques for stress relief',
      isPremium: false,
    ),
    MeditationSession(
      title: 'Deep Relaxation',
      duration: '15 min',
      description: 'Guided meditation for deep relaxation',
      isPremium: true,
    ),
    // Add more sessions here if needed
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meditation Center')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome To,', style: theme.textTheme.titleMedium),
                        Text('Meditation Centre', style: theme.textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      // TODO: Implement start button action
                    },
                    child: const Text("Let's Start →"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // User Greeting
            Text(
              'Welcome Back\nTitus Mucyo!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // Categories Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Calm', 'Sleep', 'Focus', 'Breath'].map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Chip(
                      label: Text(category),
                      backgroundColor: Colors.blue.shade100,
                      labelStyle: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Motivation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ready to start your first session?',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Motivation is calm again!',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.purple.shade400,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),
                  const Text('20 Minutes'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sessions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meditations',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement view all action
                  },
                  child: const Text('View all'),
                ),
              ],
            ),

            // Meditation Sessions List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return MeditationCard(session: session);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationCard extends StatelessWidget {
  final MeditationSession session;

  const MeditationCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Premium Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (session.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PREMIUM',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(session.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 16),

            // Duration and Start Button
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(session.duration, style: theme.textTheme.bodyMedium),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    // TODO: Implement start session functionality
                  },
                  child: const Text('Start'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationSession {
  final String title;
  final String duration;
  final String description;
  final bool isPremium;

  MeditationSession({
    required this.title,
    required this.duration,
    required this.description,
    this.isPremium = false,
  });
}
