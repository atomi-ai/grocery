import 'package:flutter/material.dart';
import 'package:fryo/src/logic/user_provider.dart';
import 'package:provider/provider.dart';

import 'Dashboard.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) ...[
            Text('Hello, ${user.displayName}'),
            SizedBox(height: 10),
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL),
              radius: 40,
            ),
            SizedBox(height: 20),
          ],
          ElevatedButton(
            onPressed: () async {
              await userProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Dashboard(pageTitle: 'Welcome'),
                ),
              );
            },
            child: Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
