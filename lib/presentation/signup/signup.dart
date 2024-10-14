import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schoolui/bloc/signin/auth_event.dart';
import 'package:schoolui/presentation/school/school_homepage.dart';
import '../../bloc/signin/auth_bloc.dart';
import '../../bloc/signin/auth_state.dart';
import '../signin/widgets/bazier_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

final nameController = TextEditingController();
final emailController = TextEditingController();
final addressController = TextEditingController();
final phoneController = TextEditingController();

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  String? successMessage; // To store the success message

  Widget _entryField(TextEditingController controller, String title,
      {bool isPassword = false,
      TextInputType keyboardType = TextInputType.text}) {
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
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $title';
              }
              return null;
            },
          ),
        ],
      ),
    );
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
              "School App - Sign Up",
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
            SignUpRequested(
              name: nameController.text,
              email: emailController.text,
              address: addressController.text,
              phone: phoneController.text,
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
          'Sign Up',
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
          _entryField(nameController, "Name"),
          _entryField(emailController, "Email",
              keyboardType: TextInputType.emailAddress),
          _entryField(addressController, "Address"),
          _entryField(phoneController, "Phone Number",
              keyboardType: TextInputType.phone),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() {
            successMessage =
                "Your request to register as a school is sent successfully and is under review. Check your email for the status.";
            errorMessage = null; // Clear error message on success
          });
        } else if (state is SignupError) {
          setState(() {
            errorMessage = state.error;
            successMessage = null; // Clear success message on error
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      const SizedBox(height: 20),
                      if (successMessage != null)
                        Text(
                          successMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      const SizedBox(height: 20),
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
                              SizedBox(height: height * .1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
