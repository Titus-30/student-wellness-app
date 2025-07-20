import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  EmergencyScreen({super.key});

  final List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'University Counseling',
      phone: '078-121-8195',
      description: '24/7 mental health support',
    ),
    EmergencyContact(
      name: 'Crisis Hotline',
      phone: '988',
      description: 'National suicide prevention lifeline',
    ),
    // Add more contacts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _callNumber(context, contact.phone),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  leading: const Icon(Icons.emergency, color: Colors.redAccent, size: 32),
                  title: Text(
                    contact.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      contact.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  trailing: Icon(
                    Icons.phone,
                    size: 28,
                    color: Colors.green[700],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _callNumber(BuildContext context, String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.platformDefault);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not call $phoneNumber')),
      );
    }
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String description;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.description,
  });
}
