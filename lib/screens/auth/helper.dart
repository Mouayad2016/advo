bool isValidEmail(String email) {
  // Perform email validation here (e.g., using regular expressions)
  // Return true if the email is valid, false otherwise
  // Example validation using regular expression:
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}
