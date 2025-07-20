import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mood.dart';
import '../providers/mood_provider.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;
  int intensity = 3;
  final TextEditingController _notesController = TextEditingController();

  final List<String> moodTypes = [
    'Happy', 'Sad', 'Angry', 'Anxious', 'Tired', 'Excited', 'Peaceful'
  ];

  final Map<String, IconData> moodIcons = {
    'Happy': Icons.sentiment_satisfied_alt,
    'Sad': Icons.sentiment_dissatisfied,
    'Angry': Icons.sentiment_very_dissatisfied,
    'Anxious': Icons.sentiment_neutral,
    'Tired': Icons.bedtime,
    'Excited': Icons.emoji_events,
    'Peaceful': Icons.self_improvement,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Log Your Mood')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: moodTypes.map((mood) {
                final isSelected = selectedMood == mood;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(moodIcons[mood], size: 18, color: isSelected ? Colors.white : Colors.black54),
                      const SizedBox(width: 6),
                      Text(mood),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: Colors.blueAccent.shade100,
                  backgroundColor: Colors.grey.shade200,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      selectedMood = selected ? mood : null;
                    });
                  },
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            Text(
              'Intensity: $intensity',
              style: theme.textTheme.titleMedium,
            ),

            Slider(
              value: intensity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.blueAccent.shade100,
              label: intensity.toString(),
              onChanged: (value) {
                setState(() {
                  intensity = value.toInt();
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Any notes about your mood?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (selectedMood != null) {
                    final mood = Mood(
                      id: DateTime.now().toString(),
                      userId: 'current_user_id', // Replace with actual user ID
                      date: DateTime.now(),
                      moodType: selectedMood!,
                      intensity: intensity,
                      notes: _notesController.text,
                    );

                    Provider.of<MoodProvider>(context, listen: false).addMood(mood);

                    // Clear inputs & reset
                    setState(() {
                      selectedMood = null;
                      intensity = 3;
                      _notesController.clear();
                    });

                    // Show confirmation snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mood saved!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a mood')),
                    );
                  }
                },
                child: const Text('Save Mood'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
