part of com.watered_plants_ota_labs.app.widgets;

/// Nivel de semáforo del próximo riego a partir de una fecha `dd/MM/yyyy`:
/// ok = faltan 2+ días, warning = hoy o mañana, danger = atrasado.
/// `null` si la fecha no se puede interpretar.
TrafficLightLevel? wateringLevel(String nextWateringDate) {
  int? days = getDifferenceInDays(nextWateringDate);
  if (days == null) return null;
  if (days < 0) return TrafficLightLevel.danger;
  if (days <= 1) return TrafficLightLevel.warning;
  return TrafficLightLevel.ok;
}

/// Color Blueprint del estado de riego (ver [wateringLevel]); usa
/// [BlueprintColors.textMuted] cuando la fecha no es válida.
Color wateringStatusColor(String nextWateringDate) {
  TrafficLightLevel? level = wateringLevel(nextWateringDate);
  return level == null ? BlueprintColors.textMuted : trafficLightColor(level);
}
