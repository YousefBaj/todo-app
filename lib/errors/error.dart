import 'dart:io';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Error {
  authProblems errorType;

  void getError(e) {
    if (Platform.isAndroid) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = authProblems.UserNotFound;
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          errorType = authProblems.NetworkError;
          break;
        // ...
        default:
          print('Case ${e.message} is not jet implemented');
      }
    } else if (Platform.isIOS) {
      switch (e.code) {
        case 'Error 17011':
          errorType = authProblems.UserNotFound;
          break;
        case 'Error 17009':
          errorType = authProblems.PasswordNotValid;
          break;
        case 'Error 17020':
          errorType = authProblems.NetworkError;
          break;
        // ...
        default:
          print('Case ${e.message} is not jet implemented');
      }
    }
  }
}
