import 'package:flutter/material.dart';

Widget createPopupMenuButton(
  Map<String, void Function()> menuEntries,
) {
  final list = <PopupMenuItem<String>>[];
  return PopupMenuButton<String>(itemBuilder: (context) {
    menuEntries.forEach(
      (key, value) => list.add(
        PopupMenuItem<String>(
          value: key,
          child: Text(key),
          onTap: () async {
            value.call();
          },
        ),
      ),
    );
    return list;
  });
}
