part of com.watered_plants_ota_labs.app.widgets.background;

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({super.key});

  @override
  Widget build(BuildContext context) =>
      Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: BlueprintColors.primaryContainer,
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'SYSTEM_STATUS',
                        style: CustomStyles().customLabelTextStyle(
                          size: 9,
                          spacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          const PulseDot(),
                          const SizedBox(width: 6),
                          Text(
                            'OPERATIONAL',
                            style: CustomStyles().customLabelTextStyle(
                              color: BlueprintColors.success,
                              size: 10,
                              spacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Ref_ID: WTP_77-X',
                      style: CustomStyles().customLabelTextStyle(
                        size: 9,
                        spacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'COORD: 40.7128° N',
                      style: CustomStyles().customLabelTextStyle(
                        size: 9,
                        spacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          .animate()
          .fadeIn(duration: 600.ms, delay: 100.ms)
          .slideY(begin: -0.3, end: 0, duration: 600.ms, curve: Curves.easeOut);
}
