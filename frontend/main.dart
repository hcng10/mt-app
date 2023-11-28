import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/auth_service.dart';
import 'services/photolist_service.dart';
import 'router/routes.dart';

import './macro/constant.dart';
import './macro/text.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(QwikAppMini(sharedPreferences: sharedPreferences));
}



class QwikAppMini extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const QwikAppMini({
    Key? key,
    required this.sharedPreferences,
  }) : super(key: key);

  @override
  State<QwikAppMini> createState() => _QwikAppMiniState();
}

class _QwikAppMiniState extends State<QwikAppMini> {
  late AuthService authService;
  late PhotoListService photoListService;

  // This widget is the root of your application.
  @override
  void initState() {
    authService = AuthService(widget.sharedPreferences);
    photoListService = PhotoListService(widget.sharedPreferences);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: photoListService),
        Provider<SGRouter>(
          lazy: false,
          create: (BuildContext createContext) => SGRouter(authService),
        ),
      ],
      child: Builder(builder: (BuildContext context){
        final router = Provider.of<SGRouter>(context, listen: false).router;

        return MaterialApp.router(
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            //DefaultCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.grey,
            //primaryColor: COLOR_BLUE? Colors.blue:
                            //COLOR_GREY ? Colors.grey:
                            //Colors.black,
            brightness: Brightness.light,
          )
        );
      }),
    );
  }
}

