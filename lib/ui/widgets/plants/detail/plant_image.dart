part of com.watered_plants_ota_labs.app.widgets;

class PlantImage extends StatelessWidget {
  const PlantImage({
    required this.plantImage,
    required this.plantColorString,
    required this.plantIconString,
    super.key,
  });
  final String plantImage;
  final String plantColorString;
  final String plantIconString;
  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: plantImage,
          height: 96,
          width: 96,
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
              (BuildContext context, String _, Object __) => ColoredBox(
                color: Colors.grey[200]!,
                child: Icon(Icons.local_florist, color: Colors.grey[400]),
              ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: -16,
        child: PlantAvatar(
          plantColorString: plantColorString,
          plantIconString: plantIconString,
        ),
      ),
    ],
  );
}
