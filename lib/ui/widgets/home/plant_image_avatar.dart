part of com.watered_plants_ota_labs.app.widgets;

class PlantImageAvatar extends StatelessWidget {
  const PlantImageAvatar({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: CachedNetworkImage(
      imageUrl: plant.plantImage,
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
          (BuildContext context, String _, Object __) => ColoredBox(
            color: Colors.grey[200]!,
            child: Icon(Icons.local_florist, color: Colors.grey[400]),
          ),
    ),
  );
}
