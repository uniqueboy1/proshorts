import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/views/widgets/profile/profile_input.dart';


class SetupProfileOptions extends StatelessWidget {
  SetupProfileOptions({Key? key}) : super(key: key);

  final TextEditingController name = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController bio = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup your profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const CircleAvatar(
                    radius: 50,
                    child: Text("Choose a photo", 
                    textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Enter your name",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please enter your name",
                    suffixIcon: Icons.person_2_rounded,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: userName,
                    labelText: "Enter username",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please enter the username",
                    suffixIcon: Icons.person_2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Describe about your channel",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please add a bio",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: const [
                    Text("Add social media link",)

                  ]
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Enter youtube URL",
                    emptyMessage: "Please enter youtube URL",
                    suffixIcon: FontAwesomeIcons.youtube,
                    suffixIconColor: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Enter instagram URL",
                    emptyMessage: "Please enter instagram URL",
                    suffixIcon: FontAwesomeIcons.instagram,
                    suffixIconColor: Colors.red,

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Enter twitter URL",
                    emptyMessage: "Please enter twitter URL",
                    suffixIcon: FontAwesomeIcons.twitter,
                    suffixIconColor: Colors.blue,
 
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: name,
                    labelText: "Enter your portfolio URL",
                    emptyMessage: "Please enter your portfolio URL",

                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.validate();
                      },
                      child: const Text("Setup Profile"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
