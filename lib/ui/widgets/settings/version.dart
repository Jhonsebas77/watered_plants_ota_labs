part of com.watered_plants_ota_labs.app.widgets;

class VersionWidget extends StatefulWidget {
  const VersionWidget({super.key});

  @override
  State<VersionWidget> createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  String _appName = '...';
  String _version = '...';
  String _buildNumber = '...';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Container(
      width: 270,
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
      decoration: BoxDecoration(
        color: BlueprintColors.surfaceContainerLow,
        border: Border.all(color: BlueprintColors.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/ota_bg.png',
            height: 50,
            width: 50,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                _appName,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(
                'By Ota_Labs $_version($_buildNumber)',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
