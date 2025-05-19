library com.watered_plants_ota_labs.app.navigator;

import 'package:flutter/material.dart';

class CustomNavigator {
  void push(BuildContext context, Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) => view),
    );
  }
}
