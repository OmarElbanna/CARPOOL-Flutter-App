import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool passwordVisible = true;
  late User user;
  List<Map> data = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

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
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text('User data not found');
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                  SizedBox(
                  height: 140,
                  child: Image.asset("images/download.png"),
                ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: userData['firstName'],
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
                      initialValue: userData['lastName'],
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
                      initialValue: userData['phone'],
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
                    // TextFormField(
                    //   initialValue: "123456789",
                    //   keyboardType: TextInputType.visiblePassword,
                    //   obscureText: passwordVisible,
                    //   decoration: InputDecoration(
                    //     label: const Text("Password"),
                    //     suffixIcon: IconButton(
                    //         onPressed: () {
                    //           setState(() {
                    //             passwordVisible = !passwordVisible;
                    //           });
                    //         },
                    //         icon: Icon(passwordVisible
                    //             ? Icons.visibility
                    //             : Icons.visibility_off)),
                    //     border: const OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(5))),
                    //   ),
                    // ),
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
                );
              },
            )),
      ),
    );
  }
}
