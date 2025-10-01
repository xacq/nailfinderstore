import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class DashboardCoursesBanner extends StatelessWidget {
  const DashboardCoursesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [kDashboardSecondaryAccent, kDashboardAccentColorLight],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kDashboardAccentColor.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kDashboardAccentColor, kDashboardAccentColorLight],
                ),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/ui/logo_ui.png',
                width: 56,
                height: 56,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cursos',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ).copyWith(color: kDashboardAccentColor),
                ),
                const SizedBox(height: 6),
                Text(
                  'Aprende o actualízate',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: kDashboardDarkColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Descubre talleres y cursos para mejorar tus técnicas profesionales.',
                  style: TextStyle(
                    fontSize: 13,
                    color: kDashboardDarkColor.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
