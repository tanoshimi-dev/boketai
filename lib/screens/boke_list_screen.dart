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

class BokeListScreen extends StatelessWidget {
  const BokeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tabMenuStateProvider = context.watch<TabMenuStateProvider>();
    final int _currentIndex = tabMenuStateProvider.tabMenuIndex;

    //late Future<List<Boke>>? bokeList = getBokes(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Boke', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: BokeList(),
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
            context.go('/menus');
          } else {
            context.go('/menus/favorites');
          }
        },
      ),
    );
  }
}

class BokeList extends StatefulWidget {
  const BokeList({super.key});

  @override
  _BokeListState createState() => _BokeListState();
}

class _BokeListState extends State<BokeList> {
  final int loadLength = 3;

  int _lastIndex = 0;
  double _lastScrollPosition = 0.0;
  bool _isLoading = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();
  late List<Boke> _items = [];

  late Future<List<Boke>>? bokeList = null;

  @override
  void initState() {
    super.initState();
    this._lastIndex = 0;
    //_fetchData();
    // bokeList = getAllBokes(
    //     context, 0, (_lastIndex + loadLength) - 1, _items, updateIndex);
    bokeList = fetchBokeList();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // print('scrolling...');
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      //_fetchData();
      print('やった～✌');
      if (_hasMore) {
        _lastScrollPosition = _scrollController.position.pixels;
        bokeList = fetchBokeList();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void updateIndex(currentIndex) {
    setState() => this._lastIndex = currentIndex;
    print('called updateIndex $currentIndex');
  }

  Future<List<Boke>> fetchBokeList() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final response = await supabase
        .from('boke')
        .select('id, created_at, prompt,'
                '\n' +
            'boke_comment(id, seq, created_at, comment, user_id, boke_user!inner(*)),'
                '\n' +
            'boke_rank(id, rank, created_at, fav_count)')
        .range(_lastIndex, (_lastIndex + loadLength) - 1);

    print('💰 fetchBokeList called _lastIndex ${_lastIndex} ');
    print(response);

    List<Boke> fetchedBokes = List<Map<String, dynamic>>.from(response)
        .map((item) => Boke.fromJson(item))
        .toList();

    if (_items.length == 0) {
      _items = fetchedBokes;
      print('💰 fetchBokeList 2 ');
    } else {
      if (fetchedBokes != null) {
        for (int i = 0; i < fetchedBokes.length; i++) {
          _items.add(fetchedBokes[i]);
        }
        print('💰 fetchBokeList 3 ');

        if (fetchedBokes.length < loadLength) {
          setState(() {
            _hasMore = false;
          });
        }
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    }

    _lastIndex = _items.length;
    print('💰 fetchBokeList 4 ');
    // for (int i = 0; i < _items.length; i++) {
    //   print('_items[i].id = ${_items[i].id} ${_items[i].prompt}');
    // }

    setState(() {
      bokeList = Future.value(_items);
      print('💰 fetchBokeList 5 ');
    });

    //updateIndex(_items.length);

    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        //_MyAppBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        FutureBuilder<List<Boke>>(
          future: bokeList,
          //future: fetchBokeList(),
          builder: (BuildContext context, AsyncSnapshot<List<Boke>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting1...');
              return SliverFillRemaining(
                child: Center(
                  child: SizedBox(
                    height: 50.0, // Set the height
                    width: 50.0, // Set the width
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.amber), // Set the color
                      strokeWidth: 4.0, // Set the stroke width
                    ),
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              // // If we got data
              List<Boke>? bokes = snapshot.data;
              print('initState _lastScrollPosition ${_lastScrollPosition}');

              if (_lastScrollPosition != 0.0) {
                _scrollController.animateTo(_lastScrollPosition,
                    duration: Duration(milliseconds: 10), curve: Curves.easeIn);
              }
              // if (bokes != null) {
              //   for (int i = 0; i < bokes!.length; i++) {
              //     // print(bokes[i]);
              //     print('_items[i].id = ${bokes[i].id} ${bokes[i].prompt}');
              //   }
              // }

              print('_lastIndex ${_lastIndex} bokes.length ${bokes?.length}');

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _MyListItem(
                      boke: bokes![index],
                    );
                  },
                  childCount: bokes?.length ?? 0,
                  // childCount: _lastIndex,
                ),
              );
            } else {
              print('waiting2...');
              return SliverFillRemaining(
                child: Center(
                  child: SizedBox(
                    height: 50.0, // Set the height
                    width: 50.0, // Set the width
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.red), // Set the color
                      strokeWidth: 4.0, // Set the stroke width
                    ),
                  ),
                ),
              );
            }
          },
        )
      ],
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('MENU', style: Theme.of(context).textTheme.displayLarge),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => context.go('/menus/favorites'),
        ),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final Boke boke;
  const _MyListItem({required this.boke});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 96),
      child: LimitedBox(
        maxHeight: 40,
        child: InkWell(
          onTap: () => context.go('/menus/detail/${boke.id.toString()}'),
          child: Row(
            children: [
              Text(boke.id.toString()),
              const SizedBox(width: 24),
              Expanded(
                child: Text(boke.prompt,
                    style: textTheme?.copyWith(fontSize: 16.0)),
              ),
              const SizedBox(width: 6),
              //_FavIcon(boke: boke),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavIcon extends StatelessWidget {
  final Menu menu;

  const _FavIcon({required this.menu});

  @override
  Widget build(BuildContext context) {
    var isFavorite = context.select<FavoriteProvider, bool>(
      (favoriteProvider) => favoriteProvider.favoritesMenu.contains(menu),
    );

    return isFavorite
        ? Icon(
            Icons.check,
            color: Colors.grey, // Change the color of the icon
            size: 24.0, // Change the size of the icon
            semanticLabel: 'ADDED',
          )
        : Text('');
  }
}

// DBからメニュー情報を取得する
Future<List<Boke>> getBokes(
    BuildContext context, int rangeFrom, int rangeTo) async {
  final SupabaseClient supabase = Supabase.instance.client;

  final response = await supabase
      .from('boke')
      .select('id, created_at, prompt,'
              '\n' +
          'boke_comment(id, seq, created_at, comment, user_id, boke_user!inner(*)),'
              '\n' +
          'boke_rank(id, rank, created_at, fav_count)')
      .range(rangeFrom, rangeTo);

  //print(response);

  List<Boke> bokes = List<Map<String, dynamic>>.from(response)
      .map((item) => Boke.fromJson(item))
      .toList();

  return bokes;
}

Future<List<Boke>> getAllBokes(BuildContext context, int rangeFrom, int rangeTo,
    List<Boke> bokeList, Function updateFunc) async {
  final SupabaseClient supabase = Supabase.instance.client;

  final response = await supabase
      .from('boke')
      .select('id, created_at, prompt,'
              '\n' +
          'boke_comment(id, seq, created_at, comment, user_id, boke_user!inner(*)),'
              '\n' +
          'boke_rank(id, rank, created_at, fav_count)')
      .range(rangeFrom, rangeTo);

  //print(response);
  print('💰 getAllBokes called');

  List<Boke> fetchedBokes = List<Map<String, dynamic>>.from(response)
      .map((item) => Boke.fromJson(item))
      .toList();

  if (bokeList.length == 0) {
    bokeList = fetchedBokes;
  }

  if (fetchedBokes != null) {
    for (int i = 0; i < fetchedBokes.length; i++) {
      bokeList.add(fetchedBokes[i]);
    }

    updateFunc(bokeList.length);
  }

  return bokeList;
}
