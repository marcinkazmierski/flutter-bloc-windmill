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
      body: WindmillForm(),
    );
  }
}

class WindmillForm extends StatefulWidget {
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
              child: Text('Main WindmillPage'),
            ),
          );
        },
      ),
    );
  }
}
