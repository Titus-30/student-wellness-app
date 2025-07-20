import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyProtocolScreen extends StatelessWidget {
  final List<Protocol> _protocols;

  EmergencyProtocolScreen({super.key})
      : _protocols = [
    Protocol(
      title: 'Panic Attack',
      steps: [
        'Find a quiet space',
        'Practice deep breathing',
        'Focus on a single object',
        'Use grounding techniques',
      ],
      emergencyNumber: '911',
    ),
    // Add more protocols here if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Protocols'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFEF5350)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: _protocols.length,
          itemBuilder: (context, index) {
            final protocol = _protocols[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(
                  protocol.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...protocol.steps.map(
                            (step) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 20)),
                              Expanded(
                                child: Text(
                                  step,
                                  style: const TextStyle(fontSize: 16, height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone, size: 22),
                          label: Text(
                            'Call ${protocol.emergencyNumber}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            shadowColor: Colors.redAccent,
                          ),
                          onPressed: () async {
                            final Uri url = Uri(scheme: 'tel', path: protocol.emergencyNumber);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.platformDefault);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not call ${protocol.emergencyNumber}')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Protocol {
  final String title;
  final List<String> steps;
  final String emergencyNumber;

  Protocol({
    required this.title,
    required this.steps,
    required this.emergencyNumber,
  });
}
