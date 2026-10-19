import 'package:flutter/material.dart';

class PartnerScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  const PartnerScreen({super.key, this.onNavigateToTab});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Espace Partenaires & Flottes Entreprises',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Plateforme B2B pour les revendeurs agréés (enregistrement au comptoir) et les entreprises clientes (gestion de flotte).',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue.shade900,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue.shade900,
            tabs: const [
              Tab(icon: Icon(Icons.storefront), text: 'Espace Revendeurs / Points de Vente'),
              Tab(icon: Icon(Icons.business), text: 'Flotte d\'Entreprise'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResellerTab(),
                _buildEnterpriseTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResellerTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Boutique Partenaire : Baobab Mobile Point E\nInscrivez directement les appareils vendus en magasin pour déclencher la garantie client au moment de l\'achat.',
                      style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Stock d\'Appareils Déclarés & Assurés', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.onNavigateToTab != null) {
                    widget.onNavigateToTab!(1); // Redirige vers le formulaire de Souscription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ouverture du formulaire de souscription pour la nouvelle vente...')),
                    );
                  }
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Assurer une nouvelle vente'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DataTable(
            columns: const [
              DataColumn(label: Text('Appareil')),
              DataColumn(label: Text('N° IMEI / Série')),
              DataColumn(label: Text('Prix de Vente')),
              DataColumn(label: Text('Statut Assurance')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Samsung Galaxy S24 Ultra')),
                DataCell(Text('359102847102948')),
                DataCell(Text('750 000 FCFA')),
                DataCell(Chip(label: Text('Actif'), backgroundColor: Colors.greenAccent)),
              ]),
              DataRow(cells: [
                DataCell(Text('iPhone 15 Pro Max')),
                DataCell(Text('351029384756102')),
                DataCell(Text('850 000 FCFA')),
                DataCell(Chip(label: Text('Actif'), backgroundColor: Colors.greenAccent)),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnterpriseTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.corporate_fare, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Compte Professionnel : SOCI Sénégal SA\nTableau de bord de gestion centralisée de vos équipements informatiques d\'entreprise.',
                      style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Parc Informatique Assuré (24 Équipements)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Importation du fichier CSV/Excel du parc informatique réussie (24 appareils ajoutés) !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Importer une liste CSV / Excel'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.laptop, color: Colors.white)),
                  title: const Text('Lot de 15x Dell XPS 15 (Direction Générale)'),
                  subtitle: const Text('Contrat Flotte N° AVIVA-FLEET-004 • Couverture : Casse, Vol, Panne'),
                  trailing: const Text('15/15 Couverts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.phone_android, color: Colors.white)),
                  title: const Text('Lot de 9x Samsung A55 (Flotte Commerciale)'),
                  subtitle: const Text('Contrat Flotte N° AVIVA-FLEET-005 • Couverture : Casse d\'écran'),
                  trailing: const Text('9/9 Couverts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}