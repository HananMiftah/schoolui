import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/signin/auth_event.dart';
import 'package:schoolui/presentation/parent/parent_homepage.dart';
import 'package:schoolui/presentation/school/school_homepage.dart';
import 'package:schoolui/presentation/signup/signup.dart';
import 'package:schoolui/presentation/teacher/teacher_homepage.dart';
import '../../bloc/signin/auth_bloc.dart';
import '../../bloc/signin/auth_state.dart';
import 'widgets/bazier_container.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage; // To store the error message
  

  
  Widget _entryField(TextEditingController controller, String title,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Are you a school?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()));
              },
              child: const Text(
                'Sign up',
                style: TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return const Center(
      child: Column(
        children: [
          Image(
            image: AssetImage('assets/icon.png'),
            height: 90,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "School App",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          BlocProvider.of<AuthBloc>(context).add(
            LoginRequested(
              email: emailController.text,
              password: passwordController.text,
            ),
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: const Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(emailController, "Email"),
          _entryField(passwordController, "Password", isPassword: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Clear the text fields after successful sign-in
          emailController.clear();
          passwordController.clear();

          if(state.authResponse.user!.role == "SCHOOL"){
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          }
          else if (state.authResponse.user!.role == "TEACHER"){
             Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TeacherHomepage()));
          }
          else{
           Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ParentHomepage()));}
          
        } else if (state is AuthError) {
          setState(() {
            errorMessage = state.error;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SizedBox(
            height: height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: height * .2),
                      _title(),
                      const SizedBox(height: 40),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _emailPasswordWidget(),
                              const SizedBox(height: 20),
                              if (errorMessage != null)
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              const SizedBox(height: 10),
                              _submitButton(),
                              _loginAccountLabel(),
                            ],
                          ),
                        ),
                      ),
                      if (state is AuthLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
