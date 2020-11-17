import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/models/account_model.dart';
import 'package:windmill/common/fade_animation.dart';

class CreateWindmillPage extends StatelessWidget {
  final AccountModel accountModel;

  const CreateWindmillPage({@required this.accountModel})
      : assert(accountModel != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateWindmillForm(
        accountModel: this.accountModel,
      ),
    );
  }
}

class CreateWindmillForm extends StatefulWidget {
  final AccountModel accountModel;

  const CreateWindmillForm({@required this.accountModel})
      : assert(accountModel != null);

  @override
  State<CreateWindmillForm> createState() => _CreateWindmillFormState();
}

class _CreateWindmillFormState extends State<CreateWindmillForm> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onCreateButtonPressed() {
      BlocProvider.of<WindmillBloc>(context).add(
        WindmillCreateButtonPressed(
            name: _nameController.text, location: _locationController.text),
      );
    }

    return BlocBuilder<WindmillBloc, WindmillState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FadeAnimation(
                      2,
                      Center(
                        child: Text(
                          'Create new windmill',
                          style: TextStyle(color: Colors.black, fontSize: 32),
                        ),
                      )),
                  SizedBox(
                    height: 30.0,
                  ),
                  FadeAnimation(
                    2,
                    SizedBox(
                      height: 100.0,
                      child: Image.asset('assets/images/windmill.png'),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FadeAnimation(
                      2,
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _nameController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mode_edit,
                              color: Colors.black87,
                            ),
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: 'Windmill name'),
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  FadeAnimation(
                      2,
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: _locationController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mode_edit,
                              color: Colors.black87,
                            ),
                            hintStyle: TextStyle(color: Colors.black54),
                            hintText: 'Windmill location'),
                      )),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(child: null //CircularProgressIndicator()
                      ),
                  FadeAnimation(
                      2,
                      RaisedButton(
                        onPressed: _onCreateButtonPressed,
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('Create')),
                        color: Colors.blue,
                        textColor: Colors.black,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
