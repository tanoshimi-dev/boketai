// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

class TabMenuStateProvider extends ChangeNotifier {
  int _tabMenuIndex = 0;

  int get tabMenuIndex => _tabMenuIndex;

  void setTabMenuIndex(int nextIndex) {
    _tabMenuIndex = nextIndex;
    notifyListeners();
  }
}
