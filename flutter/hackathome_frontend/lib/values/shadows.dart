/*
*  shadows.dart
*  Anylivery
*
*  Created by [Author].
*  Copyright © 2018 [Company]. All rights reserved.
    */

import 'package:flutter/rendering.dart';


class Shadows {
  static const BoxShadow primaryShadow = BoxShadow(
    color: Color.fromARGB(128, 0, 0, 0),
    offset: Offset(0, 2),
    blurRadius: 4,
  );
  static const BoxShadow secondaryShadow = BoxShadow(
    color: Color.fromARGB(62, 0, 0, 0),
    offset: Offset(0, 1),
    blurRadius: 1,
  );
}