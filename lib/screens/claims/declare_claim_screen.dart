import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class DeclareClaimScreen extends StatefulWidget {
  final VoidCallback? onGoToContracts;
  final VoidCallback? onGoToHome;

  const DeclareClaimScreen({super.key, this.onGoToContracts, this.onGoToHome});

  @override
  State<DeclareClaimScreen> createState() => _DeclareClaimScreenState();
}

class _DeclareClaimScreenState extends State<DeclareClaimScreen> {
  bool _isSubmitted = false;
  String _claimType = 'Casse d\'écran / Appareil';
  DateTime _selectedDate = DateTime.now();
  final List<String> _uploadedFiles = [];

  // Référence unifiée pour le scénario d'Awa
  final String _claimNumber = 'SIN-2026-001';

  void _openWindowsFileExplorer() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = '.pdf,.jpg,.png,.jpeg';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          for (var file in files) {
            _uploadedFiles.add(file.name);
          }
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildSubmittedScreen();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Déclarer un Sinistre', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Signalez un incident sur votre appareil assuré pour la prise en charge.'),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Type de sinistre', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _claimType,
                    items: ['Casse d\'écran / Appareil', 'Vol', 'Perte', 'Panne technique']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) => setState(() => _claimType = val!),
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),

                  const Text('Date exacte de l\'incident', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)),
                      child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Description des circonstances', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(hintText: 'Expliquez brièvement comment l\'incident est survenu...', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: _openWindowsFileExplorer,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Joindre des pièces (Photos, PV de dépôt)'),
                  ),
                  if (_uploadedFiles.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _uploadedFiles.map((f) => Chip(label: Text(f))).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isSubmitted = true),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
                      child: const Text('Soumettre la Déclaration'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(radius: 36, backgroundColor: Color(0xFFDCFCE7), child: Icon(Icons.check, color: Color(0xFF16A34A), size: 40)),
              const SizedBox(height: 20),
              const Text('Déclaration enregistrée !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Dossier N° $_claimNumber attribué. Notre équipe étudie les pièces transmises.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Numéro de dossier', style: TextStyle(color: Colors.grey)), Text(_claimNumber, style: const TextStyle(fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 8),
                    const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Appareil', style: TextStyle(color: Colors.grey)), Text('iPhone 13 Pro', style: TextStyle(fontWeight: FontWeight.bold))]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Statut', style: TextStyle(color: Colors.grey)), const Chip(label: Text('En cours d\'analyse', style: TextStyle(fontSize: 11)), backgroundColor: Color(0xFFFEF3C7))]),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onGoToContracts,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D5BD8), foregroundColor: Colors.white),
                  child: const Text('Suivre l\'avancement du dossier'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}