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
        child: Image.network(
          plantImage,
          height: 96,
          width: 96,
          fit: BoxFit.cover,
          loadingBuilder: (
            BuildContext context,
            Widget image,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return image;
            return SizedBox(
              height: 96,
              child: Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              ),
            );
          },
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
