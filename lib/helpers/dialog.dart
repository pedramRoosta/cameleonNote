import 'package:cameleon_note/services/router/nav_service.dart';
import 'package:cameleon_note/setup.dart';
import 'package:flutter/material.dart';

enum DialogType {
  error,
  info,
  warning,
  help,
}

Future<void> showAppDialog({
  required String message,
  DialogType dialogType = DialogType.info,
  String? title,
}) {
  final navigator = locateService<INavService>();
  return showDialog(
    context: navigator.currentContext!,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      title: title != null ? Text(title) : null,
      actions: [
        TextButton(
          onPressed: () => navigator.pop(),
          child: const Text('Dismiss'),
        ),
      ],
    ),
  );
}
