import 'package:flutter/material.dart';
import 'package:vallidator/components/admin_scaffold.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/files_info_card.dart';
import 'package:vallidator/screens/DashboardScreen/widgets/templates_info_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return adminScaffold(context,
        titleText: 'Dashboard',
        accountIcon: false,
        actionInsteadOfAccountIcon: IconButton(
          onPressed: () {
            rerouteWithPermission(context, route: 'dashboard');
          },
          icon: const Icon(Icons.refresh),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              TemplatesInfoCard(),
              SizedBox(height: 16),
              FilesInfoCard(),
            ],
          ),
        ));
  }
}
