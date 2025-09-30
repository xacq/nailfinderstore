import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/catalog_providers.dart';
import '../data/models/service.dart';
import '../data/models/service_category.dart';
import '../data/models/technician.dart';

const _darkColor = Color(0xFF070008);
const _accentColor = Color(0xFFFF47F0);
const _accentColorLight = Color(0xFFFF87F4);
const _accentColorLighter = Color(0xFFFDA0F7);
const _backgroundColor = Color(0xFFFCE9FD);
const _cardTintColor = Color(0xFFFBC5FA);
const _secondaryAccent = Color(0xFFE4B082);
const _highlightYellow = Color(0xFFFFD700);

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _segment = 'services';

  void _onSegmentChanged(String segment) {
    setState(() {
      _segment = segment;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isServicesSelected = _segment == 'services';
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final servicesAsync = ref.watch(servicesProvider);
    final techniciansAsync = ref.watch(techniciansProvider);


    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeaderBar(
              onNotificationsPressed: () {},
              onProfilePressed: () => context.push('/profile'),
            ),
            const SizedBox(height: 16),
            _NextReservationCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/model-preview'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _darkColor,
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
                color: _darkColor,
              ),
            ),
            const SizedBox(height: 16),
            _SegmentedSelector(
              selectedSegment: _segment,
              onChanged: _onSegmentChanged,
            ),
            const SizedBox(height: 20),

            ..._buildSegmentContent(
              isServicesSelected: isServicesSelected,
              categoriesAsync: categoriesAsync,
              servicesAsync: servicesAsync,
              techniciansAsync: techniciansAsync,

            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: _darkColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isServicesSelected
                        ? 'Ver más servicios...'
                        : 'Ver más técnicos...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<Widget> _buildSegmentContent({
    required bool isServicesSelected,
    required AsyncValue<List<ServiceCategory>> categoriesAsync,
    required AsyncValue<List<Service>> servicesAsync,
    required AsyncValue<List<Technician>> techniciansAsync,
  }) {
    if (isServicesSelected) {
      return [
        categoriesAsync.when(
          data: (categories) {
            if (categories.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoriesChips(categories: categories),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        servicesAsync.when(
          data: (services) {
            if (services.isEmpty) {
              return const _EmptyCatalogSection.services();
            }
            return Column(
              children: [
                for (var i = 0; i < services.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _ServiceTile(service: services[i]),
                ],
              ],
            );
          },
          loading: () => const _CatalogLoadingIndicator(),
          error: (error, _) => _CatalogErrorMessage(error: error),
        ),
      ];
    }

    return [
      techniciansAsync.when(
        data: (technicians) {
          if (technicians.isEmpty) {
            return const _EmptyCatalogSection.technicians();
          }
          return Column(
            children: [
              for (var i = 0; i < technicians.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _TechnicianTile(technician: technicians[i]),
              ],
            ],
          );
        },
        loading: () => const _CatalogLoadingIndicator(),
        error: (error, _) => _CatalogErrorMessage(error: error),
      ),
    ];
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.onNotificationsPressed,
    required this.onProfilePressed,
  });

  final VoidCallback onNotificationsPressed;
  final VoidCallback onProfilePressed;

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
              icon: Icons.person_outline,
              onPressed: onProfilePressed,
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
                Text(
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
                    Text(
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

class _CoursesBanner extends StatelessWidget {
  const _CoursesBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_secondaryAccent, _accentColorLight],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.2),
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
                  colors: [_accentColor, _accentColorLight],
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
                  ).copyWith(color: _accentColor),
                ),
                const SizedBox(height: 6),
                Text(
                  'Aprende o actualízate',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: _darkColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Descubre talleres y cursos para mejorar tus técnicas profesionales.',
                  style: TextStyle(
                    fontSize: 13,
                    color: _darkColor.withOpacity(0.75),
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
        color: _cardTintColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _darkColor, width: 1.2),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _SegmentButton(
            label: 'Servicios',
            selected: selectedSegment == 'services',
            onTap: () => onChanged('services'),
          ),
          _SegmentButton(
            label: 'Técnicos',
            selected: selectedSegment == 'technicians',
            onTap: () => onChanged('technicians'),
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
            color: selected ? _darkColor : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : _darkColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoriesChips extends StatelessWidget {
  const _CategoriesChips({required this.categories});

  final List<ServiceCategory> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Chip(
            label: Text(category.name),
            backgroundColor: _accentColorLighter,
            labelStyle: const TextStyle(color: _darkColor, fontWeight: FontWeight.w500),
          );
        },
      ),
    );
  }
}


class _EmptyCatalogSection extends StatelessWidget {
  const _EmptyCatalogSection.services()
      : type = _CatalogEmptyType.services;
  const _EmptyCatalogSection.technicians()
      : type = _CatalogEmptyType.technicians;

  final _CatalogEmptyType type;

  @override
  Widget build(BuildContext context) {
    final isServices = type == _CatalogEmptyType.services;
    final theme = Theme.of(context);

    final primaryActionLabel =
        isServices ? 'Agregar servicio' : 'Invitar técnico';
    final primaryActionIcon =
        isServices ? Icons.add_circle_outline : Icons.person_add_alt_1_outlined;

    final secondaryActionLabel =
        isServices ? 'Importar catálogo' : 'Asignar servicios';
    final secondaryActionIcon =
        isServices ? Icons.cloud_upload_outlined : Icons.manage_accounts_outlined;

    final title = isServices
        ? 'Aún no hay servicios disponibles'
        : 'Todavía no hay técnicos visibles';
    final description = isServices
        ? 'Publica tus servicios o sincroniza tu catálogo para mostrarlos aquí.'
        : 'Añade a tu equipo o invita colaboradores para que aparezcan en este listado.';

    final footer = Text(
      isServices
          ? 'Gestiona tu catálogo desde el panel de administración.'
          : 'Administra los perfiles desde el panel de administración.',
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ).copyWith(color: _accentColor),
    );

    final highlights = isServices
        ? const [
            _EmptyHighlight(
              icon: Icons.brush_outlined,
              title: 'Destaca tus especialidades',
              description:
                  'Organiza tus servicios por categoría y duración para facilitar las reservas.',
            ),
            _EmptyHighlight(
              icon: Icons.timer_outlined,
              title: 'Define duraciones reales',
              description:
                  'Ajusta el tiempo estimado para que la agenda sugiera horarios disponibles.',
            ),
          ]
        : const [
            _EmptyHighlight(
              icon: Icons.school_outlined,
              title: 'Completa los perfiles',
              description:
                  'Incluye certificaciones y biografías para que los clientes confíen en tu equipo.',
            ),
            _EmptyHighlight(
              icon: Icons.groups_outlined,
              title: 'Asigna servicios compatibles',
              description:
                  'Relaciona a cada técnico con los servicios que puede atender antes de recibir reservas.',
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(primaryActionIcon),
              label: Text(
                primaryActionLabel,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _darkColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: _darkColor, width: 1.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(secondaryActionIcon, color: _darkColor),
              label: Text(
                secondaryActionLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _darkColor,
                ),
              ),
            ),
          ],
        ),
        _EmptyHighlightsList(highlights: highlights),
      ],
    );
  }
}

enum _CatalogEmptyType { services, technicians }

class _EmptyHighlight {
  const _EmptyHighlight({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _EmptyHighlightsList extends StatelessWidget {
  const _EmptyHighlightsList({required this.highlights});

  final List<_EmptyHighlight> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < highlights.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _EmptyHighlightTile(highlight: highlights[i]),
        ],
      ],
    );
  }
}

class _EmptyHighlightTile extends StatelessWidget {
  const _EmptyHighlightTile({required this.highlight});

  final _EmptyHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentColorLighter),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: _accentColorLighter,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              highlight.icon,
              color: _accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  highlight.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _darkColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  highlight.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _darkColor.withOpacity(0.8),
                    height: 1.35,
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


class _EmptyCollectionCard extends StatelessWidget {
  const _EmptyCollectionCard({
    required this.icon,
    required this.title,
    required this.description,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _accentColorLighter,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: _accentColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: _darkColor),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: _darkColor.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                if (footer != null) ...[
                  const SizedBox(height: 12),
                  footer!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogLoadingIndicator extends StatelessWidget {
  const _CatalogLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _CatalogErrorMessage extends StatelessWidget {
  const _CatalogErrorMessage({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentColorLighter),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: _accentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ocurrió un error al cargar la información.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _darkColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$error',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _darkColor.withOpacity(0.7),
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


class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final description = service.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final price = service.price;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ).copyWith(color: _darkColor),
                ),
              ),
              if (service.durationMinutes != null)
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: _darkColor),
                    const SizedBox(width: 4),
                    Text(
                      '${service.durationMinutes} min',
                      style: const TextStyle(fontWeight: FontWeight.w600)
                          .copyWith(color: _darkColor),
                    ),
                  ],
                ),
            ],
          ),
          if (hasDescription) ...[
            const SizedBox(height: 8),
            Text(
              description!,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: _darkColor.withOpacity(0.8),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 20, color: _darkColor),
              const SizedBox(width: 6),
              Text(
                price != null ? _formatCurrency(price) : 'Precio según consulta',
                style: const TextStyle(fontWeight: FontWeight.w600)
                    .copyWith(color: _darkColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TechnicianTile extends StatelessWidget {
  const _TechnicianTile({required this.technician});

  final Technician technician;

  @override
  Widget build(BuildContext context) {
    final services = technician.services;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _accentColorLight.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_accentColorLighter, _accentColorLight],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.person_outline,
              size: 30,
              color: _accentColor,
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
                        technician.displayName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ).copyWith(color: _darkColor),
                      ),
                    ),
                    if (technician.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, color: _highlightYellow, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            technician.rating!.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600)
                                .copyWith(color: _darkColor),
                          ),
                          if (technician.reviewsCount != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '(${technician.reviewsCount})',
                              style: TextStyle(
                                color: _darkColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
                if (technician.bio != null && technician.bio!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    technician.bio!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: _darkColor.withOpacity(0.8),
                    ),
                  ),
                ],
                if (services.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      for (final service in services.take(3))
                        Chip(
                          label: Text(service.name),
                          backgroundColor: _accentColorLighter,
                          labelStyle: const TextStyle(color: _darkColor),
                        ),
                      if (services.length > 3)
                        Chip(
                          label: Text('+${services.length - 3} más'),
                          backgroundColor: _accentColorLight,
                          labelStyle: const TextStyle(color: _darkColor),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}


String _formatCurrency(double value) {
  if (value >= 1000) {
    return '\$${value.toStringAsFixed(0)} MXN';
  }
  return '\$${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)} MXN';
}
