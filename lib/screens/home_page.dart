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
              ? WindmillPage(accountModel: state.accountModel)
              : CreateAccountPage(),
          bottomNavigationBar: showBottomNavigationBar
              ? BottomNavigationBar(
                  currentIndex: 0,
                  // this will be set when a new tab is tapped
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.blueAccent,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white.withOpacity(.60),
                  selectedFontSize: 14,
                  unselectedFontSize: 14,
                  onTap: (value) {
                    print("BottomNavigationBarItem tap");
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.mail),
                      label: 'Messages',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    )
                  ],
                )
              : null,
        );
      },
    );
  }
}
