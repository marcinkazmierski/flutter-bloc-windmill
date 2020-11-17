import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/account_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/screens/create_account_page.dart';
import 'package:windmill/screens/windmill_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        bool showBottomNavigationBar =
            (state is AccountCreateSuccess) || (state is WindmillState);

        return Scaffold(
          body: (state is AccountCreateSuccess)
              //? CreateWindmillPage(accountModel: state.accountModel)
              ? WindmillPage(accountModel: state.accountModel)
              : CreateAccountPage(),
        );
      },
    );
  }
}
