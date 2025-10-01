import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dashboard_palette.dart';
import 'widgets/dashboard_common_widgets.dart';
import 'widgets/dashboard_courses_banner.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final popularProducts = const [
      _ProductItem(
        name: 'OPI Nail Lacquer',
        description: 'Esmalte de alto brillo con acabado profesional y secado rápido.',
        rating: 4.9,
        price: '189 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3993445/pexels-photo-3993445.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _ProductItem(
        name: 'Kit acrílico premium',
        description: 'Incluye polvos, monómero y pinceles para crear estructuras resistentes.',
        rating: 4.8,
        price: '420 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3997381/pexels-photo-3997381.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _ProductItem(
        name: 'Set de nail art brillante',
        description: 'Cristales, foil y stickers para diseños sofisticados en minutos.',
        rating: 4.7,
        price: '310 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3993442/pexels-photo-3993442.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
    ];

    final bestSellers = const [
      _BestSellerItem(
        name: 'Bloque pulidor 4 pasos',
        price: '79 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3993446/pexels-photo-3993446.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      ),
      _BestSellerItem(
        name: 'Set de cutículas spa',
        price: '105 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3738349/pexels-photo-3738349.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      ),
      _BestSellerItem(
        name: 'Gel constructor rosado',
        price: '210 MXN',
        imageUrl:
            'https://images.pexels.com/photos/5240653/pexels-photo-5240653.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      ),
      _BestSellerItem(
        name: 'Set de manicura dorado',
        price: '260 MXN',
        imageUrl:
            'https://images.pexels.com/photos/3997382/pexels-photo-3997382.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      ),
    ];

    final listChildCount = popularProducts.isEmpty ? 0 : popularProducts.length * 2 - 1;

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
                    _SalesHeaderBar(
                      onBackPressed: () => context.pop(),
                      onCartPressed: () {},
                    ),
                    const SizedBox(height: 20),
                    const DashboardReservationCard(
                      day: '16',
                      month: 'DIC',
                      time: '06:30 PM',
                    ),
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
                    const _SalesSegmentedControl(activeTab: _SalesTab.products),
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
                    final item = popularProducts[index ~/ 2];
                    return _ProductListTile(item: item);
                  },
                  childCount: listChildCount,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Más vendidos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kDashboardDarkColor,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _BestSellerCard(item: bestSellers[index]),
                  childCount: bestSellers.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.82,
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
                    'Ver 468 productos más...',
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

class _SalesHeaderBar extends StatelessWidget {
  const _SalesHeaderBar({
    required this.onBackPressed,
    required this.onCartPressed,
  });

  final VoidCallback onBackPressed;
  final VoidCallback onCartPressed;

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
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.favorite_border,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.shopping_bag_outlined,
              onPressed: onCartPressed,
            ),
          ],
        ),
      ],
    );
  }
}

enum _SalesTab { stores, products }

class _SalesSegmentedControl extends StatelessWidget {
  const _SalesSegmentedControl({required this.activeTab});

  final _SalesTab activeTab;

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
            selected: activeTab == _SalesTab.stores,
          ),
          const SizedBox(width: 8),
          _SegmentPill(
            label: 'Productos',
            selected: activeTab == _SalesTab.products,
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

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.item});

  final _ProductItem item;

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
                  Icons.image_not_supported_outlined,
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
                    const Spacer(),
                    const Icon(Icons.favorite_border, color: kDashboardDarkColor, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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

class _BestSellerCard extends StatelessWidget {
  const _BestSellerCard({required this.item});

  final _BestSellerItem item;

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
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: kDashboardCardTintColor,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    color: kDashboardDarkColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.price,
            style: TextStyle(
              color: kDashboardDarkColor.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductItem {
  const _ProductItem({
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final double rating;
  final String price;
  final String imageUrl;
}

class _BestSellerItem {
  const _BestSellerItem({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  final String name;
  final String price;
  final String imageUrl;
}
