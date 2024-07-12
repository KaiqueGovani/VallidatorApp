import 'package:flutter/material.dart';
import 'package:vallidator/components/app_bar.dart';
import 'package:vallidator/helpers/reroute_with_permission.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/screens/MyAccountScreen/widgets/delete_user_button.dart';
import 'package:vallidator/services/user_service.dart';
import 'package:vallidator/themes/main_colors.dart';

// ignore: must_be_immutable
class MyAccountScreen extends StatelessWidget {
  final bool isAdmin;
  MyAccountScreen({super.key, this.isAdmin = false, this.edittingUser});
  final User? edittingUser;
  final UserService userService = UserService();

  Widget _body(BuildContext context,
      {bool isAdmin = false, required User user}) {
    //TextEditingController for each field
    TextEditingController nameController =
        TextEditingController(text: user.nome);
    TextEditingController surnameController =
        TextEditingController(text: user.sobrenome);
    TextEditingController phoneNumberController =
        TextEditingController(text: user.telefone);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController permissionController = TextEditingController(
        text: user.permissao == 'admin' ? "Admin" : "User");
    TextEditingController userIdController =
        TextEditingController(text: user.id.toString());

    return Scaffold(
      appBar: isAdmin
          ? adminAppBar(context,
              titleText: edittingUser != null
                  ? '${edittingUser!.nome == '' ? 'User' : edittingUser!.nome}`s Info'
                  : 'My Account',
              accountIcon: false)
          : userAppBar(context, titleText: 'My Account', accountIcon: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 16),
                child: Text(
                  edittingUser != null
                      ? '${edittingUser!.nome == '' ? 'User' : edittingUser!.nome}`s Info'
                      : 'My Account Data',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 16,
                  top: 16,
                  left: 32,
                  right: 32,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: MainColors.inactiveGreen,
                    width: 1,
                  ),
                ),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'Surname',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: surnameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'Phone Number',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'Email',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: emailController,
                        enabled: isAdmin,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          fillColor: !isAdmin ? MainColors.disabledColor : null,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'Permission',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: permissionController,
                        enabled: false,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          fillColor: MainColors.disabledColor,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            'User ID',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: userIdController,
                        enabled: false,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          fillColor: MainColors.disabledColor,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          userService
                              .updateUserData(
                            isAdmin,
                            User(
                              id: user.id,
                              nome: nameController.text,
                              sobrenome: surnameController.text,
                              telefone: phoneNumberController.text,
                              email: emailController.text,
                              senha: '',
                              permissao: user.permissao,
                            ),
                          )
                              .then((result) {
                            if (result) {
                              showSnackbarInScaffold(
                                  context, 'User data updated!');
                            } else {
                              showSnackbarInScaffold(
                                  context, 'Error updating user data!');
                            }
                            if (edittingUser != null) {
                              rerouteWithPermission(context, route: 'users');
                            } else {
                              Navigator.pop(context);
                            }
                          }).catchError((error) {
                            showSnackbarInScaffold(context, error.toString());
                          });
                        },
                        style: MainColors.successButton,
                        child: const Text('Save'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: MainColors.dangerButton,
                        child: const Text('Cancel'),
                      ),
                      if (edittingUser != null) ...{
                        const SizedBox(
                          height: 16,
                        ),
                        DeleteUserButton(user: edittingUser!),
                      }
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = edittingUser ?? snapshot.data as User;
          return _body(context, isAdmin: isAdmin, user: user);
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
