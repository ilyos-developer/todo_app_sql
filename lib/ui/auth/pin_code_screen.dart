import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_task/bloc/auth/auth_bloc.dart';
import 'package:todo_task/ui/home/home_screen.dart';

class PinCode extends StatefulWidget {
  @override
  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> with SingleTickerProviderStateMixin {
  bool isIncorrect = true;

  final storage = new FlutterSecureStorage();

  var currentPinCode;

  late Size _screenSize;
  late int _currentDigit;
  int? _firstDigit;
  int? _secondDigit;
  int? _thirdDigit;
  int? _fourthDigit;

  @override
  void initState() {
    super.initState();
    readStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  readStorage() async {
    currentPinCode = await storage.read(key: "code");
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _screenSize.width,
          height: _screenSize.height,
          child: _getInputPart,
        ),
      ),
    );
  }

  // Return label
  get _getLabel {
    return Center(
      child: Text(
        "Введите PIN-код",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25.0),
      ),
    );
  }

  get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 50),
        _getLabel,
        Spacer(),
        _getInputField,
        isIncorrect
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 35, top: 25),
                child: Text(
                  "Неверный код (код: 1234)",
                  style: TextStyle(
                    color: Color(0xFFEF2D1D),
                  ),
                ),
              ),
        Spacer(),
        _getOtpKeyboard
      ],
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return Container(
      height: _screenSize.height * 0.38,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "1",
                    onPressed: () {
                      _setCurrentDigit(1);
                    }),
                _otpKeyboardInputButton(
                    label: "2",
                    onPressed: () {
                      _setCurrentDigit(2);
                    }),
                _otpKeyboardInputButton(
                    label: "3",
                    onPressed: () {
                      _setCurrentDigit(3);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "4",
                    onPressed: () {
                      _setCurrentDigit(4);
                    }),
                _otpKeyboardInputButton(
                    label: "5",
                    onPressed: () {
                      _setCurrentDigit(5);
                    }),
                _otpKeyboardInputButton(
                    label: "6",
                    onPressed: () {
                      _setCurrentDigit(6);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "7",
                    onPressed: () {
                      _setCurrentDigit(7);
                    }),
                _otpKeyboardInputButton(
                    label: "8",
                    onPressed: () {
                      _setCurrentDigit(8);
                    }),
                _otpKeyboardInputButton(
                    label: "9",
                    onPressed: () {
                      _setCurrentDigit(9);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      BiometricsCheckEvent(),
                    );
                  },
                  icon: Icon(
                    Icons.fingerprint,
                    size: 45,
                    color: Colors.green,
                  ),
                ),
                _otpKeyboardInputButton(
                    label: "0",
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                _otpKeyboardActionButton(
                  label: Icon(
                    Icons.backspace,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_fourthDigit != null) {
                        _fourthDigit = null;
                      } else if (_thirdDigit != null) {
                        _thirdDigit = null;
                      } else if (_secondDigit != null) {
                        _secondDigit = null;
                      } else if (_firstDigit != null) {
                        _firstDigit = null;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int? digit) {
    return Container(
      width: 51.0,
      height: 72.0,
      alignment: Alignment.center,
      child: Text(
        digit != null ? "*" : "-",
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isIncorrect ? Color(0xFFD6D9E0) : Color(0xFFEF2D1D),
        ),
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton(
      {required String label, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _otpKeyboardActionButton(
      {required Widget label, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

        String code = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString();

        print("line 308: Введенный код: $code");

        if (code == currentPinCode) {
          print("verification successful");
          isIncorrect = true;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          setState(() {
            print("код не совпадает");
            isIncorrect = false;
          });
        }
      }
    });
  }

  void clearOtp() {
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
}
