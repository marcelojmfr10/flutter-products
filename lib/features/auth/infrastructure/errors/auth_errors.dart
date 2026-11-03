class WrongCredentials implements Exception {}

class ConnectionTimeout implements Exception {}

class InvalidToken implements Exception {}

class CustomError implements Exception {
  final String message;
  final bool loggedRequired;
  // final int errorCode;

  new(this.message, [this.loggedRequired = false]);
}
