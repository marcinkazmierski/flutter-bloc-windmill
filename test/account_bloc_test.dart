
import 'package:flutter_test/flutter_test.dart';
import 'package:windmill/blocs/account_bloc.dart';


/**
 * TODO
 * https://blog.codemagic.io/flutter-unit-testing-bloc-with-codemagic/
 * https://resocoder.com/2019/11/29/bloc-test-tutorial-easier-way-to-test-blocs-in-dart-flutter/
 */
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
