import 'package:flutter/material.dart';
import 'package:vallidator/components/app_bar.dart';

Scaffold userScaffold(BuildContext context,
    {required Widget body, String titleText = 'Vallidator', Widget? floatingActionButton}) {
  return Scaffold(
    appBar: userAppBar(context, titleText: titleText),
    body: body,
    floatingActionButton: floatingActionButton,
  );
}       