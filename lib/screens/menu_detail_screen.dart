import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/providers/favorite_provider.dart';
import '/providers/menus_provider.dart';
import '/providers/tab_menu_state_provider.dart';
import '/models/menu.dart';
import '/models/menus.dart';

class MenuDetailScreen extends StatelessWidget {
  const MenuDetailScreen({super.key, required this.menuId});
  final int menuId;

  @override
  Widget build(BuildContext context) {
    var tabMenuStateProvider = context.watch<TabMenuStateProvider>();
    final int _currentIndex = tabMenuStateProvider.tabMenuIndex;
    var menusProvider = context.watch<MenusProvider>();


    Menu? menu = menusProvider.menus.firstWhere((menu) => menu.menuId == menuId,
        orElse: () => const Menu(
            menuId: 1, name: 'Unknown Menu', description: '', price: 0));

    return Scaffold(
      appBar: AppBar(
        title: Text('MENU $menuId DETAIL',
            style: Theme.of(context).textTheme.displayLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(menu.name, style: Theme.of(context).textTheme.titleLarge),
            Text(menu.description,
                style: Theme.of(context).textTheme.titleSmall),
            Text('\$${menu.price}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            _FavButton(menu: menu),
          ],
        ),
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

          if (index == 0) {
            context.go('/menus');
          } else {
            context.replace('/menus/favorites');
          }
        },
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  final Menu menu;

  const _FavButton({required this.menu});

  @override
  Widget build(BuildContext context) {


    var isFavorite = context.select<FavoriteProvider, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (favoriteProvider) => favoriteProvider.favoritesMenu.contains(menu),
    );

    return TextButton(
      onPressed: isFavorite
          ? null
          : () {

              var favoriteProvider = context.read<FavoriteProvider>();
              favoriteProvider.add(menu);
              print('Favorite add $menu.name');
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isFavorite
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}
