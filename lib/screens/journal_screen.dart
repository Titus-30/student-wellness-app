import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Journal'),
          elevation: 2,
          backgroundColor: theme.primaryColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Title input with shadow container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter a title for your entry',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  style: theme.textTheme.titleMedium,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 20),
              // Content input with shadow container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Write your thoughts...',
                      hintText: 'What\'s on your mind today?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    backgroundColor: theme.primaryColor,
                    elevation: 5,
                    shadowColor: theme.primaryColor.withOpacity(0.4),
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                      final entry = JournalEntry(
                        id: DateTime.now().toString(),
                        userId: 'Titus Mucyo', // Replace with actual user id
                        date: DateTime.now(),
                        title: _titleController.text,
                        content: _contentController.text,
                      );

                      Provider.of<JournalProvider>(context, listen: false).addEntry(entry);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in both title and content')),
                      );
                    }
                  },
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
