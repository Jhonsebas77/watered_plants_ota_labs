part of com.watered_plants_ota_labs.app.models;

/// Planta eliminada que vive en el "cementerio": conserva todos los datos de
/// la planta original más la fecha en que se eliminó, para poder revivirla.
class DeadPlantModel {
  const DeadPlantModel({required this.plant, required this.deathDate});

  factory DeadPlantModel.fromJSON(Map<String, dynamic> json) => DeadPlantModel(
    plant: PlantModel.fromJSON(json),
    deathDate: json['death_date'] != null ? json['death_date'] as String : '',
  );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    ...plant.toJSON(),
    'death_date': deathDate,
  };

  DateTime? get getDeathDate =>
      deathDate.isNotEmpty ? toDateTime(deathDate) : null;

  final PlantModel plant;
  final String deathDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeadPlantModel &&
          runtimeType == other.runtimeType &&
          plant == other.plant &&
          deathDate == other.deathDate;

  @override
  int get hashCode => Object.hash(plant, deathDate);

  @override
  String toString() =>
      '''DeadPlantModel(
   [plant]: $plant,
   [death_date]: $deathDate,
  )''';
}
