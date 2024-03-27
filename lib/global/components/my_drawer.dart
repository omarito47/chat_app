import 'package:chat_app/global/services/auth/auth_service.dart';
import 'package:chat_app/global/utils/constant_helper.dart';
import 'package:chat_app/modules/pages/settings_page.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.primary,
                  size: ConstantHelper.sizex40,
                ),
              )),
              // home list tile
              Padding(
                padding:  EdgeInsets.only(left: ConstantHelper.sizex25),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.primary),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // settings list tile
              Padding(
                padding:  EdgeInsets.only(left: ConstantHelper.sizex25),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.primary),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ));
                  },
                ),
              ),
            ],
          ),
          // logout list tile
          Padding(
            padding:  EdgeInsets.only(left: ConstantHelper.sizex25, bottom: ConstantHelper.sizex25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Icon(Icons.logout,
                  color: Theme.of(context).colorScheme.primary),
              onTap: () {
                logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
