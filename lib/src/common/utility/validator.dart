mixin Validator {
  static bool isValidMobile(String mobileNo) {
    return RegExp(r'^\+?(88)?01[3456789][0-9]{8}\b')
            .allMatches(mobileNo)
            .length ==
        1;
  }

  static String isValidMobileExact(String mobileNo) {
    var r = RegExp(r'^\+?(88)?01[3456789][0-9]{8}\b').allMatches(mobileNo);
    return r.length == 1 ? r.elementAt(0).group(0) ?? "" : "";
  }

  static bool isValidMobileNo(String mobileNo) {
    var r = RegExp(r'^\+?(88)?01[3456789][0-9]{8}\b').allMatches(mobileNo);
    return r.length == 1;
  }

  static bool isValidMobileNumber(String mobileNo) {
    return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
        .hasMatch(mobileNo);
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[-!#$%&'*+/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+/0-9=?A-Z^_a-z{|}~])*@[a-zA-Z](-?[a-zA-Z0-9])*(\.[a-zA-Z](-?[a-zA-Z0-9])*)+$")
        .hasMatch(email);
  }

  static bool isEmpty(String? value) {
    return value == null || value.isEmpty || value.trim().isEmpty;
  }

  static bool isValidLength(String value, int minLength, int maxLength) {
    return value.length >= minLength && value.length <= maxLength;
  }

  static bool validateBDMobileNumber(String value) {
    if (value.length == 10) {
      String pattern = r'(^([1][1-9][0-9]{8})$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    } else if (value.length == 11) {
      String pattern = r'(^([0][1][1-9][0-9]{8})$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    } else if (value.length == 14) {
      String pattern = r'(^(\+(8801)[1-9][0-9]{8})$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    }
    return false;
  }
  static String validateTitles(String? value) {
    if (value == null || value.isEmpty) {
      //'Password is required'
      return "Class title is required";
    }

    return "";
  }
  // Password validation function
  static String validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      //'Password is required'
      return "Passwords should be 8 characters must contain one upper case letter & one number**";
    }
    if (value.length < 8) {
      //'Password must be at least 8 characters long'
      return "Passwords should be 8 characters must contain one upper case letter & one number**";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      //'Password must contain at least one uppercase letter'
      return "Passwords should be 8 characters must contain one upper case letter & one number**";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      //'Password must contain at least one number'
      return "Passwords should be 8 characters must contain one upper case letter & one number**";
    }
    return "";
  }


}
