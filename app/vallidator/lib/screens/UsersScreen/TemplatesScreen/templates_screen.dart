import 'package:flutter/material.dart';
import 'package:vallidator/components/admin_scaffold.dart';
import 'package:vallidator/components/user_scaffold.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/TemplatesScreen/widgets/templates_card.dart';
import 'package:vallidator/services/templates_service.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  Widget _body(BuildContext context,
      {bool isAdmin = false,
      required List<Template> templates,
      required String permission}) {
    return TemplatesCard(
      isAdmin: isAdmin,
      templates: templates,
      permission: permission,
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'add-template');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = ((ModalRoute.of(context)!.settings.arguments as String)
        .contains('admin'));
    String permission = ModalRoute.of(context)!.settings.arguments as String;
    print("Rendering with permission $permission");
    print("Rendering TemplatesScreen with isAdmin=$isAdmin");

    String titleText = isAdmin ? 'Templates' : 'My Templates';

    TemplateService templateService = TemplateService();

    return FutureBuilder(
        future: templateService.listTemplates(isAdmin),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Widget body = _body(context,
                isAdmin: isAdmin,
                templates: snapshot.data as List<Template>,
                permission: permission);

            return isAdmin
                ? adminScaffold(
                    context,
                    titleText: titleText,
                    body: body,
                    floatingActionButton: _floatingActionButton(context),
                  )
                : userScaffold(
                    context,
                    titleText: titleText,
                    body: body,
                    floatingActionButton: permission.contains('criar')
                        ? _floatingActionButton(context)
                        : null,
                  );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
