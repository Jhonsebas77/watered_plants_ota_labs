part of com.watered_plants_ota_labs.app.models;

class PlantModel {
  const PlantModel({
    required this.color,
    required this.icon,
    required this.lastWateredDate,
    required this.nextWateringDate,
    required this.plantCare,
    required this.plantImage,
    required this.plantLocation,
    required this.plantName,
    required this.species,
    required this.wateringFrequencyDays,
    required this.wateringSchedule,
    this.uuid,
  });

  factory PlantModel.fromJSON(Map<String, dynamic> json) => PlantModel(
    uuid: json['uuid'] != null ? json['uuid'] as String : '',
    color: json['color'] != null ? json['color'] as String : '',
    icon: json['icon'] != null ? json['icon'] as String : '',
    lastWateredDate:
        json['last_watered_date'] != null
            ? json['last_watered_date'] as String
            : '',
    nextWateringDate:
        json['next_watering_date'] != null
            ? json['next_watering_date'] as String
            : '',
    plantCare: json['plant_care'] != null ? json['plant_care'] as String : '',
    plantImage:
        json['plant_image'] != null ? json['plant_image'] as String : '',
    plantLocation:
        json['plant_location'] != null ? json['plant_location'] as String : '',
    plantName: json['plant_name'] != null ? json['plant_name'] as String : '',
    species: json['species'] != null ? json['species'] as String : '',
    wateringFrequencyDays:
        json['watering_frequency_days'] != null
            ? json['watering_frequency_days'] as num
            : 0,
    wateringSchedule:
        json['watering_schedule'] != null
            ? json['watering_schedule'] as String
            : '',
  );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'color': color,
    'icon': icon,
    'last_watered_date': lastWateredDate,
    'next_watering_date': nextWateringDate,
    'plant_care': plantCare,
    'plant_image': plantImage,
    'plant_location': plantLocation,
    'plant_name': plantName,
    'species': species,
    'watering_frequency_days': wateringFrequencyDays,
    'watering_schedule': wateringSchedule,
  };

  final num wateringFrequencyDays;
  final String color;
  final String icon;
  final String lastWateredDate;
  final String nextWateringDate;
  final String plantCare;
  final String plantImage;
  final String plantLocation;
  final String plantName;
  final String species;
  final String? uuid;
  final String wateringSchedule;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantModel &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(
    wateringFrequencyDays,
    color,
    icon,
    lastWateredDate,
    nextWateringDate,
    plantCare,
    plantImage,
    plantLocation,
    plantName,
    species,
    uuid,
    wateringSchedule,
  );

  @override
  String toString() => '''PlantModel(
   [uuid]: $uuid,
   [color]: $color,
   [icon]: $icon,
   [last_watered_date]: $lastWateredDate,
   [next_watering_date]: $nextWateringDate,
   [plant_care]: $plantCare,
   [plant_image]: $plantImage,
   [plant_location]: $plantLocation,
   [plant_name]: $plantName,
   [species]: $species,
   [watering_frequency_days]: $wateringFrequencyDays,
   [watering_schedule]: $wateringSchedule,
  )''';
}
