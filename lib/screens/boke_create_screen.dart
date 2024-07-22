// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '/providers/menus_provider.dart';
import '/providers/favorite_provider.dart';
import '/providers/tab_menu_state_provider.dart';
import '/models/menu.dart';
import '/models/menus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/boke.dart';
import 'package:flutter/src/painting/image_resolution.dart';

class BokeCreateScreen extends StatelessWidget {
  const BokeCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tabMenuStateProvider = context.watch<TabMenuStateProvider>();
    final int _currentIndex = tabMenuStateProvider.tabMenuIndex;

    //late Future<List<Boke>>? bokeList = getBokes(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Boke', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: BokeCreate(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            label: 'Favorites',
          ),
        ],
        // Set the current index
        currentIndex: _currentIndex,
        onTap: (int index) {
          tabMenuStateProvider.setTabMenuIndex(index);
          print('Add your code here');
          // getMenus();
          if (index == 0) {
            context.go('/bokes');
          } else {
            context.go('/menus/favorites');
          }
        },
      ),
    );
  }
}

class BokeCreate extends StatefulWidget {
  const BokeCreate({super.key});

  @override
  _BokeCreateState createState() => _BokeCreateState();
}

class _BokeCreateState extends State<BokeCreate> {
  int _lastIndex = 0;
  double _lastScrollPosition = 0.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _onScroll() {}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            child: Column(
              children: [
                const Image(
                  image: AssetImage(
                    'assets/image/easel_with_paint_palette_and_cup_with_brushes.png',
                  ),
                ),
                // Add more widgets here
                Text('Your Text Here'),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  child: TextField(
                    maxLines: null, // Makes it auto-expandable
                    decoration: InputDecoration(
                      hintText: "プロンプトを入力してください",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Your button action here
                  },
                  child: Text('生成'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: TextField(
              maxLines: null, // Makes it auto-expandable
              decoration: InputDecoration(
                hintText: "プロンプトを入力してください",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
