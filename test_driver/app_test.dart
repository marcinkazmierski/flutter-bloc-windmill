// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Create account', () {
    final accountNameInput = find.byValueKey('accountNameInput');
    final createAccountButton = find.byValueKey('createAccountButton');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts with empty input', () async {
      expect(await driver.getText(accountNameInput), "");
    });

    test('try create with empty input', () async {
      await driver.tap(createAccountButton);
      await driver.waitFor(find.text('Exception: Empty name!'),
          timeout: Duration(seconds: 3));
    });

    test('create account', () async {
      await driver.tap(accountNameInput);
      await driver.enterText("My account name");
      await driver.tap(createAccountButton);
      await driver.waitFor(find.text('Create new windmill'),
          timeout: Duration(seconds: 5));
    });
  });
}
