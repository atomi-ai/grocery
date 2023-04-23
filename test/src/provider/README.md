# How to run a mock unit test in flutter

### create a _test.dart file and add @GenerateMocks into it
### Run command to generate mock file:
```shell
flutter pub run build_runner build --delete-conflicting-outputs
```
The command will generate `user_provier_test.mocks.dart` file.

### Run the test
```shell
flutter test test/src/provider/user_provider_test.dart
```