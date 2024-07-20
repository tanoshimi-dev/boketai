// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import '/models/menu.dart';

class FavoriteProvider extends ChangeNotifier {
  /// The private field backing [menu].
  //late Menu _menu;

  /// Internal, private state of the cart. Stores the ids of each item.
  List<Menu> _favoritesMenu = [];

  /// The current catalog. Used to construct items from numeric ids.
  // Menu get menu => _menu;

  // set menu(Menu newMenu) {
  //   _menu = newMenu;
  //   // Notify listeners, in case the new catalog provides information
  //   // different from the previous one. For example, availability of an item
  //   // might have changed.
  //   notifyListeners();
  // }
  List<Menu> get favoritesMenu => _favoritesMenu;

  /// The current total price of all items.
  int get totalPrice =>
      _favoritesMenu.fold(0, (total, current) => total + current.price);

  /// Adds [menu] to cart. This is the only way to modify the cart from outside.
  void add(Menu menu) {
    //_favoritesMenu.add(menu);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    _favoritesMenu = [..._favoritesMenu, menu];
    notifyListeners();
  }

  void remove(Menu menu) {
    // _menuIds.remove(menu.menuId);
    _favoritesMenu =
        _favoritesMenu.where((m) => m.menuId != menu.menuId).toList();
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}
