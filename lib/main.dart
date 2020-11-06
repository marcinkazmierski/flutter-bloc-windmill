import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/account_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/blocs/simple_bloc_observer.dart';
import 'package:windmill/screens/create_account_page.dart';
import 'package:windmill/screens/home_page.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  print("START APP ;)");

  runApp(
    BlocProvider<AccountBloc>(
      create: (context) {
        AccountBloc accountBloc = AccountBloc();
        return accountBloc;
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo ver1.1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AccountBloc>(
                  create: (context) => AccountBloc(),
                ),
                BlocProvider<WindmillBloc>(
                  create: (context) => WindmillBloc(
                    accountBloc: BlocProvider.of<AccountBloc>(context),
                  ),
                ),
              ],
              child: HomePage(),
            );
          }
        });
  }
}
