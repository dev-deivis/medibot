import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../data/models/medication.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textSlate900),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle del medicamento',
          style: TextStyle(
            color: AppTheme.textSlate900,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medication_rounded, color: AppTheme.primary, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            if (medication.brand.isNotEmpty)
                              Text(
                                medication.brand,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSlate500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Información principal
            _InfoCard(
              children: [
                _InfoRow(
                  icon: Icons.science_outlined,
                  label: 'Principio activo',
                  value: medication.genericName.isNotEmpty
                      ? medication.genericName
                      : 'No especificado',
                ),
                const Divider(height: 24),
                _InfoRow(
                  icon: Icons.straighten_outlined,
                  label: 'Dosis',
                  value: medication.dosage.isNotEmpty ? medication.dosage : 'No especificada',
                ),
                const Divider(height: 24),
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Forma farmacéutica',
                  value: medication.form.isNotEmpty ? medication.form : 'No especificada',
                ),
                if (medication.activeIngredients.isNotEmpty) ...[
                  const Divider(height: 24),
                  _InfoRow(
                    icon: Icons.list_alt_outlined,
                    label: 'Ingredientes activos',
                    value: medication.activeIngredients.join(', '),
                  ),
                ],
              ],
            ),

            // Descripción
            if (medication.description != null && medication.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _InfoCard(
                children: [
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSlate900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medication.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSlate500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Aviso legal (RD-05)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.amber.shade700, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Esta información es de carácter informativo y no reemplaza la consulta médica. Siempre consulta a un profesional de la salud antes de automedicarte.',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mapa de farmacias próximamente')),
          );
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.local_pharmacy_outlined, color: Colors.white),
        label: const Text(
          'Ver farmacias cercanas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSlate500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textSlate900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
