import 'dart:async';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:windmill/blocs/account_bloc.dart';
import 'package:windmill/models/account_model.dart';
import 'package:windmill/models/windmill_model.dart';

///STATE
abstract class WindmillState extends Equatable {
  const WindmillState();

  @override
  List<Object> get props => [];
}

class WindmillLoadSuccess extends WindmillState {
  final WindmillModel windmillModel;

  const WindmillLoadSuccess({@required this.windmillModel})
      : assert(windmillModel != null);

  @override
  List<Object> get props => [windmillModel];
}

class WindmillCreateNewInitial extends WindmillState {}

class WindmillCreateNewInProgress extends WindmillState {}

class WindmillCreateFailure extends WindmillState {
  final String error;

  const WindmillCreateFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'WindmillCreateFailure { error: $error }';
}

///EVENT
abstract class WindmillEvent extends Equatable {
  const WindmillEvent();
}

class WindmillCreateInitialize extends WindmillEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'WindmillCreateInitialize {}';
}

class WindmillCreateButtonPressed extends WindmillEvent {
  final String name;
  final String location;

  const WindmillCreateButtonPressed({
    @required this.name,
    @required this.location,
  });

  @override
  List<Object> get props => [name, location];

  @override
  String toString() =>
      'WindmillCreateButtonPressed { name: $name, location: $location }';
}

class AccountUpdated extends WindmillEvent {
  final AccountModel accountModel;

  const AccountUpdated({@required this.accountModel});

  @override
  List<Object> get props => [accountModel];

  @override
  String toString() => 'AccountUpdated { accountModel: $accountModel }';
}

class ChangeActiveWindmill extends WindmillEvent {
  final WindmillModel windmillModel;

  const ChangeActiveWindmill({@required this.windmillModel});

  @override
  List<Object> get props => [windmillModel];

  @override
  String toString() => 'ChangeActiveWindmill { accountModel: $windmillModel }';
}

/// BLOC
class WindmillBloc extends Bloc<WindmillEvent, WindmillState> {
  final AccountBloc accountBloc;
  StreamSubscription accountSubscription;

  WindmillBloc({@required this.accountBloc})
      : assert(accountBloc != null),
        super(accountBloc.state is AccountCreateSuccess
            ? (accountBloc.state as AccountCreateSuccess)
                    .accountModel
                    .windmills
                    .isEmpty
                ? WindmillCreateNewInitial()
                : WindmillLoadSuccess(
                    windmillModel: (accountBloc.state as AccountCreateSuccess)
                        .accountModel
                        .windmills
                        .first)
            : WindmillCreateNewInitial()) {
    print(">>>> WindmillBloc START");
    accountSubscription = accountBloc.listen((state) {
      if (state is AccountCreateSuccess) {
        add(AccountUpdated(accountModel: state.accountModel));
      }
    });
  }

  @override
  Stream<WindmillState> mapEventToState(WindmillEvent event) async* {
    if (event is WindmillCreateButtonPressed) {
      yield WindmillCreateNewInProgress();
      try {
        if (event.name.isEmpty) {
          throw Exception("Empty name!");
        }
        if (event.location.isEmpty) {
          throw Exception("Empty location!");
        }
        await Future.delayed(Duration(seconds: 3));
        // TODO: power as const?
        WindmillModel windmillModel = new WindmillModel(
            name: event.name, location: event.location, power: 25);
        //todo: add to accountModel!
        yield WindmillLoadSuccess(windmillModel: windmillModel);
      } catch (error) {
        yield WindmillCreateFailure(error: error.toString());
      }
    } else if (event is AccountUpdated) {
      if (event.accountModel.windmills.isEmpty) {
        yield WindmillCreateNewInitial();
      } else {
        yield WindmillLoadSuccess(
            windmillModel: event.accountModel.windmills.first);
      }
    } else if (event is WindmillCreateInitialize) {
      yield WindmillCreateNewInitial();
    } else if (event is ChangeActiveWindmill) {
      yield WindmillLoadSuccess(windmillModel: event.windmillModel);
    }
  }

  @override
  Future<void> close() {
    accountSubscription.cancel();
    return super.close();
  }
}
