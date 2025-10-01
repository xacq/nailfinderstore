import 'package:flutter/material.dart';

import 'dashboard_palette.dart';
import 'widgets/dashboard_common_widgets.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = const [
      _CourseItem(
        title: 'Curso de Polygel',
        price: '300 MXN',
        description: 'Esmalte . Aprende la revolución en el mundo del polygel.',
        imageUrl:
            'https://images.pexels.com/photos/3065188/pexels-photo-3065188.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _CourseItem(
        title: 'Taller de Nail Art',
        price: '350 MXN',
        description: 'Esmalte . Amplia variedad de colores, buena aplicación y diseño.',
        imageUrl:
            'https://images.pexels.com/photos/3993445/pexels-photo-3993445.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
      _CourseItem(
        title: 'Taller Esculpido',
        price: '320 MXN',
        description: 'Esmalte . Amplia variedad de colores, buena aplicación y resistencia.',
        imageUrl:
            'https://images.pexels.com/photos/3997376/pexels-photo-3997376.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=400',
      ),
    ];

    final previewImages = const [
      'https://images.pexels.com/photos/4543110/pexels-photo-4543110.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      'https://images.pexels.com/photos/5240653/pexels-photo-5240653.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      'https://images.pexels.com/photos/8101187/pexels-photo-8101187.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
      'https://images.pexels.com/photos/7567944/pexels-photo-7567944.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=320',
    ];

    final theme = Theme.of(context);
    final coursesChildCount = courses.isEmpty ? 0 : courses.length * 2 - 1;

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
                    _CoursesHeaderBar(
                      onBackPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(height: 20),
                    const DashboardReservationCard(),
                    const SizedBox(height: 28),
                    Text(
                      'Prueba tu modelo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kDashboardDarkColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 102,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: previewImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, index) => _ModelPreviewThumbnail(
                          imageUrl: previewImages[index],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Mejor valorados',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: kDashboardDarkColor,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _CoursesSegmentedControl(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return const SizedBox(height: 16);
                    }
                    final courseIndex = index ~/ 2;
                    return _CourseTile(item: courses[courseIndex]);
                  },
                  childCount: coursesChildCount,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.item});

  final _CourseItem item;

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
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 18, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      item.price,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}

class _CourseItem {
  const _CourseItem({
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  final String title;
  final String price;
  final String description;
  final String imageUrl;
}

class _ModelPreviewThumbnail extends StatelessWidget {
  const _ModelPreviewThumbnail({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
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
    );
  }
}

class _CoursesHeaderBar extends StatelessWidget {
  const _CoursesHeaderBar({required this.onBackPressed});

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
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.person_outline,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            DashboardCircleIconButton(
              icon: Icons.shopping_bag_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _CoursesSegmentedControl extends StatelessWidget {
  const _CoursesSegmentedControl();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kDashboardCardTintColor.withOpacity(0.65),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: kDashboardDarkColor, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: kDashboardDarkColor,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Text(
              'Cursos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'Talleres',
              style: TextStyle(
                color: kDashboardDarkColor.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
