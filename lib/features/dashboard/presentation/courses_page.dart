import 'package:flutter/material.dart';

const _darkColor = Color(0xFF070008);
const _accentColor = Color(0xFFFF47F0);
const _accentColorLight = Color(0xFFFF87F4);
const _backgroundColor = Color(0xFFFDFDFD);
const _cardTintColor = Color(0xFFFBC5FA);

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
      backgroundColor: _backgroundColor,
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
                    const _NextReservationCard(),
                    const SizedBox(height: 28),
                    Text(
                      'Prueba tu modelo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _darkColor,
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
                        color: _darkColor,
                      ),
                    ),
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
                color: _cardTintColor,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: _darkColor,
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
            color: _cardTintColor,
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_outlined,
              color: _darkColor,
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
            _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: onBackPressed,
            ),
            const SizedBox(width: 12),
            _CircleIconButton(
              icon: Icons.qr_code_2_rounded,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _CircleIconButton(
              icon: Icons.share_outlined,
              onPressed: () {},
            ),
          ],
        ),
        Row(
          children: [
            _CircleIconButton(
              icon: Icons.notifications_none_rounded,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _CircleIconButton(
              icon: Icons.person_outline,
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            _CircleIconButton(
              icon: Icons.shopping_bag_outlined,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardTintColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: _darkColor, size: 22),
        ),
      ),
    );
  }
}

class _NextReservationCard extends StatelessWidget {
  const _NextReservationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardTintColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.25),
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
                colors: [_accentColor, _accentColorLight],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '15',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'DIC',
                  style: TextStyle(
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
                  ).copyWith(color: _darkColor),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nail Finder Store',
                  style: TextStyle(
                    color: _darkColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Avenida Yucatán 69, Ciudad de México',
                  style: TextStyle(
                    color: _darkColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: _darkColor),
                    const SizedBox(width: 6),
                    const Text(
                      '05:30 PM',
                      style: TextStyle(
                        color: _darkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: _accentColor,
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
