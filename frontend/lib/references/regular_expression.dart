void main() {
  String text = 'abc123!@#';

// r means raw string which ignore special escape characters
  RegExp numberRegex = RegExp(r'[0-9]');
  RegExp alphabetRegex = RegExp(r'[a-zA-Z]');
  RegExp specialSymbolRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  bool hasNumber = numberRegex.hasMatch(text);
  bool hasAlphabet = alphabetRegex.hasMatch(text);
  bool hasSpecialSymbol = specialSymbolRegex.hasMatch(text);

  print('Has Number: $hasNumber'); // Output: true
  print('Has Alphabet: $hasAlphabet'); // Output: true
  print('Has Special Symbol: $hasSpecialSymbol');
  // Output: true


// counting number in a string
  String text2 = 'abc123xyz456';

  RegExp regex = RegExp(r'\d');
  Iterable<Match> matches = regex.allMatches(text2);

  int count = matches.length;
  print('Count: $count'); // Output: 6 (number of digits in the string)
}
