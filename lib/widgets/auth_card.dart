import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

enum Mode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Mode _mode = Mode.Login;
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_mode == Mode.Login) {
      _authenticateUser();
    } else {
      _registerUser();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchMode() {
    if (_mode == Mode.Login) {
      setState(() {
        _mode = Mode.Signup;
      });
    } else {
      setState(() {
        _mode = Mode.Login;
      });
    }
  }

  void _registerUser() async {
    try {
      final response =
          await Provider.of<AuthProvider>(context, listen: false).registerUser(
        _authData['email'],
        _authData['password'],
      );
      if (response['error'] == null) {
        return;
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(response['error']['message']),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
              'Something went wrong. Please check you internet connection and try again later!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  void _authenticateUser() async {
    try {
      final response = await Provider.of<AuthProvider>(context, listen: false)
          .authenticateUser(
        _authData['email'],
        _authData['password'],
      );
      if (response['error'] == null) {
        return;
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: const Text('Your email or password is incorrect'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
              'Something went wrong. Please check you internet connection and try again later!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Container(
        height: _mode == Mode.Signup ? 300 : 250,
        constraints: BoxConstraints(
          minHeight: _mode == Mode.Signup ? 310 : 260,
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'E-Mail',
                    icon: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Icon(
                        Icons.lock,
                      ),
                    ),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty || value.length < 6) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_mode == Mode.Signup)
                  TextFormField(
                    enabled: _mode == Mode.Signup,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      icon: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Icon(
                          Icons.lock,
                        ),
                      ),
                    ),
                    obscureText: true,
                    validator: _mode == Mode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(_mode == Mode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      ' ${_mode == Mode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
