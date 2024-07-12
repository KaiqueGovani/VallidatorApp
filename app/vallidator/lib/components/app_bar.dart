import 'package:flutter/material.dart';
import 'package:vallidator/helpers/logout.dart';

AppBar userAppBar(BuildContext context,
    {String titleText = 'Vallidator', bool accountIcon = true}) {
  return AppBar(
    leading: !Navigator.canPop(context)
        ? IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        : null,
    title: Text(titleText),
    actions: accountIcon
        ? [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'my-account',
                    arguments: {"isAdmin": false});
              },
              icon: const Icon(Icons.account_circle),
            ),
          ]
        : null,
  );
}

AppBar adminAppBar(BuildContext context,
    {String titleText = 'Vallidator',
    bool accountIcon = true,
    Widget? actionInsteadOfAccountIcon}) {
  return AppBar(
    title: Text(titleText),
    actions: accountIcon
        ? [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'my-account',
                    arguments: {"isAdmin": true});
              },
              icon: const Icon(Icons.account_circle),
            ),
          ]
        : actionInsteadOfAccountIcon == null
            ? null
            : [actionInsteadOfAccountIcon],
  );
}
