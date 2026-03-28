import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'Usuario';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hola, $userName 👋',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSlate900,
                            ),
                          ),
                          const Text(
                            '¿Qué medicamento buscas hoy?',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSlate500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 2),
                          image: DecorationImage(
                            image: NetworkImage(user?.photoURL ?? 'https://ui-avatars.com/api/?name=$userName&background=1a6b3c&color=fff'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Main Action Cards
                  _buildActionCard(
                    context: context,
                    title: 'Escanear Receta',
                    subtitle: 'Escanea tu receta física',
                    icon: Icons.photo_camera_rounded,
                    isPrimary: true,
                    onTap: () {
                      // TODO: Fase 4 – Scanner OCR
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Escáner próximamente')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildActionCard(
                    context: context,
                    title: 'Buscar Medicamento',
                    subtitle: 'Escribe el nombre o marca',
                    icon: Icons.search_rounded,
                    isPrimary: false,
                    onTap: () => Navigator.pushNamed(context, '/search'),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Recent Searches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Búsquedas recientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSlate900,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Ver todo', style: TextStyle(color: AppTheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRecentChip('Paracetamol'),
                        _buildRecentChip('Ibuprofeno'),
                        _buildRecentChip('Amoxicilina'),
                        _buildRecentChip('Loratadina'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Promotion Card
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1586015555751-63bb77f4322a?q=80&w=1000&auto=format&fit=crop'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primary.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NUEVO SERVICIO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Entrega a domicilio\nen 30 mins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(ref),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary ? null : Border.all(color: AppTheme.primary.withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
              color: isPrimary ? AppTheme.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPrimary ? Colors.white : AppTheme.primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isPrimary ? Colors.white.withOpacity(0.8) : AppTheme.textSlate500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withOpacity(0.2) : AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isPrimary ? Colors.white : AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildBottomNav(WidgetRef ref) {
    return Builder(
      builder: (context) => Container(
      padding: const EdgeInsets.only(bottom: 30, top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavButton(Icons.home_rounded, 'Inicio', true),
              _buildNavButton(Icons.history_rounded, 'Historial', false, onTap: () {
                Navigator.pushNamed(context, '/history');
              }),
              const SizedBox(width: 48), // Espacio para el botón flotante
              _buildNavButton(Icons.receipt_long_rounded, 'Recetas', false),
              _buildNavButton(Icons.person_rounded, 'Perfil', false, onTap: () {
                ref.read(authNotifierProvider.notifier).signOut();
              }),
            ],
          ),
          Positioned(
            top: -40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/search'),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.backgroundLight, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppTheme.primary : AppTheme.textSlate400),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? AppTheme.primary : AppTheme.textSlate400,
            ),
          ),
        ],
      ),
    );
  }
}
