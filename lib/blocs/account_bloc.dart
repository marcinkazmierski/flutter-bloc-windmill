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

class AccountInitial extends AccountState {}

class AccountCreateInProgress extends AccountState {}

class AccountCreateSuccess extends AccountState {
  final AccountModel accountModel;

  const AccountCreateSuccess({@required this.accountModel})
      : assert(accountModel != null);

  @override
  List<Object> get props => [accountModel];
}

class AccountCreateFailure extends AccountState {
  final String error;

  const AccountCreateFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'AccountCreateFailure { error: $error }';
}

///EVENT
abstract class AccountEvent extends Equatable {
  const AccountEvent();
}

class AccountCreateButtonPressed extends AccountEvent {
  final String name;

  const AccountCreateButtonPressed({
    @required this.name,
  });

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'AccountCreateButtonPressed { name: $name }';
}

/// BLOC
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    print(">>>> AccountBloc START");
  }

  //initial state

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is AccountCreateButtonPressed) {
      yield AccountCreateInProgress();
      try {
        await Future.delayed(Duration(seconds: 3));
        // TODO: save via repository!
        AccountModel accountModel = new AccountModel(
            name: event.name, windmills: new List<WindmillModel>());
        yield AccountCreateSuccess(accountModel: accountModel);
      } catch (error) {
        yield AccountCreateFailure(error: error.toString());
      }
    }
  }
}
