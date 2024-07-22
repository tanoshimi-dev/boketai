import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/models/cart.dart';
import '/providers/favorite_provider.dart';
import '/providers/tab_menu_state_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tabMenuStateProvider = context.watch<TabMenuStateProvider>();
    final int _currentIndex = tabMenuStateProvider.tabMenuIndex;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('FAVORITES', style: Theme.of(context).textTheme.displayLarge),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.amber[100],
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _Favorites(),
              ),
            ),
            const Divider(height: 4, color: Colors.black),
            _PriceTotal()
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
            context.go('/bokes');
          } else {
            context.replace('/menus/favorites');
          }
        },
      ),
    );
  }
}

class _Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var favoriteProvider = context.watch<FavoriteProvider>();

    return ListView.builder(
      itemCount: favoriteProvider.favoritesMenu.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            favoriteProvider.remove(favoriteProvider.favoritesMenu[index]);
          },
        ),
        title: Text(
          favoriteProvider.favoritesMenu[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _PriceTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hugeStyle =
        Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Another way to listen to a model's change is to include
            // the Consumer widget. This widget will automatically listen
            // to CartModel and rerun its builder on every change.
            //
            // The important thing is that it will not rebuild
            // the rest of the widgets in this build method.
            Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) =>
                    Text('\$${favoriteProvider.totalPrice}', style: hugeStyle)),
            const SizedBox(width: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buying not supported yet.')));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
