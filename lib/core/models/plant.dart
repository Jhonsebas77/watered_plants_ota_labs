part of com.watered_plants_ota_labs.app.models;

class PlantModel {
  const PlantModel({
    required this.color,
    required this.icon,
    required this.lastWateredDate,
    required this.nextWateringDate,
    required this.plantCare,
    required this.plantImage,
    required this.plantName,
    required this.species,
    required this.wateringFrequencyDays,
  });

  factory PlantModel.fromJSON(Map<String, dynamic> json) => PlantModel(
    color: json['color'] as String,
    icon: json['icon'] as String,
    lastWateredDate: json['last_watered_date'] as String,
    nextWateringDate: json['next_watering_date'] as String,
    plantCare: json['plant_care'] as String,
    plantImage: json['plant_image'] as String,
    plantName: json['plant_name'] as String,
    species: json['species'] as String,
    wateringFrequencyDays: json['watering_frequency_days'] as int,
  );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'color': color,
    'icon': icon,
    'last_watered_date': lastWateredDate,
    'next_watering_date': nextWateringDate,
    'plant_care': plantCare,
    'plant_image': plantImage,
    'plant_name': plantName,
    'species': species,
    'watering_frequency_days': wateringFrequencyDays,
  };

  @override
  String toString() => '''PlantModel(
   [color]: $color,
   [icon]: $icon,
   [last_watered_date]: $lastWateredDate,
   [next_watering_date]: $nextWateringDate,
   [plant_care]: $plantCare,
   [plant_image]: $plantImage,
   [plant_name]: $plantName,
   [species]: $species,
   [watering_frequency_days]: $wateringFrequencyDays,
  )''';

  final String color;
  final String icon;
  final String lastWateredDate;
  final String nextWateringDate;
  final String plantCare;
  final String plantImage;
  final String plantName;
  final String species;
  final int wateringFrequencyDays;
}
