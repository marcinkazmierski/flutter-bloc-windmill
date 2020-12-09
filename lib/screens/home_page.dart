import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/account_bloc.dart';
import 'package:windmill/screens/create_account_page.dart';
import 'package:windmill/screens/windmill_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Scaffold(
          body: (state is AccountCreateSuccessState)
              ? WindmillPage(accountModel: state.accountModel)
              : CreateAccountPage(),
        );
      },
    );
  }
}
