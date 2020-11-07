import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/models/account_model.dart';

class WindmillPage extends StatelessWidget {
  final AccountModel accountModel;

  const WindmillPage({@required this.accountModel})
      : assert(accountModel != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindmillForm(
        accountModel: this.accountModel,
      ),
    );
  }
}

class WindmillForm extends StatefulWidget {
  final AccountModel accountModel;

  const WindmillForm({@required this.accountModel})
      : assert(accountModel != null);

  @override
  State<WindmillForm> createState() => _WindmillFormState();
}

class _WindmillFormState extends State<WindmillForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WindmillBloc, WindmillState>(
      listener: (context, state) {
        if (state is WindmillCreateFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<WindmillBloc, WindmillState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.wb_sunny_outlined, size: 50),
                          title: Text('Your Windmill'),
                          subtitle:
                              Text('Name: ' + this.widget.accountModel.name),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Image.asset('assets/images/windmill.png'),
                        ),
                      ])),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print("floatingActionButton onPressed");
              },
              tooltip: 'Add new',
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              // this will be set when a new tab is tapped
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.blueAccent,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(.60),
              selectedFontSize: 14,
              unselectedFontSize: 14,
              onTap: (value) {
                print("BottomNavigationBarItem tap: " + value.toString());
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
            ),
          );
        },
      ),
    );
  }
}
