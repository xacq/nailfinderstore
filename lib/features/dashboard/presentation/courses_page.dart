import 'package:flutter/material.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Cursos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => _CourseTile(item: courses[index]),
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
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/ui/course_placeholder.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
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
