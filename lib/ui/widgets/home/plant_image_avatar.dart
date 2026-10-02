part of com.watered_plants_ota_labs.app.widgets;

class PlantImageAvatar extends StatelessWidget {
  const PlantImageAvatar({this.plant, super.key});

  final PlantModel? plant;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (plant != null && plant!.plantImage.isNotEmpty) {
      Uint8List? bytes = decodeBase64Image(plant!.plantImage);
      if (bytes != null) {
        // Se decodifica al tamaño mostrado (no a la resolución original)
        // para no retener la foto completa en memoria por cada tarjeta.
        imageWidget = Image.memory(
          bytes,
          width: 50,
          height: 50,
          cacheWidth: (50 * MediaQuery.devicePixelRatioOf(context)).round(),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: plant!.plantImage,
          width: 50,
          height: 50,
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
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: placeHolderImage,
        width: 50,
        height: 50,
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

    return imageWidget;
  }

  Widget _buildPlaceholder() => const ColoredBox(
    color: BlueprintColors.surfaceContainerLow,
    child: Icon(Icons.local_florist, color: BlueprintColors.textMuted),
  );
}
