library com.watered_plants_ota_labs.app.utils;

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String generateUUID() {
  Uuid uuid = const Uuid();
  return uuid.v4();
}

Color getColorFromString(String stringColor) {
  switch (stringColor) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'grey':
      return Colors.grey;
    case 'purple':
      return Colors.purple;
    default:
      return Colors.white;
  }
}

IconData getIconDataFromString(String stringIcons) {
  switch (stringIcons) {
    case 'mood':
      return Icons.mood;
    case 'compost':
      return Icons.compost;
    case 'pets':
      return Icons.pets;
    case 'florist':
      return Icons.local_florist;
    case 'energy_savings_leaf':
      return Icons.energy_savings_leaf;
    case 'flower':
      return Icons.filter_vintage;
    case 'cactus':
      return Icons.spa;
    case 'tree':
      return Icons.park;
    case 'grass':
      return Icons.grass;
    default:
      return Icons.eco;
  }
}

String getWateringScheduleFromString(String wateringSchedule) {
  switch (wateringSchedule) {
    case 'morning':
      return 'Mañana';
    case 'afternoon':
      return 'Tarde';
    case 'night':
      return 'Noche';
    default:
      return 'Mañana';
  }
}

IconData getIconTimeDataFromString(String stringIcons) {
  switch (stringIcons) {
    case 'morning':
      return Icons.sunny;
    case 'afternoon':
      return Icons.cloud;
    case 'night':
      return Icons.nights_stay;
    default:
      return Icons.sunny;
  }
}

int? getDifferenceInDays(String date) {
  DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  try {
    DateTime parsedInputDate = inputFormat.parseStrict(date);
    DateTime nextWateringDate = DateTime(
      parsedInputDate.year,
      parsedInputDate.month,
      parsedInputDate.day,
    );
    if (nextWateringDate.isAtSameMomentAs(today)) {
      return 0;
    } else if (nextWateringDate.isAfter(today)) {
      int differenceInDays = nextWateringDate.difference(today).inDays;
      return differenceInDays;
    } else {
      int differenceInDays = today.difference(nextWateringDate).inDays;
      return -differenceInDays;
    }
  } on FormatException {
    return null;
  } catch (e) {
    return null;
  }
}

String getWateringMessage(String date, {bool isNextWatering = false}) {
  int? _differenceInDays = getDifferenceInDays(date);
  try {
    if (_differenceInDays == 0) {
      return 'Hoy!';
    } else if (_differenceInDays! >= 1) {
      if (_differenceInDays == 1) {
        return 'Mañana';
      } else {
        return 'En $_differenceInDays días';
      }
    } else {
      if (_differenceInDays == -1) {
        return isNextWatering ? 'Debió haber sido ayer' : 'Ayer';
      } else {
        String normalizedDifferenceInDays = _differenceInDays
            .toString()
            .replaceAll('-', '');
        return isNextWatering
            ? '''Tarde $normalizedDifferenceInDays días'''
            : 'Fue hace $normalizedDifferenceInDays días';
      }
    }
  } on FormatException {
    return 'Invalid date format. Please use DD/MM/YYYY.';
  } catch (e) {
    return 'Could not determine watering schedule.';
  }
}

Color? getWateringChipColor(BuildContext context, String date) {
  int? _differenceInDays = getDifferenceInDays(date);
  try {
    if (_differenceInDays == 0) {
      return Theme.of(context).colorScheme.secondary;
    } else if (_differenceInDays! >= 1) {
      if (_differenceInDays == 1) {
        return Theme.of(context).colorScheme.inversePrimary;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    } else {
      if (_differenceInDays == -1) {
        return Theme.of(context).colorScheme.tertiary;
      } else {
        return Theme.of(context).colorScheme.error;
      }
    }
  } on FormatException {
    return Colors.blueGrey;
  } catch (e) {
    return Colors.grey;
  }
}

num toNumeric(String numberString) => num.tryParse(numberString) ?? 0;

DateTime? toDateTime(String dateString) {
  DateFormat format = DateFormat('dd/MM/yyyy');
  return format.parse(dateString);
}

String toYYYYMMdd(DateTime date) => DateFormat('dd/MM/yyyy', 'es').format(date);

String getColorName(Color color) {
  Map<Color, String> colorNameMap = <Color, String>{
    Colors.red: 'red',
    Colors.green: 'green',
    Colors.blue: 'blue',
    Colors.yellow: 'yellow',
    Colors.grey: 'grey',
    Colors.purple: 'purple',
    Colors.white: 'white',
  };
  return colorNameMap[color] ?? 'white';
}

bool isBase64Image(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  String normalized = value.contains(',') ? value.split(',').last : value;
  normalized = normalized.trim();
  if (normalized.isEmpty) {
    return false;
  }
  try {
    base64Decode(normalized);
    return true;
  } on FormatException {
    return false;
  }
}

Uint8List? decodeBase64Image(String? value) {
  if (!isBase64Image(value)) {
    return null;
  }
  try {
    String normalized = value!.contains(',') ? value.split(',').last : value;
    return base64Decode(normalized);
  } on FormatException {
    return null;
  }
}

int estimateBase64SizeBytes(String? value) {
  if (!isBase64Image(value)) {
    return 0;
  }
  String normalized = value!.contains(',') ? value.split(',').last : value;
  int padding = 0;
  if (normalized.endsWith('==')) {
    padding = 2;
  } else if (normalized.endsWith('=')) {
    padding = 1;
  }
  return (normalized.length * 3 ~/ 4) - padding;
}

class ImageCompressionResult {
  const ImageCompressionResult({
    required this.bytes,
    required this.wasCompressed,
    required this.fitsWithinLimit,
  });

  final Uint8List bytes;
  final bool wasCompressed;
  final bool fitsWithinLimit;
}

ImageCompressionResult compressImageToFitLimit(
  Uint8List bytes, {
  required int maxBytes,
  int initialQuality = 90,
  int minQuality = 30,
  double resizeFactor = 0.8,
  int minDimension = 64,
  int maxIterations = 20,
}) {
  if (bytes.lengthInBytes <= maxBytes) {
    return ImageCompressionResult(
      bytes: bytes,
      wasCompressed: false,
      fitsWithinLimit: true,
    );
  }

  img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) {
    return ImageCompressionResult(
      bytes: bytes,
      wasCompressed: false,
      fitsWithinLimit: bytes.lengthInBytes <= maxBytes,
    );
  }

  img.Image workingImage = decoded;
  int quality = initialQuality.clamp(10, 100);
  Uint8List currentBytes = bytes;
  bool wasCompressed = false;

  int iterations = 0;
  while (currentBytes.lengthInBytes > maxBytes && iterations < maxIterations) {
    iterations++;
    Uint8List candidate = Uint8List.fromList(
      img.encodeJpg(workingImage, quality: quality),
    );
    if (candidate.lengthInBytes < currentBytes.lengthInBytes) {
      currentBytes = candidate;
      wasCompressed = true;
      if (currentBytes.lengthInBytes <= maxBytes) {
        break;
      }
    }

    if (quality > minQuality) {
      quality = math.max(5, quality - 10);
      continue;
    }

    if (workingImage.width > minDimension ||
        workingImage.height > minDimension) {
      int newWidth = math.max(
        minDimension,
        (workingImage.width * resizeFactor).round(),
      );
      int newHeight = math.max(
        minDimension,
        (workingImage.height * resizeFactor).round(),
      );
      if (newWidth != workingImage.width || newHeight != workingImage.height) {
        workingImage = img.copyResize(
          workingImage,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.average,
        );
      }
      continue;
    }

    if (quality > 10) {
      quality = math.max(5, quality - 5);
      continue;
    }

    break;
  }

  if (currentBytes.lengthInBytes > maxBytes && quality > 5) {
    while (currentBytes.lengthInBytes > maxBytes && quality > 5) {
      quality = math.max(5, quality - 5);
      Uint8List candidate = Uint8List.fromList(
        img.encodeJpg(workingImage, quality: quality),
      );
      if (candidate.lengthInBytes < currentBytes.lengthInBytes) {
        currentBytes = candidate;
        wasCompressed = true;
      }
    }
  }

  bool fitsWithinLimit = currentBytes.lengthInBytes <= maxBytes;
  return ImageCompressionResult(
    bytes: currentBytes,
    wasCompressed: wasCompressed,
    fitsWithinLimit: fitsWithinLimit,
  );
}
