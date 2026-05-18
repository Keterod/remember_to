import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/notification_resume_refresh.dart';

class RememberToApp extends ConsumerWidget {
  const RememberToApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationResumeRefresh(
      child: MaterialApp.router(
        title: 'Remember To.App',
        theme: AppTheme.light(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
