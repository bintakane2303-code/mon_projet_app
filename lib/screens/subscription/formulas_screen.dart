import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class FormulasScreen extends StatefulWidget {
  final VoidCallback? onGoToContracts;
  const FormulasScreen({super.key, this.onGoToContracts});

  @override
  State<FormulasScreen> createState() => _FormulasScreenState();
}

class _FormulasScreenState extends State<FormulasScreen> {
  int _step = 1; // 1: Formule, 2: Justificatifs, 3: Paiement, 4: Notification Réception
  String _selectedFormule = 'Haut de Gamme';
  String _price = '4500';
  String _selectedPaymentMethod = 'Wave';
  bool _hasInitiatedPayment = false;

  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvcController = TextEditingController();
  final _cardHolderController = TextEditingController();

  final List<String> _uploadedJustificatifs = [];
  final String _wavePaymentUrl = 'https://pay.wave.com/m/M_sn_RLyUrgHSygTC/c/sn/';

  void _triggerWavePayment() {
    html.window.open(_wavePaymentUrl, '_blank');
    setState(() {
      _hasInitiatedPayment = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 4) {
      return _buildPendingValidationScreen();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Souscrire une assurance', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const Text('Protégez votre appareil en quelques étapes.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepIndicator(1, 'Formule', _step >= 1),
              _buildStepLine(_step >= 2),
              _buildStepIndicator(2, 'Justificatifs', _step >= 2),
              _buildStepLine(_step >= 3),
              _buildStepIndicator(3, 'Paiement', _step >= 3),
            ],
          ),
          const SizedBox(height: 28),

          if (_step == 1) _buildFormulesSelection(),
          if (_step == 2) _buildJustificatifsStep(),
          if (_step == 3) _buildPaymentStep(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isActive ? const Color(0xFF1D5BD8) : Colors.grey.shade300,
          child: Text('$step', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: isActive ? const Color(0xFF1D5BD8) : Colors.grey)),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 60,
      height: 2,
      color: isActive ? const Color(0xFF1D5BD8) : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    );
  }

  // Étape 1 : Formules Solo & Formule Téranga (Calcul exact : 55% d'économie)
  Widget _buildFormulesSelection() {
    return Column(
      children: [
        const Text('Formule Solo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('Protection pour un seul appareil', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTarifCard('Entrée de Gamme', 'Tecno, Itel < 100k FCFA', '1500', '18 000 FCFA/an', Colors.blue.shade100)),
            const SizedBox(width: 16),
            Expanded(child: _buildTarifCard('Milieu de Gamme', 'Samsung, Xiaomi 100k-300k', '2500', '30 000 FCFA/an', Colors.blue.shade200)),
            const SizedBox(width: 16),
            Expanded(child: _buildTarifCard('Haut de Gamme', 'iPhone 13 Pro, S22 > 300k', '4500', '54 000 FCFA/an', Colors.blue.shade300)),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Formule Téranga', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('Protection Familiale jusqu\'à 5 appareils', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Formule Famille', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('10 000 Francs / mois (120 000 FCFA/an)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D5BD8))),
                const SizedBox(height: 12),
                const Text('• Couvre jusqu\'à 5 appareils mixtes\n• Économie réelle de 55% par rapport à 5 formules Solo\n• Couverture multirisque selon Conditions Générales\n• Réparation sous 72h', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.5)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _selectedFormule = 'Formule Famille';
                    _price = '10000';
                    _step = 2;
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
                  child: const Text('Souscrire'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarifCard(String title, String subtitle, String priceMonth, String priceYear, Color bg) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text('$priceMonth FCFA / mois', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D5BD8))),
            Text('($priceYear)', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            const Text('• Écran cassé\n• Protection vol & oxydation\n• Surtension électrique', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, height: 1.4)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {
                _selectedFormule = title;
                _price = priceMonth;
                _step = 2;
              }),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
              child: const Text('Souscrire'),
            ),
          ],
        ),
      ),
    );
  }

  // Étape 2 : Justificatifs
  Widget _buildJustificatifsStep() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Justificatifs Requis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Téléversez vos pièces justificatives.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 20),
                _buildUploadBox('Facture d\'achat *'),
                const SizedBox(height: 12),
                _buildUploadBox('Photo de l\'IMEI / Série *'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(onPressed: () => setState(() => _step = 1), child: const Text('Retour')),
                    ElevatedButton(
                      onPressed: () => setState(() => _step = 3),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
                      child: const Text('Continuer vers le paiement'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            setState(() => _uploadedJustificatifs.add(title));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Document ajouté : $title')));
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: Colors.grey.shade50),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text('Cliquez pour sélectionner un fichier', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Étape 3 : Paiement
  Widget _buildPaymentStep() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Règlement de la souscription ($_price FCFA)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  items: ['Wave', 'Carte Bancaire', 'Orange Money', 'Free Money']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) => setState(() {
                    _selectedPaymentMethod = val!;
                    _hasInitiatedPayment = false;
                  }),
                  decoration: const InputDecoration(labelText: 'Moyen de paiement', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                if (_selectedPaymentMethod == 'Wave') ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.cyan.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.cyan.shade200)),
                    child: Column(
                      children: [
                        const Text('Paiement sécurisé Wave Business', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan)),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _triggerWavePayment,
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Ouvrir l\'application Wave'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan.shade800, foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],

                if (_selectedPaymentMethod == 'Carte Bancaire') ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                    child: Column(
                      children: [
                        TextField(controller: _cardNumberController, decoration: const InputDecoration(labelText: 'Numéro de Carte Bancaire', hintText: '4000 1234 5678 9010', border: OutlineInputBorder())),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: TextField(controller: _cardExpiryController, decoration: const InputDecoration(labelText: 'Expire (MM/AA)', hintText: '12/28', border: OutlineInputBorder()))),
                            const SizedBox(width: 12),
                            Expanded(child: TextField(controller: _cardCvcController, obscureText: true, decoration: const InputDecoration(labelText: 'CVC', hintText: '123', border: OutlineInputBorder()))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(controller: _cardHolderController, decoration: const InputDecoration(labelText: 'Nom du titulaire', border: OutlineInputBorder())),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(onPressed: () => setState(() => _step = 2), child: const Text('Retour')),
                    ElevatedButton(
                      onPressed: () => setState(() => _step = 4),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
                      child: const Text('Valider et Soumettre le dossier'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Étape 4 : Statut PAYÉE & En cours de validation
  Widget _buildPendingValidationScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 36, backgroundColor: Color(0xFFFEF3C7), child: Icon(Icons.hourglass_top_rounded, color: Color(0xFFD97706), size: 40)),
            const SizedBox(height: 20),
            const Text('Souscription reçue, en cours de validation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
              child: const Text('STATUT : PAYÉE', style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 13)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre paiement et vos pièces justificatives ont été enregistrés.\nUn agent AVIVA vérifie actuellement votre dossier. Dès validation, votre contrat deviendra actif et votre attestation PDF sera disponible.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: widget.onGoToContracts,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
              child: const Text('Consulter mes contrats'),
            ),
          ],
        ),
      ),
    );
  }
}