import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: const Text(
          "My Account",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  "https://media.licdn.com/dms/image/C4D03AQGFxldRxlU7Xg/profile-displayphoto-shrink_800_800/0/1661131775382?e=2147483647&v=beta&t=A1qCwqFSQT44KYD1geoOwQlFP9uqBBNMUgN4NFtyfK8",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: "Omar",
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  label: Text("First Name"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                initialValue: "Elbanna",
                decoration: const InputDecoration(
                  label: Text("Last Name"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                initialValue: "01011553108",
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.phone),
                  label: Text("Phone Number"),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: "123456789",
                keyboardType: TextInputType.visiblePassword,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  label: const Text("Password"),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      icon: Icon(passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {},

                color: Colors.blueGrey[700],
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
