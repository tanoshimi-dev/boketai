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

class MenuListScreen extends StatelessWidget {
  const MenuListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tabMenuStateProvider = context.watch<TabMenuStateProvider>();
    final int _currentIndex = tabMenuStateProvider.tabMenuIndex;

    // var menusProvider = context.read<MenusProvider>();
    // late Future<List<Menu>>? menuList = getMenus(context);
    // print('menuList  ${menusProvider.menus.length}');
    // if (menusProvider.menus.length == 0) {
    //   menusProvider.setMenus(menuList);
    //   print('DB検索しました ${menusProvider.menus.length}');
    // }

    late Future<List<Boke>>? bokeList = getBokes(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: CustomScrollView(
        slivers: [
          //_MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          //FutureBuilder<List<Menu>>(
          // future: menuList,
          FutureBuilder<List<Boke>>(
            future: bokeList,

            // future: Future.delayed(Duration(seconds: 5),
            //     () => menusProvider.menus), // The Future you want to execute
            builder:
                (BuildContext context, AsyncSnapshot<List<Boke>> snapshot) {
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
                // If we got an error

                // print(
                //     'menusProvider.menus.length=${menusProvider.menus.length}');

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // If we got data
                List<Boke>? bokes = snapshot.data;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return _MyListItem(
                        boke: bokes![index],
                      );
                    },
                    childCount: bokes?.length ?? 0,
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
      ),
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

// class _MyListItem extends StatelessWidget {
//   final Menu menu;
//   const _MyListItem({required this.menu});

//   @override
//   Widget build(BuildContext context) {
//     var textTheme = Theme.of(context).textTheme.titleLarge;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//       child: LimitedBox(
//         maxHeight: 24,
//         child: InkWell(
//           onTap: () => context.go('/menus/detail/${menu.menuId.toString()}'),
//           child: Row(
//             children: [
//               Text(menu.menuId.toString()),
//               const SizedBox(width: 24),
//               Expanded(
//                 child:
//                     Text(menu.name, style: textTheme?.copyWith(fontSize: 16.0)),
//               ),
//               const SizedBox(width: 6),
//               _FavIcon(menu: menu),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
Future<List<Boke>> getBokes(BuildContext context) async {
  final SupabaseClient supabase = Supabase.instance.client;

  final response = await supabase
      .from('boke')
      .select('id, created_at, prompt,'
              '\n' +
          'boke_comment(id, seq, created_at, comment, user_id, boke_user!inner(*)),'
              '\n' +
          'boke_rank(id, rank, created_at, fav_count)')
      .range(0, 15);

  print(response);

  List<Boke> bokes = List<Map<String, dynamic>>.from(response)
      .map((item) => Boke.fromJson(item))
      .toList();

  return bokes;
}

// TODO
// DBからメニュー情報を取得する
Future<List<Menu>> getMenus(BuildContext context) async {
  // Add a return statement at the end
  var menusProvider = context.read<MenusProvider>();
  print('getMenus 現在数 ${menusProvider.menus.length}');

  if (menusProvider.menus.length > 0) {
    print('DB検索しません ${menusProvider.menus.length}');
    return menusProvider.menus;
  }

  try {
    // エミュレーターから（ローカルPC内の）dockerコンテナへのアドレスは10.0.2.2となる
    // final response =
    //     await http.get(Uri.parse('http://10.0.2.2:15011/api/menus')).timeout(
    //   const Duration(seconds: 15),
    //   onTimeout: () {
    //     throw TimeoutException('The connection has timed out!');
    //   },
    // );

    // 実機でアクセスする場合
    final response = await http
        .get(Uri.parse('http://192.168.0.154:15011/api/menus'))
        .timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException('The connection has timed out!');
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      var data = jsonResponse['data'];
      // print(data);
      // print(data.length);
      List<Map<String, dynamic>> dataList =
          List<Map<String, dynamic>>.from(data);

      // Now you can iterate over dataList
      for (var menu in dataList) {
        //print(item);
        // item.forEach((key, value) {
        //   print('Key: $key, Value: $value');
        // });
        print('item message=${menu['id']} number=${menu['name']}');
      }

      List<Menu> menuList = dataList.map((menu) {
        return Menu(
          menuId: menu['id'],
          name: menu['name'],
          price: menu['price'] ?? 0,
          description: menu['description'] ?? 'No description',
        );
      }).toList();
      return menuList;

      //return dataList;
    } else {
      // If the server returns an unexpected response, throw an error.
      throw Exception('Unexpected response from the server!');
    }
  } on TimeoutException catch (e) {
    // Handle the timeout exception
    print(e.message);
    return [];
  } catch (e) {
    // Handle any other exceptions
    print(e);
    return [];
  }
  return [];
}
