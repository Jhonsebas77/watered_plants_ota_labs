part of com.watered_plants_ota_labs.app.widgets.background;

class BackgroundFooter extends StatelessWidget {
  const BackgroundFooter({super.key});

  @override
  Widget build(BuildContext context) =>
      Container(
            decoration: const BoxDecoration(
              color: BlueprintColors.surfaceContainerLow,
              border: Border(
                top: BorderSide(
                  color: BlueprintColors.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'LEGAL_PROTOCOL',
                            style: CustomStyles().customLabelTextStyle(
                              color: BlueprintColors.primaryContainer,
                              size: 9,
                              spacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '©2026 OTA_LABS. ALL RIGHTS RESERVED.'
                            '\nSECURE ACCESS SCHEMA REQUIRED.',
                            style: CustomStyles().customLabelTextStyle(
                              size: 8,
                              spacing: 0.3,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Row(
                      children: <Widget>[
                        LoginFooterIcon(icon: Icons.shield_outlined),
                        SizedBox(width: 8),
                        LoginFooterIcon(icon: Icons.language_outlined),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const BackgroundDiagnosticStrip(),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 500.ms, delay: 700.ms)
          .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOut);
}
