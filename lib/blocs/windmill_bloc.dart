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

class WindmillCreateNewInProgress extends WindmillState {}

class WindmillCreateNewSuccess extends WindmillState {
  final WindmillModel windmillModel;

  const WindmillCreateNewSuccess({@required this.windmillModel})
      : assert(windmillModel != null);

  @override
  List<Object> get props => [windmillModel];
}

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
                ? WindmillCreateNewInProgress()
                : WindmillLoadSuccess(
                    windmillModel: (accountBloc.state as AccountCreateSuccess)
                        .accountModel
                        .windmills
                        .first)
            : WindmillCreateNewInProgress()) {
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
        // TODO: power as const?
        WindmillModel windmillModel = new WindmillModel(
            name: event.name, location: event.location, power: 25);
        yield WindmillCreateNewSuccess(windmillModel: windmillModel);
      } catch (error) {
        yield WindmillCreateFailure(error: error.toString());
      }
    } else if (event is AccountUpdated) {
      if (event.accountModel.windmills.isEmpty) {
        yield WindmillCreateNewInProgress();
      } else {
        yield WindmillLoadSuccess(
            windmillModel: event.accountModel.windmills.first);
      }
    }
  }

  @override
  Future<void> close() {
    accountSubscription.cancel();
    return super.close();
  }
}
