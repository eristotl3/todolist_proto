import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/app_theme.dart';

class UseCaseSelectionScreen extends StatelessWidget {
  const UseCaseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 36),
                    const Text(
                      'How will you\nuse Pengulist?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pick a starting point. You can switch anytime in settings.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textMute,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _ChoiceCard(
                      icon: Icons.auto_awesome_rounded,
                      label: 'Just for me',
                      description: 'Personal todos, simple and quiet.',
                      accentIcon: true,
                      onTap: () => context.push(
                        RouteNames.register,
                        extra: {'role': 'personal'},
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ChoiceCard(
                      icon: Icons.school_rounded,
                      label: 'For my classroom',
                      description: 'Assign tasks, track student progress.',
                      accentIcon: false,
                      onTap: () => context.push(RouteNames.roleSelection),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: AppTheme.textMute, fontSize: 13.5),
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.login),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared inline logo (penguin mark + wordmark) ──────────────────────────────

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/logo_penguin.svg',
          width: 34,
          height: 34,
        ),
        const SizedBox(width: 10),
        const Text(
          'Pengulist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.text,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

// ── Choice card ───────────────────────────────────────────────────────────────

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool accentIcon;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.accentIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.line),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentIcon ? AppTheme.accentMute : AppTheme.surface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon,
                    color: accentIcon ? AppTheme.accent : AppTheme.text,
                    size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.text,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textMute),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textFaint, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
