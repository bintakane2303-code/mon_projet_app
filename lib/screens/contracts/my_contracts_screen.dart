import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class MyContractsScreen extends StatefulWidget {
  const MyContractsScreen({super.key});

  @override
  State<MyContractsScreen> createState() => _MyContractsScreenState();
}

class _MyContractsScreenState extends State<MyContractsScreen> {
  // Génération de l'Attestation Officielle au format HTML/PDF imprimable
  void _downloadAttestation({
    required String clientName,
    required String clientEmail,
    required String policyNumber,
    required String deviceName,
    required String imeiNumber,
    required String formulaName,
    required String annualPrice,
  }) {
    final String htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <title>Attestation d'Assurance AVIVA SN - $policyNumber</title>
        <style>
          body { font-family: 'Segoe UI', Arial, sans-serif; padding: 40px; color: #1f2937; line-height: 1.5; max-width: 850px; margin: 0 auto; }
          .container { border: 2px solid #1D5BD8; padding: 30px; border-radius: 4px; }
          .header-title { text-align: center; font-size: 20px; font-weight: bold; color: #1D5BD8; text-transform: uppercase; border-bottom: 2px solid #1D5BD8; padding-bottom: 12px; margin-bottom: 24px; letter-spacing: 0.5px; }
          .section-banner { background-color: #f0f4ff; border-left: 4px solid #1D5BD8; padding: 8px 12px; font-weight: bold; color: #1D5BD8; font-size: 14px; text-transform: uppercase; margin-top: 20px; margin-bottom: 12px; }
          .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 13px; }
          .grid-item { margin-bottom: 6px; }
          .label { color: #4b5563; font-weight: bold; }
          .value { color: #111827; }
          .status-active { color: #16a34a; font-weight: bold; }
          .validity-box { background-color: #fafafa; border: 1px solid #e5e7eb; padding: 14px; border-radius: 6px; font-size: 12px; color: #374151; margin-top: 20px; line-height: 1.6; }
          .footer-signature { margin-top: 40px; display: flex; justify-content: space-between; align-items: flex-end; font-size: 13px; }
          .signature-block { text-align: right; }
          .btn-print { background-color: #1D5BD8; color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px; }
          @media print { .no-print { display: none; } }
        </style>
      </head>
      <body>
        <div class="no-print" style="margin-bottom: 20px; text-align: right;">
          <button class="btn-print" onclick="window.print()">🖨️ Imprimer / Enregistrer en PDF</button>
        </div>

        <div class="container">
          <div class="header-title">Attestation Officielle de Police d'Assurance</div>

          <div class="section-banner">1. Identification du Souscripteur / Assuré</div>
          <div class="grid">
            <div class="grid-item"><span class="label">Nom et Prénom :</span> <span class="value">$clientName</span></div>
            <div class="grid-item"><span class="label">Adresse E-mail :</span> <span class="value">$clientEmail</span></div>
            <div class="grid-item"><span class="label">Numéro de Police :</span> <span class="value"><strong>$policyNumber</strong></span></div>
            <div class="grid-item"><span class="label">Statut du Contrat :</span> <span class="status-active">ACTIF / CONFORME</span></div>
          </div>

          <div class="section-banner">2. Caractéristiques Techniques de l'Équipement Assuré</div>
          <div class="grid">
            <div class="grid-item"><span class="label">Désignation Appareil :</span> <span class="value">$deviceName</span></div>
            <div class="grid-item"><span class="label">Numéro IMEI / N° Série :</span> <span class="value"><strong>$imeiNumber</strong></span></div>
            <div class="grid-item"><span class="label">État à la Souscription :</span> <span class="value">Neuf / Certifié</span></div>
            <div class="grid-item"><span class="label">Valeur Déclarée :</span> <span class="value">Conforme aux barèmes AVIVA SN ($formulaName - $annualPrice)</span></div>
          </div>

          <div class="section-banner">3. Nature des Garanties & Période de Couverture</div>
          <div class="grid" style="grid-template-columns: 1fr;">
            <div class="grid-item"><span class="label">Garanties souscrites :</span> <span class="value">Casse d'écran, Dommages matériels accidentels, Vol qualifié avec effraction, Pannes techniques</span></div>
            <div class="grid-item"><span class="label">Période d'effet :</span> <span class="value">Du 12/09/2026 au 12/09/2027 (Minuit)</span></div>
            <div class="grid-item"><span class="label">Territorialité :</span> <span class="value">République du Sénégal et déplacements temporaires Monde Entier (UEMOA/International)</span></div>
          </div>

          <div class="validity-box">
            <strong>Attestation de validité :</strong><br>
            La présente attestation est délivrée pour servir et valoir ce que de droit. Elle certifie que l'équipement désigné ci-dessus bénéficie des garanties du contrat d'assurance multirisque objets connectés souscrit auprès d'AVIVA SN SARL, sous réserve du paiement effectif des cotisations et du respect des conditions générales et particulières de la police.
          </div>

          <div class="footer-signature">
            <div>
              <br><br>
              <strong>Signature de l'Assuré</strong><br>
              <em>$clientName</em>
            </div>
            <div class="signature-block">
              Fait à Dakar, le 12/09/2026<br><br>
              <strong>La Direction Générale</strong><br>
              <strong style="color: #1D5BD8;">AVIVA SN SARL</strong>
            </div>
          </div>
        </div>

        <script>
          window.onload = function() { window.print(); };
        </script>
      </body>
      </html>
    ''';

    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Contrats Assurés & Suivi de Dossiers',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text('Titulaire : Client Assuré (testeravivasn@gmail.com)', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),

          // ---------------- CONTRAT 1 : HAUT DE GAMME (VALIDÉ) ----------------
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFF1D5BD8).withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.phone_iphone, color: Color(0xFF1D5BD8), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('iPhone 13 Pro (256 Go) - Neuf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text('N° Police : AVIVA-2026-8841 • IMEI : 356789101112131', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('Statut Contrat : Actif | Échéance : 12/09/2027', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _downloadAttestation(
                          clientName: 'Client Assuré',
                          clientEmail: 'testeravivasn@gmail.com',
                          policyNumber: 'AVIVA-2026-8841',
                          deviceName: 'iPhone 13 Pro (256 Go)',
                          imeiNumber: '356789101112131',
                          formulaName: 'Haut de Gamme',
                          annualPrice: '54 000 FCFA/an',
                        ),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Attestation PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D5BD8),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ENCART SUIVI DE DOSSIER DE SINISTRE (SIN-2026-001)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Sinistre Déclaré N° SIN-2026-001 (Casse d\'écran)',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E), fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Étape actuelle : En cours d\'analyse par l\'équipe sinistres AVIVA SN',
                          style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                        ),
                        const SizedBox(height: 16),

                        // Frise chronologique de suivi
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStepDot(label: 'Reçu', isCompleted: true, isActive: false),
                            _buildStepLine(isCompleted: true),
                            _buildStepDot(label: 'En cours d\'analyse', isCompleted: true, isActive: true),
                            _buildStepLine(isCompleted: false),
                            _buildStepDot(label: 'Validé', isCompleted: false, isActive: false),
                            _buildStepLine(isCompleted: false),
                            _buildStepDot(label: 'Indemnisé', isCompleted: false, isActive: false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- CONTRAT 2 : MILIEU DE GAMME (EN ATTENTE DE VALIDATION BACK-OFFICE) ----------------
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(Icons.smartphone, color: Colors.grey, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Samsung Galaxy A54 (128 Go)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 2),
                            Text('N° Police : AVIVA-2026-9012 • IMEI : 864201357924680', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('Formule : Milieu de Gamme (30 000 FCFA/an)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(16)),
                        child: const Text('STATUT : PAYÉE (EN COURS DE VALIDATION)', style: TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lock_clock, size: 16, color: Colors.grey),
                          SizedBox(width: 6),
                          Text('Souscription enregistrée. En attente de contrôle par l\'Agent AVIVA.', style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: null, // Restreint tant que l'Agent n'a pas validé
                        icon: const Icon(Icons.lock_outline, size: 16),
                        label: const Text('Attestation Inactive'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDot({required String label, required bool isCompleted, required bool isActive}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isCompleted ? const Color(0xFFEA580C) : Colors.grey.shade300,
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : CircleAvatar(radius: 5, backgroundColor: isActive ? const Color(0xFFEA580C) : Colors.transparent),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
            color: isCompleted || isActive ? const Color(0xFF9A3412) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 3,
        color: isCompleted ? const Color(0xFFEA580C) : Colors.grey.shade300,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}