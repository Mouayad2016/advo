class ErrorException implements Exception {
  String cause;
  ErrorException(this.cause);
}

class WrongPass implements Exception {
  String cause;
  WrongPass(this.cause);
}

class NotFound implements Exception {
  String cause;
  NotFound(this.cause);
}

class ConflictException implements Exception {
  String cause;
  ConflictException(this.cause);
}
