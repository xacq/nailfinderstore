import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_palette.dart';
import 'widgets/dashboard_common_widgets.dart';
import 'widgets/dashboard_courses_banner.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stores = const [
      _StoreItem(
        name: 'Tienditas',
        description: 'Manicura y pedicura profesional con productos de alta calidad.',
        rating: 4.9,
        address: 'Roma Norte, CDMX',
        imageUrl:
            'https://images.pexels.com/photos/3738346/pexels-photo-3738346.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _StoreItem(
        name: 'Uñas para ti',
        description: 'Ambiente acogedor con especialistas en diseño personalizado.',
        rating: 4.8,
        address: 'Col. del Valle, CDMX',
        imageUrl:
            'https://images.pexels.com/photos/8534278/pexels-photo-8534278.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _StoreItem(
        name: 'Mano bella',
        description: 'Tratamientos modernos con las últimas tendencias en manicura.',
        rating: 4.7,
        address: 'Polanco, CDMX',
        imageUrl:
            'https://images.pexels.com/photos/8534277/pexels-photo-8534277.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
    ];

    final childCount = stores.isEmpty ? 0 : stores.length * 2 - 1;

    return Scaffold(
      backgroundColor: kDashboardBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StoresHeaderBar(
                      onBackPressed: () => context.pop(),
                    ),
                    const SizedBox(height: 20),
                    const DashboardReservationCard(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.push('/model-preview'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: kDashboardDarkColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Prueba tu diseño en tiempo real',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const DashboardCoursesBanner(),
                    const SizedBox(height: 28),
                    Text(
                      'Mejor valorados',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: kDashboardDarkColor,
                          ),
                    ),
                    const SizedBox(height: 18),
                    const _StoresSegmentedControl(activeTab: _StoresTab.stores),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return const SizedBox(height: 16);
                    }
                    final store = stores[index ~/ 2];
                    return _StoreListTile(item: store);
                  },
                  childCount: childCount,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
              sliver: SliverToBoxAdapter(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDashboardAccentColor,
                    foregroundColor: kDashboardDarkColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Ver 231 tiendas más...',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoresHeaderBar extends StatelessWidget {
  const _StoresHeaderBar({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            DashboardCircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: onBackPressed,
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.qr_code_2_rounded,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.share_outlined,
              onPressed: () {},
            ),
          ],
        ),
        Row(
          children: [
            DashboardCircleIconButton(
              icon: Icons.notifications_none_rounded,
              onPressed: _noop,
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.favorite_border,
              onPressed: _noop,
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.store_outlined,
              onPressed: _noop,
            ),
          ],
        ),
      ],
    );
  }
}

void _noop() {}

enum _StoresTab { stores, products }

class _StoresSegmentedControl extends StatelessWidget {
  const _StoresSegmentedControl({required this.activeTab});

  final _StoresTab activeTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kDashboardCardTintColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: kDashboardDarkColor, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentPill(
            label: 'Tiendas',
            selected: activeTab == _StoresTab.stores,
          ),
          const SizedBox(width: 8),
          _SegmentPill(
            label: 'Productos',
            selected: activeTab == _StoresTab.products,
          ),
        ],
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  const _SegmentPill({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? kDashboardDarkColor : Colors.transparent,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : kDashboardDarkColor.withOpacity(0.65),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StoreListTile extends StatelessWidget {
  const _StoreListTile({required this.item});

  final _StoreItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: kDashboardCardTintColor,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.store_mall_directory_outlined,
                  color: kDashboardDarkColor,
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
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.black.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, size: 18, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on_outlined, size: 18, color: kDashboardDarkColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.address,
                        style: TextStyle(
                          color: kDashboardDarkColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite_border, color: kDashboardDarkColor, size: 20),
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

class _StoreItem {
  const _StoreItem({
    required this.name,
    required this.description,
    required this.rating,
    required this.address,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final double rating;
  final String address;
  final String imageUrl;
}
