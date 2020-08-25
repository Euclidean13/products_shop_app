import 'dart:async';

import 'package:products_shop_app/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

// with for mixins

class LoginBloc with Validators {
  // final _emailController = StreamController<String>.broadcast();
  // final _passwordController = StreamController<String>.broadcast();
  // ** RxDart do not understran StreamControllers, so we use BehaviourSubject
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Return Stream data
  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  // RxDart to combine the above streams
  Stream<bool> get fromValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

  // Insert values on stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // GET and SET to get the last value of the streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  // Close stream when it is no needed
  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
