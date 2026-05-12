import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> setupWindow() async {
  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    minimumSize: Size(800, 600),
    size: Size(1100, 750),
    title: 'Pengulist',
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
