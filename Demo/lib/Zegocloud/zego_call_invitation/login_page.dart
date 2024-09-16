import 'package:flutter/material.dart';
import '../../GlobalComponents/GlobalPackages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController password = TextEditingController();

  final TextEditingController email = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: null,
      ),
      body: LoadingHolder(
        isLoading: isLoading,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //const TopBar(title: "Login", upperTitle: ''),
            const SizedBox(
              height: 60,
            ),
            Image.asset(
              'assets/Splash.png',
              width: 50,
              height: 50,
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome to  zegocloud call service. let\'s communicate each other ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Log Into Your Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'example@domain.com',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.text,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '********',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                PageRouteNames.sighup,
                              );
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () async {
                            final isValid = formKey.currentState?.validate();
                            if (isValid != true ||
                                email.text.isEmpty ||
                                password.text.isEmpty) {
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });

                            final bool result = await FirebaseService.login(
                              email: email.text,
                              password: password.text,
                            );

                            if (result && mounted) {
                              login(
                                userID: FirebaseService.currentUser.name,
                                userName:
                                    'user_${FirebaseService.currentUser.name}',
                              ).then((value) {
                                onUserLogin();
                              });

                              Navigator.pushNamed(
                                context,
                                PageRouteNames.home,
                              );
                              // (route) => false,
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Something went wrong!"),
                                  ),
                                );
                              }
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: const Text(
                            'LogIn',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
