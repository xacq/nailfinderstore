import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFE8D0F7), Color(0xFFFAE5D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_outline,
                          size: 36,
                          color: Color(0xFF7F3DFF),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ximena Fernández',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1ECFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    size: 18,
                                    color: Color(0xFF7F3DFF),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Usuaria estándar',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          _CircleActionIcon(icon: Icons.share_outlined),
                          SizedBox(height: 12),
                          _CircleActionIcon(icon: Icons.edit_outlined),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _ProfileInfoTile(
                    icon: Icons.mail_outline,
                    title: 'Correo electrónico',
                    value: 'mariagomez@email.com',
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Número de teléfono',
                    value: '+52 0412 123 4567',
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.event_outlined,
                    title: 'Fecha de nacimiento',
                    value: '15/07/1990',
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.person_outline,
                    title: 'Género',
                    value: 'Femenino',
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Dirección de facturación',
                    value: 'Avenida Reforma 123, Ciudad de México',
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.lock_outline,
                    title: 'Contraseña',
                    value: '************',
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE5DBFF), thickness: 1),
                  const SizedBox(height: 24),
                  Text(
                    'Preguntas de seguridad',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _ProfileInfoTile(
                    icon: Icons.help_outline,
                    title: '¿Cuál es el nombre de tu primera mascota?',
                    value: '************',
                    obscure: true,
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.help_outline,
                    title: '¿En qué ciudad naciste?',
                    value: '************',
                    obscure: true,
                  ),
                  const _ProfileInfoTile(
                    icon: Icons.help_outline,
                    title: '¿Cuál es tu ciudad favorita?',
                    value: '************',
                    obscure: true,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F3DFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Verificar perfil',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
}

class _CircleActionIcon extends StatelessWidget {
  const _CircleActionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.black87, size: 20),
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.obscure = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = obscure ? '************' : value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1ECFF),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF7F3DFF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  displayValue,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.black45, size: 20),
        ],
      ),
    );
  }
}
