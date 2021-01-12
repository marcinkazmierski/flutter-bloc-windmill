
import 'package:flutter_test/flutter_test.dart';
import 'package:windmill/blocs/account_bloc.dart';

void main() {
  AccountBloc accountBloc;

  setUp(() {
    accountBloc = AccountBloc();
  });

  tearDown(() {
    accountBloc?.close();
  });

  test('initial state is correct', () {
    expect(accountBloc.state, AccountInitialState());
  });

  group('AccountCreateFailure', () {
    test(
        'emits AccountCreateFailureState when name is empty',
            () {
          final expectedResponse = [
            AccountCreateInProgressState(),
            AccountCreateFailureState(error: "Exception: Empty name!"),
          ];

          expectLater(
            accountBloc,
            emitsInOrder(expectedResponse),
          );

          accountBloc.add(AccountCreateButtonPressedEvent(
            name: '',
          ));
        });
  });
}
