import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/account_bloc.dart';
import 'package:windmill/common/fade_animation.dart';

class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CreateAccountForm(),
    );
  }
}

class CreateAccountForm extends StatefulWidget {
  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onCreateButtonPressed() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      BlocProvider.of<AccountBloc>(context).add(
        AccountCreateButtonPressed(
          name: _nameController.text,
        ),
      );
    }

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountCreateFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/bg.png"))),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FadeAnimation(
                            2,
                            Center(
                              child: Text(
                                'Wind Farm',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 46),
                              ),
                            )),
                        SizedBox(
                          height: 30.0,
                        ),
                        FadeAnimation(
                            2,
                            CircleAvatar(
                              radius: 58.0,
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.add_location_alt_outlined,
                                  size: 50),
                            )),
                        SizedBox(
                          height: 30.0,
                        ),
                        FadeAnimation(
                            2,
                            TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: _nameController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.mode_edit,
                                    color: Colors.white,
                                  ),
                                  hintStyle: TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.black45,
                                  hintText: 'Your farm name'),
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                        Center(
                          child: state is AccountCreateInProgress
                              ? CircularProgressIndicator()
                              : null,
                        ),
                        FadeAnimation(
                            2,
                            RaisedButton(
                              onPressed: _onCreateButtonPressed,
                              child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text('Let\'s start!')),
                              color: Colors.blue,
                              textColor: Colors.black,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
