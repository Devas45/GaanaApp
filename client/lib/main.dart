import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPrefernces();
  await container.read(authViewModelProvider.notifier).getData();
  // print(userModel);
  runApp(
    UncontrolledProviderScope(
      child: MyApp(),
      container: container,
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Music App',
      theme: AppTheme.darkThemeMode,
      home: currentUser == null ? const SignupPage() : const UploadSongPage(),
    );
  }
}
