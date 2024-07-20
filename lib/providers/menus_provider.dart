// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import '/models/menu.dart';

class MenusProvider extends ChangeNotifier {
  /// The private field backing [menu].
  //late Menu _menu;

  /// Internal, private state of the cart. Stores the ids of each item.
  List<Menu> _menus = [];

  List<Menu> get menus => _menus;

  // /// Adds [menu] to cart. This is the only way to modify the cart from outside.
  // void setMenus(List<Menu> menus) {
  //   _menus = menus;
  //   notifyListeners();
  // }

  Future<void> setMenus(Future<List<Menu>> futureMenus) async {
    futureMenus.then((menus) {
      _menus = menus;
      notifyListeners();
    });
  }
}
