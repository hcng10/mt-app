import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qwikapp_mini0/macro/constant.dart';
import 'package:qwikapp_mini0/services/auth_service.dart';


import '../ui/login_screen.dart';
import '../ui/register_screen.dart';
import '../ui/forgotpwd_screen.dart';

import '../ui/home_screen.dart';
import '../ui/scan_photo.dart';
import '../ui/scan1_camera.dart';
import '../ui/scan2_preview.dart';
import '../ui/scan3_finish.dart';

// For lab use to collect image data
import '../ui/extra/scan0a_question.dart';
import '../ui/extra/scan0c_info.dart';
import '../ui/extra/scan0b_qr.dart';

//import '../ui/scan0_info.dart';

import '../ui/photo0_view.dart';

import '../services/auth_service.dart';

//Testing purpose for password reset confirm
import '../ui/forgotpwdconfirm_screen.dart';


class SGRouter {

  CustomTransitionPage rightToLeftTransition(BuildContext context,
                                            GoRouterState state,
                                            StatefulWidget widget){
    return CustomTransitionPage<void>(
        key: state.pageKey,
        child: widget,
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {

          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
    );
  }


  late final AuthService authService;
  SGRouter(this.authService);

  late final router = GoRouter(
    // turn off the # in the URLs on the web
      //urlPathStrategy: UrlPathStrategy.path,
      refreshListenable: authService,
      initialLocation: '/rootRouteName',

      routes: <GoRoute>[
        // TODO: Hack to fix bug
        GoRoute(
          path: '/',
          redirect: (context, state) {
            final isLoggedIn = authService.loginState;
            if (isLoggedIn || SKIP_LOGGIN) {
              //print("**DEBUG MSG** hack from root to login");
              //return null;
              return state.namedLocation('_homeRouteName', params: {'tab': 'scan'});
            }
          },
        ),


        GoRoute(
          name: 'rootRouteName',
          path: '/rootRouteName',
          //builder: (context, state) => const LoginScreen(),
          pageBuilder: (context, state) {
            return CustomTransitionPage<void>(
                key: state.pageKey,
                child: const LoginScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                }
            );
          },

          routes:[
            GoRoute(
                name: '_register',
                path: 'register',
                builder: (context, state) {
                  //print("register here");
                  return const RegisterScreen();
                }
            ),
            GoRoute(
                name: '_forgotpwd',
                path: 'forgotpwd',
                builder: (context, state) {
                  return const ForgotpwdScreen();
                }
            ),
            GoRoute(
                name: '_forgotpwdconfirm',
                path: 'forgotpwdconfirm',
                builder: (context, state) {
                  return const ForgotpwdconfirmScreen();
                }
            ),
          ],

          redirect: (context, state) {
            final isLoggedIn = authService.loginState;
            if (isLoggedIn || SKIP_LOGGIN) {
              if (DEBUG_MODE) {
                print("**DEBUG MSG** isLoggedIn");
              }
              //return null;
              return state.namedLocation('_homeRouteName', params: {'tab': 'scan'});
            }else{
              if (DEBUG_MODE) {
                print("**DEBUG MSG** is not LoggedIn");
              }
              //may not work
              //return null;
            }
          },

          //redirect: (context, state) =>
              //state.namedLocation('_homeRouteName', params: {'tab': 'scan'}),
        ),

        GoRoute(
          name: '_homeRouteName',
          path: '/:tab(scan|history)',
          pageBuilder: (context, state) {
            final tab = state.params['tab']!;
            return MaterialPage<void>(
              key: state.pageKey,
              child: HomeScreen(tab: tab),
            );
          },
          routes: [
            GoRoute(
              path: 'scan0a_question',
              //path: 'scan0_info',
              builder: (context, state) {
                return  const Scan0aQuestionScreen();
                //return const Scan0InfoScreen();
              },
              routes: [
                GoRoute(
                  path: 'scan0b_qr',
                    pageBuilder: (context, state) {
                      //HAS_QRSCREEN
                      var screen = Scan0bQRScreen(param: state.extra! as List);
                      //var screen = Scan0bQRScreen(param: state.extra! as List);
                      return rightToLeftTransition(context, state, screen);
                    },
                    routes: [
                      GoRoute(
                        path: 'scan0_info',
                        pageBuilder: (context, state) {
                          //var screen = const Scan0InfoScreen();
                          //HAS_QRSCREEN
                            var screen = Scan0InfoScreen(param: state.extra! as List);
                            return rightToLeftTransition(context, state, screen);
                          },
                          routes: [
                            GoRoute(
                              path: 'scan1_camera',
                              pageBuilder: (context, state) {
                                var screen = Scan1CameraScreen(param: state.extra! as List);
                                return rightToLeftTransition(context, state, screen);
                              },
                              routes: [
                                GoRoute(
                                  path: 'scan2_preview',
                                  pageBuilder: (context, state) {
                                    var screen = Scan2PreviewScreen(param: state.extra! as List);
                                    return rightToLeftTransition(context, state, screen);
                                  },
                                  routes: [
                                    GoRoute(
                                      path: 'scan3_finish',
                                        pageBuilder: (context, state) {
                                          var screen = Scan3FinishScreen(param: state.extra! as List);
                                          return rightToLeftTransition(context, state, screen);
                                      }
                                    ),
                                  ]
                                ),
                              ]
                            ),
                          ]
                      ),
                    ]
                  ),
              ]
            ),

            GoRoute(
                path: 'photo0_view',
                builder: (context, state) {
                  return Photo0ViewScreen(param: state.extra! as List);
                }
            ),

          ],

          // Logout
          redirect: (context, state) {
            final isLoggedIn = authService.loginState;
            if (!isLoggedIn && !SKIP_LOGGIN) {
              if (DEBUG_MODE) {
                print("**DEBUG MSG** isLoggedOut");
              }
              //return null;
              return state.namedLocation('rootRouteName');
            }
          },
        ),
      ]

  );
}