import 'package:flutter/material.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final String userRole;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.userRole = 'Client / Assuré',
  });

  @override
  Widget build(BuildContext context) {
    bool isClient = userRole.contains('Client');
    bool isPartner = userRole.contains('Partenaire');

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: true,
      minExtendedWidth: 240,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            Image.asset(
              'assets/aviva_logo.png',
              height: 36,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shield,
                size: 36,
                color: Color(0xFF1D5BD8),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'AVIVA',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1D5BD8),
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Accueil'),
        ),
        if (isClient) ...[
          const NavigationRailDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: Text('Souscrire'),
          ),
          const NavigationRailDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: Text('Mes Contrats'),
          ),
          const NavigationRailDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning),
            label: Text('Sinistres'),
          ),
        ],
        if (isPartner) ...[
          const NavigationRailDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: Text('Partenaires / Flottes'),
          ),
        ],
        const NavigationRailDestination(
          icon: Icon(Icons.help_outline),
          selectedIcon: Icon(Icons.help),
          label: Text('Aide & FAQ'),
        ),
      ],
    );
  }
}