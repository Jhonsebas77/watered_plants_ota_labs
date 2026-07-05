library com.watered_plants_ota_labs.app.widgets;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/models/models.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/utils.dart';
import '../navigator.dart';
import '../theme/theme.dart';
import '../typography.dart';
import '../views/views.dart';

export 'background/background.dart';

part 'home/add_plant_floating_action_button.dart';
part 'home/basic_plant_card.dart';
part 'home/plant_image_avatar.dart';
part 'home/simple_chip_with_icon.dart';
part 'home/week_calendar.dart';
part 'last_watering_chip.dart';
part 'login/login_corner_brackets.dart';
part 'login/login_schematic_ring.dart';
part 'next_watering_chip.dart';
part 'plant_avatar.dart';
part 'plant_chip_base.dart';
part 'plants/detail/information_detail_card.dart';
part 'plants/detail/item_table_detail_care.dart';
part 'plants/detail/location_chip.dart';
part 'plants/detail/plant_image.dart';
part 'plants/detail/summary_detail_card.dart';
part 'plants/detail/watering_detail_card.dart';
part 'responsive/responsive_container.dart';
part 'settings/version.dart';
part 'theme/label.dart';
part 'time_watering_chip.dart';
part 'watering_frequency_chip.dart';
