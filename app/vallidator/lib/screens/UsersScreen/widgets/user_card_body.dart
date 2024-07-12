// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vallidator/helpers/show_snackbar_in_scaffold.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/screens/UsersScreen/widgets/edit_button.dart';
import 'package:vallidator/services/user_service.dart';
import 'package:vallidator/themes/main_colors.dart';

class UserCardBody extends StatefulWidget {
  final User user;
  const UserCardBody({super.key, required this.user});

  @override
  State<UserCardBody> createState() => _UserCardBodyState();
}

class _UserCardBodyState extends State<UserCardBody> {
  late bool makeUploads;
  late bool canCreateTemplates;
  late bool isAdmin;

  @override
  void initState() {
    super.initState();
    refreshPerms();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: MainColors.inactiveGreen,
            width: 2,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      '# ${widget.user.id} ${widget.user.nome} ${widget.user.sobrenome}',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 16,
                ),
                Expanded(
                  child: Text('  ${widget.user.email}',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 16,
                ),
                Expanded(
                  child: Text('  ${widget.user.telefone}',
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Make Uploads',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        letterSpacing: 0.3,
                        fontSize: 20,
                      ),
                ),
                Checkbox(
                  value: makeUploads,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        if (!isAdmin) {
                          makeUploads = value;
                          changePermission(widget.user).then((result) {
                            if (!result) {
                              refreshPerms();
                            }
                          });
                        } else {
                          showSnackbarInScaffold(
                              context, 'User already has admin permission!');
                        }
                      });
                    }
                  },
                  activeColor: MainColors.tertiary,
                  side: const BorderSide(
                      color: MainColors.activeGreen, width: 1.5),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Templates',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      letterSpacing: 0.3,
                      fontSize: 20),
                ),
                Checkbox(
                  value: canCreateTemplates,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        if (!isAdmin) {
                          canCreateTemplates = value;
                          changePermission(widget.user).then((result) {
                            if (!result) {
                              refreshPerms();
                            }
                          });
                        } else {
                          showSnackbarInScaffold(
                              context, 'User already has admin permission!');
                        }
                      });
                    }
                  },
                  activeColor: MainColors.tertiary,
                  side: const BorderSide(
                      color: MainColors.activeGreen, width: 1.5),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Administrator',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      letterSpacing: 0.3,
                      fontSize: 20),
                ),
                Checkbox(
                  value: isAdmin,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        isAdmin = value;
                        makeUploads = false;
                        canCreateTemplates = false;
                        changePermission(widget.user).then((result) {
                          if (!result) {
                            refreshPerms();
                          }
                        });
                      });
                    }
                  },
                  activeColor: MainColors.tertiary,
                  side: const BorderSide(
                      color: MainColors.activeGreen, width: 1.5),
                ),
              ],
            ),
            EditButton(user: widget.user),
          ],
        ));
  }

  Future<bool> changePermission(User user) async {
    List<String> perms = [];
    if (isAdmin) {
      perms.add('admin');
    }
    if (makeUploads) {
      perms.add('upload');
    }
    if (canCreateTemplates) {
      perms.add('criar');
    }

    String perm = perms.isEmpty ? 'ver' : perms.join(':');

    try {
      bool success = await UserService().patchUserPermission(user, perm);
      if (success) {
        showSnackbarInScaffold(
            context, 'User: ${user.nome} permission changed to $perm');
      } else {
        showSnackbarInScaffold(context, 'Error changing user permission!');
      }
      return success;
    } catch (error) {
      showSnackbarInScaffold(
          context, "Error: ${(error as HttpException).message}");
      return false;
    }
  }

  void refreshPerms() {
    makeUploads = widget.user.permissao.contains('upload');
    canCreateTemplates = widget.user.permissao.contains('criar');
    isAdmin = widget.user.permissao.contains('admin');
  }
}
