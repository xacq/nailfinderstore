import 'package:flutter/material.dart';

import '../dashboard_palette.dart';

class DashboardCircleIconButton extends StatelessWidget {
  const DashboardCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kDashboardCardTintColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: kDashboardDarkColor, size: 22),
        ),
      ),
    );
  }
}

class DashboardReservationCard extends StatelessWidget {
  const DashboardReservationCard({
    super.key,
    this.day = '15',
    this.month = 'DIC',
    this.storeName = 'Nail Finder Store',
    this.address = 'Avenida Yucatán 69, Ciudad de México',
    this.time = '05:30 PM',
    this.onDirectionsTap,
  });

  final String day;
  final String month;
  final String storeName;
  final String address;
  final String time;
  final VoidCallback? onDirectionsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kDashboardCardTintColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kDashboardAccentColorLight.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 92,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kDashboardAccentColor, kDashboardAccentColorLight],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima reserva',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ).copyWith(color: kDashboardDarkColor),
                ),
                const SizedBox(height: 8),
                Text(
                  storeName,
                  style: const TextStyle(
                    color: kDashboardDarkColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: TextStyle(
                    color: kDashboardDarkColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: kDashboardDarkColor),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        color: kDashboardDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onDirectionsTap,
                      style: TextButton.styleFrom(
                        foregroundColor: kDashboardAccentColor,
                      ),
                      child: const Text('Cómo llegar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
