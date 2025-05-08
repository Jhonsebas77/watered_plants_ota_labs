library com.watered_plants_ota_labs.app.utils;

import 'package:uuid/uuid.dart';

String generateUUID() {
  Uuid uuid = const Uuid();
  return uuid.v4();
}
