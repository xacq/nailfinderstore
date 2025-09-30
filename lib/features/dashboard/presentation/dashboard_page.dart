import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _segment = 'stores';

  final List<_StoreItem> _stores = const [
    _StoreItem(
      title: 'Tienditas',
      subtitle:
          'Manicura y pedicura profesional con manicuristas de alta calidad. ¡Luce impecable!',
      rating: 4.8,
      reviews: 248,
      priceLabel: 'Desde 200 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1622286342621-4b56776c2beb?auto=format&fit=crop&w=400&q=80',
    ),
    _StoreItem(
      title: 'Uñas para ti',
      subtitle:
          'Ambiente acogedor y familiar. Manicura clásica y uñas acrílicas personalizadas.',
      rating: 4.9,
      reviews: 186,
      priceLabel: 'Desde 260 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1591076482161-42a42c9d72f8?auto=format&fit=crop&w=400&q=80',
    ),
    _StoreItem(
      title: 'Mano bella',
      subtitle:
          'Manicure con las últimas tendencias. Tratamientos con productos veganos.',
      rating: 4.7,
      reviews: 312,
      priceLabel: 'Desde 280 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1589411386958-36ce9a72788f?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  final List<_StoreItem> _products = const [
    _StoreItem(
      title: 'Kit Gel UV',
      subtitle:
          'Incluye lámpara UV, esmaltes y accesorios para 20 aplicaciones profesionales.',
      rating: 4.6,
      reviews: 129,
      priceLabel: '1,050 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1580894899185-1e7c3f9a1f25?auto=format&fit=crop&w=400&q=80',
    ),
    _StoreItem(
      title: 'Colección Nude',
      subtitle: 'Set de 6 esmaltes en tonos neutros con fórmula hipoalergénica.',
      rating: 4.8,
      reviews: 204,
      priceLabel: '720 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1580983561371-7e3e2d17cf2b?auto=format&fit=crop&w=400&q=80',
    ),
    _StoreItem(
      title: 'Herramientas Pro',
      subtitle: 'Kit completo de herramientas de acero quirúrgico para salón.',
      rating: 4.9,
      reviews: 168,
      priceLabel: '1,320 MXN',
      imageUrl:
          'https://images.unsplash.com/photo-1610992015732-05475a30f89f?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  void _onSegmentChanged(String segment) {
    setState(() {
      _segment = segment;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storesSelected = _segment == 'stores';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeaderBar(onNotificationsPressed: () {}),
            const SizedBox(height: 16),
            _NextReservationCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/model-preview'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
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
            GestureDetector(
              onTap: () => context.push('/courses'),
              child: const _CoursesBanner(),
            ),
            const SizedBox(height: 28),
            Text(
              'Mejor valorados',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _SegmentedSelector(
              selectedSegment: _segment,
              onChanged: _onSegmentChanged,
            ),
            const SizedBox(height: 20),
            ...List.generate(
              (storesSelected ? _stores : _products).length,
              (index) {
                final items = storesSelected ? _stores : _products;
                final item = items[index];
                final isLast = index == items.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: _StoreTile(item: item),
                );
              },
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 1.5),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                storesSelected ? 'Ver 231 tiendas más...' : 'Ver más productos...',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.onNotificationsPressed});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
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
              onPressed: onNotificationsPressed,
            ),
            const SizedBox(width: 12),
            _CircleIconButton(
              icon: Icons.favorite_border,
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
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.black87, size: 22),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
              color: const Color(0xFF5B1CFB),
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
                const Text(
                  'Próxima reserva',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nail Finder Store',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Avenida Yucatán 69, Ciudad de México',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.black87),
                    const SizedBox(width: 6),
                    Text(
                      '05:30 PM',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF5B1CFB),
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

class _CoursesBanner extends StatelessWidget {
  const _CoursesBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFAE5D2), Color(0xFFE8D0F7)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1580983561920-5730476cef05?auto=format&fit=crop&w=240&q=80',
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Cursos',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Aprende o actualízate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Descubre talleres y cursos para mejorar tus técnicas profesionales.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
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

class _SegmentedSelector extends StatelessWidget {
  const _SegmentedSelector({
    required this.selectedSegment,
    required this.onChanged,
  });

  final String selectedSegment;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _SegmentButton(
            label: 'Tiendas',
            selected: selectedSegment == 'stores',
            onTap: () => onChanged('stores'),
          ),
          _SegmentButton(
            label: 'Productos',
            selected: selectedSegment == 'products',
            onTap: () => onChanged('products'),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  const _StoreTile({required this.item});

  final _StoreItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.black54),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Text('(${item.reviews})',
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(width: 12),
                    const Icon(Icons.attach_money, size: 18, color: Colors.black54),
                    const SizedBox(width: 2),
                    Text(
                      item.priceLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
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

class _StoreItem {
  const _StoreItem({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.priceLabel,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final double rating;
  final int reviews;
  final String priceLabel;
  final String imageUrl;
}
