import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/models/account_model.dart';

class ViewWindmillPage extends StatelessWidget {
  final AccountModel accountModel;

  const ViewWindmillPage({@required this.accountModel})
      : assert(accountModel != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewWindmillForm(
        accountModel: this.accountModel,
      ),
    );
  }
}

class ViewWindmillForm extends StatefulWidget {
  final AccountModel accountModel;

  const ViewWindmillForm({@required this.accountModel})
      : assert(accountModel != null);

  @override
  State<ViewWindmillForm> createState() => _ViewWindmillFormState();
}

class _ViewWindmillFormState extends State<ViewWindmillForm> {
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
                print("floatingActionButton onPressed !");

                BlocProvider.of<WindmillBloc>(context).add(
                  WindmillCreateInitialize(),
                );
              },
              tooltip: 'Add new',
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
