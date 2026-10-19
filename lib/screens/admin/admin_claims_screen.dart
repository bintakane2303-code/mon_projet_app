import 'package:flutter/material.dart';

class AdminClaimsScreen extends StatefulWidget {
  final String role; // 'gestionnaire' ou 'agent'
  const AdminClaimsScreen({super.key, this.role = 'gestionnaire'});

  @override
  State<AdminClaimsScreen> createState() => _AdminClaimsScreenState();
}

class _AdminClaimsScreenState extends State<AdminClaimsScreen> {
  String _selectedFilter = 'Tous';

  // Liste de données simulées
  final List<Map<String, dynamic>> _claimsData = [
    {'id': 'SIN-2026-001', 'client': 'Bineta KANE', 'device': 'iPhone 13 Pro', 'type': 'Casse écran', 'date': '12/10/2026', 'status': 'En cours d\'analyse', 'color': Colors.orange},
    {'id': 'SIN-2026-002', 'client': 'Amina BÂ', 'device': 'Samsung S24', 'type': 'Vol qualifié', 'date': '10/10/2026', 'status': 'Validés', 'color': Colors.blue},
    {'id': 'SIN-2026-003', 'client': 'Mamadou DIOP', 'device': 'MacBook Pro M2', 'type': 'Panne carte mère', 'date': '08/10/2026', 'status': 'Indemnisés / Rejetés', 'color': Colors.green},
    {'id': 'SIN-2026-004', 'client': 'SOCI Sénégal', 'device': 'Dell XPS 15', 'type': 'Dégât des eaux', 'date': '05/10/2026', 'status': 'Reçu', 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> _subscriptionsData = [
    {'id': 'SUB-8841', 'client': 'Bineta KANE', 'device': 'iPhone 13 Pro', 'prime': '75 000 FCFA/an', 'payment': 'Wave', 'status': 'Validés', 'color': Colors.green},
    {'id': 'SUB-9012', 'client': 'SOCI Sénégal', 'device': 'Flotte Dell XPS (15x)', 'prime': '1 200 000 FCFA/an', 'payment': 'Virement', 'status': 'Validés', 'color': Colors.green},
    {'id': 'SUB-9045', 'client': 'Ousmane SOW', 'device': 'HP Spectre x360', 'prime': '85 000 FCFA/an', 'payment': 'Orange Money', 'status': 'Reçu', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    final isGestionnaire = widget.role == 'gestionnaire';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGestionnaire ? 'File de traitement des Sinistres' : 'Gestion des Souscriptions & Contrats',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isGestionnaire
                        ? 'Espace réservé au Gestionnaire Sinistres AVIVA SN'
                        : 'Espace réservé à l\'Agent Commercial AVIVA SN',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Chip(
                avatar: const Icon(Icons.admin_panel_settings, size: 18, color: Colors.white),
                label: Text(isGestionnaire ? 'Profil: Gestionnaire' : 'Profil: Agent AVIVA'),
                backgroundColor: Colors.indigo.shade800,
                labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Tous', 'Reçu', 'En cours d\'analyse', 'Validés', 'Indemnisés / Rejetés'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedFilter = filter),
                    selectedColor: Colors.blue.shade100,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Liste filtrée
          Expanded(
            child: Card(
              elevation: 2,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: isGestionnaire ? _buildFilteredClaims() : _buildFilteredSubscriptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredClaims() {
    final filtered = _claimsData.where((item) {
      if (_selectedFilter == 'Tous') return true;
      return item['status'] == _selectedFilter;
    }).toList();

    if (filtered.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('Aucun sinistre dans cette catégorie.')),
        )
      ];
    }

    return filtered
        .map((item) => _buildClaimRow(
      item['id'],
      item['client'],
      item['device'],
      item['type'],
      item['date'],
      item['status'],
      item['color'],
    ))
        .toList();
  }

  List<Widget> _buildFilteredSubscriptions() {
    final filtered = _subscriptionsData.where((item) {
      if (_selectedFilter == 'Tous') return true;
      return item['status'] == _selectedFilter;
    }).toList();

    if (filtered.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('Aucune souscription dans cette catégorie.')),
        )
      ];
    }

    return filtered
        .map((item) => _buildSubRow(
      item['id'],
      item['client'],
      item['device'],
      item['prime'],
      item['payment'],
      item['status'],
      item['color'],
    ))
        .toList();
  }

  Widget _buildClaimRow(String id, String client, String device, String type, String date, String status, Color statusColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.2),
        child: Icon(Icons.assignment, color: statusColor),
      ),
      title: Text('$id — $client ($device)', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Type: $type • Déclaré le: $date'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
            backgroundColor: statusColor.withOpacity(0.1),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.visibility, color: Colors.blue),
            tooltip: 'Examiner le dossier',
            onPressed: () => _showClaimDetailDialog(id, client, device, type, status),
          ),
        ],
      ),
    );
  }

  Widget _buildSubRow(String id, String client, String device, String prime, String payment, String status, Color statusColor) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: statusColor.withOpacity(0.2), child: Icon(Icons.verified, color: statusColor)),
      title: Text('$id — $client', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Équipement: $device • Prime: $prime ($payment)'),
      trailing: Chip(
        label: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
        backgroundColor: statusColor.withOpacity(0.1),
      ),
    );
  }

  void _showClaimDetailDialog(String id, String client, String device, String type, String status) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Traitement du Sinistre $id'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client : $client', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Appareil : $device'),
            Text('Incident : $type'),
            const SizedBox(height: 16),
            const Text('Pièces téléversées par le client :'),
            const ListTile(
              leading: Icon(Icons.description, color: Colors.blue),
              title: Text('Document_Justificatif_Sinistre.pdf'),
              subtitle: Text('2.4 Mo • Téléversé le 12/10/2026'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer')),
        ],
      ),
    );
  }
}