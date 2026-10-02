part of com.watered_plants_ota_labs.app.widgets;

class PlantImage extends StatelessWidget {
  const PlantImage({
    this.plantImage,
    this.plantColorString,
    this.plantIconString,
    this.displayAvatar = false,
    super.key,
  });
  final String? plantImage;
  final String? plantColorString;
  final String? plantIconString;
  final bool displayAvatar;
  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border.all(color: BlueprintColors.outlineVariant),
        ),
        child: SizedBox(height: 96, width: 96, child: _buildImage()),
      ),
      if (displayAvatar && plantColorString != null && plantIconString != null)
        Positioned(
          bottom: 0,
          right: -16,
          child: PlantAvatar(
            plantColorString: plantColorString!,
            plantIconString: plantIconString!,
          ),
        ),
    ],
  );

  Widget _buildImage() {
    if (plantImage != null && plantImage!.isNotEmpty) {
      Uint8List? bytes = decodeBase64Image(plantImage);
      if (bytes != null) {
        return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
      }
      return CachedNetworkImage(
        imageUrl: plantImage!,
        fit: BoxFit.cover,
        progressIndicatorBuilder:
            (BuildContext _, String __, DownloadProgress downloadProgress) =>
                Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    strokeWidth: 2,
                  ),
                ),
        errorWidget: (BuildContext context, String _, Object __) =>
            _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() => const ColoredBox(
    color: BlueprintColors.surfaceContainerLow,
    child: Icon(Icons.local_florist, color: BlueprintColors.textMuted),
  );
}
