import 'package:flutter/material.dart';

class FaqSupportScreen extends StatefulWidget {
  const FaqSupportScreen({super.key});

  @override
  State<FaqSupportScreen> createState() => _FaqSupportScreenState();
}

class _FaqSupportScreenState extends State<FaqSupportScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Quels sont les appareils couverts par AVIVA SN ?',
      'answer': 'Nous couvrons les smartphones, tablettes, ordinateurs portables, montres connectées et appareils électroniques neufs ou d\'occasion.'
    },
    {
      'question': 'Comment déclarer un sinistre en cas de casse ou vol ?',
      'answer': 'Rendez-vous dans l\'onglet "Déclarer un Sinistre", sélectionnez le type d\'incident et téléversez une photo ou un document justificatif.'
    },
    {
      'question': 'Quels sont les délais d\'indemnisation ou de réparation ?',
      'answer': 'Les dossiers sont analysés sous 24h à 48h ouvrées. En cas de validation, l\'appareil est réparé en centre agréé ou indemnisé.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aide & Support Client',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Questions fréquentes et assistance en ligne AVIVA SN.'),
          const SizedBox(height: 24),

          // FAQ
          const Text('Questions Fréquentes (FAQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ..._faqs.map((faq) => ExpansionTile(
            title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faq['answer']!, style: const TextStyle(height: 1.4)),
              )
            ],
          )),

          const SizedBox(height: 32),

          // Section Nous Contacter
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nous Contacter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                  const SizedBox(height: 8),
                  const Text('Une question ou un besoin d\'assistance particulier ? Envoyez-nous un message direct.'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text('+221 33 800 00 00', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 24),
                      const Icon(Icons.email, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text('support@aviva.sn', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(labelText: 'Sujet de votre demande', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Votre message', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Votre message a été transmis à notre service client !'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _subjectController.clear();
                      _messageController.clear();
                    },
                    icon: const Icon(Icons.send),
                    label: const Text('Envoyer le message'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}