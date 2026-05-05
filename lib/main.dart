import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

import 'window_setup_stub.dart'
    if (dart.library.io) 'window_setup_io.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web bundler skips dotfiles; use a plain-named file on web instead
  await dotenv.load(fileName: kIsWeb ? 'assets/config.env' : '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows)) {
    await setupWindow();
  }

  runApp(const ProviderScope(child: App()));
}
