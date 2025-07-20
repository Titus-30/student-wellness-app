import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyProtocolScreen extends StatelessWidget {
  final List<Protocol> _protocols;

  EmergencyProtocolScreen({super.key})
      : _protocols = [
    Protocol(
      title: 'Panic Attack',
      steps: [
        'Find a quiet and safe space',
        'Breathe in slowly through your nose for 4 seconds',
        'Hold your breath for 7 seconds',
        'Exhale slowly through your mouth for 8 seconds',
        'Repeat this breathing cycle 3–5 times',
        'Focus on textures or colors around you',
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
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)], // Calm teal-blue gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          itemCount: _protocols.length,
          itemBuilder: (context, index) {
            final protocol = _protocols[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 5,
              color: Colors.white,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                title: Text(
                  protocol.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00796B), // deep teal text
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone, size: 22),
                          label: Text(
                            'Call ${protocol.emergencyNumber}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C), // Calmer green
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                            shadowColor: Colors.greenAccent,
                          ),
                          onPressed: () async {
                            final Uri url =
                            Uri(scheme: 'tel', path: protocol.emergencyNumber);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.platformDefault);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Could not call ${protocol.emergencyNumber}'),
                                  backgroundColor: Colors.redAccent,
                                ),
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
