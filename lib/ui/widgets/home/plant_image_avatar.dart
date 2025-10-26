part of com.watered_plants_ota_labs.app.widgets;

class PlantImageAvatar extends StatelessWidget {
  const PlantImageAvatar({this.plant, super.key});

  final PlantModel? plant;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (plant != null && plant!.plantImage.isNotEmpty) {
      if (isBase64Image(plant!.plantImage)) {
        Uint8List? bytes = decodeBase64Image(plant!.plantImage);
        if (bytes != null) {
          imageWidget = Image.memory(
            bytes,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          );
        } else {
          imageWidget = _buildPlaceholder();
        }
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
          errorWidget:
              (BuildContext context, String _, Object __) =>
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
        errorWidget:
            (BuildContext context, String _, Object __) => _buildPlaceholder(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }

  Widget _buildPlaceholder() => ColoredBox(
    color: Colors.grey[200]!,
    child: Icon(Icons.local_florist, color: Colors.grey[400]),
  );
}
