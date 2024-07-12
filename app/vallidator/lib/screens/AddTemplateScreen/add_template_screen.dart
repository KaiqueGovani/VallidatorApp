import 'package:flutter/material.dart';
import 'package:vallidator/components/app_bar.dart';
import 'package:vallidator/models/Template.dart';
import 'package:vallidator/screens/AddTemplateScreen/widgets/add_template_form.dart';

class AddTemplateScreen extends StatelessWidget {
  const AddTemplateScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Template? template = ModalRoute.of(context)?.settings.arguments
        as Template?; // Get the template from the arguments

    return Scaffold(
      appBar:
          userAppBar(context, titleText: template != null ? template.status == null ? 'Verify Template' : 'Edit Template' : 'Add Template', accountIcon: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                    top: 16,
                  ),
                  child: Text(template != null ? template.status == null ? 'Verify Template' : 'Edit Template' : 'Add Template',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  )),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: AddTemplateForm(template: template),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
