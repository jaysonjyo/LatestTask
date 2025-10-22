import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Ui/splash.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'Ui/myfeeds.dart';
import 'Ui/feed_create.dart';
import 'Ui/home_screen.dart';
import 'Ui/login_screen.dart';
import 'features/home_main/presentation/providers/home_provider.dart';
import 'features/my_feeds/presentation/providers/my_feed_provider.dart';
import 'injection.dart';

void main() {
  // initialize gateway
  final gateway = Gateway();

  runApp(MyApp(gateway: gateway));
}

class MyApp extends StatelessWidget {
  final Gateway gateway;

  const MyApp({super.key, required this.gateway});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ inject providers
        ChangeNotifierProvider(create: (_) => AuthProvider(gateway.signIn)),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(gateway.getHomeData),
        ),
        // ✅ MyFeed Provider
        ChangeNotifierProvider(
          create:
              (_) => MyFeedProvider(
                gateway
                    .myFeedRepository, // we'll define this next in injection.dart
              ),
        ),
        ChangeNotifierProvider(create: (_) => gateway.createFeedProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // ✅ first screen (your login / mobile number)
        home: const SplashScreen(),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/myfeeds': (_) => const Myfeeds(),
        },
      ),
    ); //8129466718
  }
}
