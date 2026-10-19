import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widgets/sidebar_navigation.dart';
import '../subscription/formulas_screen.dart';
import '../claims/declare_claim_screen.dart';
import '../contracts/my_contracts_screen.dart';
import '../partner/partner_screen.dart';
import '../support/faq_support_screen.dart';
import '../admin/admin_claims_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final String role = user?.userMetadata?['role'] ?? 'Client / Assuré';

    List<Widget> pages = [];

    if (role.contains('Client')) {
      pages = [
        const _HomeView(),
        FormulasScreen(onGoToContracts: () => setState(() => _currentIndex = 2)),
        const MyContractsScreen(),
        DeclareClaimScreen(
          onGoToContracts: () => setState(() => _currentIndex = 2),
          onGoToHome: () => setState(() => _currentIndex = 0),
        ),
        const FaqSupportScreen(),
      ];
    } else if (role.contains('Partenaire')) {
      pages = [
        const _HomeView(),
        PartnerScreen(onNavigateToTab: (idx) => setState(() => _currentIndex = idx)),
        const FaqSupportScreen(),
      ];
    } else {
      // Gestionnaire / Agent
      pages = [
        const AdminClaimsScreen(role: 'gestionnaire'),
        const FaqSupportScreen(),
      ];
    }

    return Scaffold(
      body: Row(
        children: [
          SidebarNavigation(
            selectedIndex: _currentIndex,
            userRole: role,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Espace $role', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          const Icon(Icons.account_circle, color: Color(0xFF2563EB)),
                          const SizedBox(width: 8),
                          Text(user?.email ?? 'client@aviva.sn'),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.red),
                            onPressed: () async => await Supabase.instance.client.auth.signOut(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(child: pages[_currentIndex < pages.length ? _currentIndex : 0]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenue sur votre espace AVIVASN', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard(context, 'Contrats Actifs', '1', Icons.verified_user, Colors.green),
              const SizedBox(width: 16),
              _buildStatCard(context, 'Devis en cours', '2', Icons.pending_actions, Colors.orange),
              const SizedBox(width: 16),
              _buildStatCard(context, 'Sinistres déclarés', '1', Icons.report_problem, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey)),
                  Text(count, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}