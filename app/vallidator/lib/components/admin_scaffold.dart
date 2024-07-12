import 'package:flutter/material.dart';
import 'package:vallidator/components/app_bar.dart';
import 'package:vallidator/helpers/logout.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';

Scaffold adminScaffold(BuildContext context,
    {required Widget body,
    String titleText = 'Vallidator',
    Widget? floatingActionButton, 
    bool accountIcon = true,
    Widget? actionInsteadOfAccountIcon}) {
  return Scaffold(
    drawer: Drawer(
      child: ListView(children: <ListTile>[
        ListTile(
          leading: const Icon(Icons.insert_chart_outlined_outlined),
          title: const Text('Dashboard'),
          onTap: () {
            rerouteWithPermission(context, route: 'dashboard');
          },
        ),
        ListTile(
          leading: const Icon(Icons.file_open_outlined),
          title: const Text('Templates'),
          onTap: () {
            rerouteWithPermission(context, route: 'templates');
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('Users'),
          onTap: () {
            rerouteWithPermission(context, route: 'users');
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            logout(context);
          },
        )
      ]),
    ),
    appBar: adminAppBar(context, titleText: titleText, accountIcon: accountIcon, actionInsteadOfAccountIcon: actionInsteadOfAccountIcon),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}
