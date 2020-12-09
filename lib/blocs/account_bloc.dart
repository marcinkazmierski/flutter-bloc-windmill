import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:windmill/models/account_model.dart';
import 'package:windmill/models/windmill_model.dart';

///STATE
abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitialState extends AccountState {}

class AccountCreateInProgressState extends AccountState {}

class AccountCreateSuccessState extends AccountState {
  final AccountModel accountModel;

  const AccountCreateSuccessState({@required this.accountModel})
      : assert(accountModel != null);

  @override
  List<Object> get props => [accountModel];
}

class AccountCreateFailureState extends AccountState {
  final String error;

  const AccountCreateFailureState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'AccountCreateFailureState { error: $error }';
}

///EVENT
abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class AccountCreateButtonPressedEvent extends AccountEvent {
  final String name;

  const AccountCreateButtonPressedEvent({
    @required this.name,
  });

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'AccountCreateButtonPressedEvent { name: $name }';
}

/// BLOC
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitialState()) {
    print(">>>> AccountBloc START");
  }

  //initial state

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is AccountCreateButtonPressedEvent) {
      yield AccountCreateInProgressState();
      try {
        if (event.name.isEmpty) {
          throw Exception("Empty name!");
        }
        await Future.delayed(Duration(seconds: 3));
        // TODO: save via repository!
        AccountModel accountModel = new AccountModel(
            name: event.name, windmills: new List<WindmillModel>());
        yield AccountCreateSuccessState(accountModel: accountModel);
      } catch (error) {
        yield AccountCreateFailureState(error: error.toString());
      }
    }
  }
}
