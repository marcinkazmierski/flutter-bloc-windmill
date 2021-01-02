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

class WindmillLoadSuccessState extends WindmillState {
  final WindmillModel windmillModel;

  const WindmillLoadSuccessState({@required this.windmillModel})
      : assert(windmillModel != null);

  @override
  List<Object> get props => [windmillModel];
}

class WindmillCreateNewInitialState extends WindmillState {}

class WindmillCreateNewInProgressState extends WindmillState {}

class WindmillCreateFailureState extends WindmillState {
  final String error;

  const WindmillCreateFailureState({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'WindmillCreateFailureState { error: $error }';
}

///EVENT
abstract class WindmillEvent extends Equatable {
  const WindmillEvent();
}

class WindmillCreateInitializeEvent extends WindmillEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'WindmillCreateInitializeEvent {}';
}

class WindmillCreateButtonPressedEvent extends WindmillEvent {
  final String name;
  final String location;

  const WindmillCreateButtonPressedEvent({
    @required this.name,
    @required this.location,
  });

  @override
  List<Object> get props => [name, location];

  @override
  String toString() =>
      'WindmillCreateButtonPressedEvent { name: $name, location: $location }';
}

class WindmillDeleteButtonPressedEvent extends WindmillEvent {
  final WindmillModel windmillModel;

  const WindmillDeleteButtonPressedEvent({
    @required this.windmillModel,
  });

  @override
  List<Object> get props => [windmillModel];

  @override
  String toString() =>
      'WindmillDeleteButtonPressedEvent { windmillModel: $windmillModel }';
}

class AccountUpdatedEvent extends WindmillEvent {
  final AccountModel accountModel;

  const AccountUpdatedEvent({@required this.accountModel});

  @override
  List<Object> get props => [accountModel];

  @override
  String toString() => 'AccountUpdatedEvent { accountModel: $accountModel }';
}

class ChangeActiveWindmillEvent extends WindmillEvent {
  final WindmillModel windmillModel;

  const ChangeActiveWindmillEvent({@required this.windmillModel});

  @override
  List<Object> get props => [windmillModel];

  @override
  String toString() =>
      'ChangeActiveWindmillEvent { accountModel: $windmillModel }';
}

/// BLOC
class WindmillBloc extends Bloc<WindmillEvent, WindmillState> {
  final AccountBloc accountBloc;
  StreamSubscription accountSubscription;

  WindmillBloc({@required this.accountBloc})
      : assert(accountBloc != null),
        super(accountBloc.state is AccountCreateSuccessState
            ? (accountBloc.state as AccountCreateSuccessState)
                    .accountModel
                    .windmills
                    .isEmpty
                ? WindmillCreateNewInitialState()
                : WindmillLoadSuccessState(
                    windmillModel:
                        (accountBloc.state as AccountCreateSuccessState)
                            .accountModel
                            .windmills
                            .first)
            : WindmillCreateNewInitialState()) {
    print(">>>> WindmillBloc START");
    accountSubscription = accountBloc.listen((state) {
      if (state is AccountCreateSuccessState) {
        add(AccountUpdatedEvent(accountModel: state.accountModel));
      }
    });
  }

  @override
  Stream<WindmillState> mapEventToState(WindmillEvent event) async* {
    if (event is WindmillCreateButtonPressedEvent) {
      yield WindmillCreateNewInProgressState();
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
        if (this.accountBloc.state is AccountCreateSuccessState) {
          (this.accountBloc.state as AccountCreateSuccessState)
              .accountModel
              .windmills
              .add(windmillModel);
        }
        yield WindmillLoadSuccessState(windmillModel: windmillModel);
      } catch (error) {
        yield WindmillCreateFailureState(error: error.toString());
      }
    } else if (event is AccountUpdatedEvent) {
      if (event.accountModel.windmills.isEmpty) {
        yield WindmillCreateNewInitialState();
      } else {
        yield WindmillLoadSuccessState(
            windmillModel: event.accountModel.windmills.first);
      }
    } else if (event is WindmillCreateInitializeEvent) {
      yield WindmillCreateNewInitialState();
    } else if (event is ChangeActiveWindmillEvent) {
      yield WindmillLoadSuccessState(windmillModel: event.windmillModel);
    }
  }

  @override
  Future<void> close() {
    accountSubscription.cancel();
    return super.close();
  }
}
