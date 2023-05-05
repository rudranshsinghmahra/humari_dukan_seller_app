import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:humari_dukan_seller_app/screens/orders_screen.dart';

import '../services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  FirebaseServices services = FirebaseServices();
  late AnimationController animationController;
  String userName = "";
  String userEmail = "";

  final List<String> items = [
    'Messages',
    'Notification',
    'Accounts Details',
    'My Purchases',
    'Settings',
    ""
  ];

  final List<double>? customItemsHeights = [
    60,
    60,
    60,
    60,
    60,
    30,
  ];
  String? selectedValue;
  bool appBarMenuPressed = false;
  User? user = FirebaseAuth.instance.currentUser;

  getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await services.users
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) => {
                userName = documentSnapshot['name'],
                userEmail = documentSnapshot['email'],
              })
          .catchError((e) {
        print(e);
      });
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SpinKitFadingCube spinkit = SpinKitFadingCube(
      color: Colors.pink,
      size: 50.0,
      controller: animationController,
    );
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Theme.of(context).primaryColor),
        child: SafeArea(
            child: FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: spinkit,
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xffff4a85),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 10, top: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.account_circle_rounded,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          userName.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Center(
                                  child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  items: items
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Row(
                                              children: [
                                                item == "Messages"
                                                    ? const Icon(
                                                        Icons.message,
                                                        color: Colors.white,
                                                      )
                                                    : (item == "Notification"
                                                        ? const Icon(
                                                            Icons.notifications,
                                                            color: Colors.white,
                                                          )
                                                        : (item ==
                                                                "Accounts Details"
                                                            ? const Icon(
                                                                Icons
                                                                    .account_box_sharp,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : item ==
                                                                    "My Purchases"
                                                                ? const Icon(
                                                                    Icons
                                                                        .shopping_cart,
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : (item ==
                                                                        "Settings"
                                                                    ? const Icon(
                                                                        Icons
                                                                            .settings,
                                                                        color: Colors
                                                                            .white,
                                                                      )
                                                                    : Container()))),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  item,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )
                                      .toList(),
                                  value: selectedValue,
                                  customItemsHeights: customItemsHeights,
                                  dropdownDecoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30)),
                                    color: Color(0xffff4a85),
                                  ),
                                  isExpanded: true,
                                  dropdownElevation: 0,
                                  iconEnabledColor: const Color(0xffff4a85),
                                  iconDisabledColor: const Color(0xffff4a85),
                                  dropdownMaxHeight: 350,
                                  buttonWidth:
                                      MediaQuery.of(context).size.width * 0.65,
                                  dropdownWidth:
                                      MediaQuery.of(context).size.width,
                                  onChanged: (item) {
                                    item == "Messages"
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()))
                                        : (item == "Notification"
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()))
                                            : (item == "Accounts Details"
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeScreen()))
                                                : item == "My Purchases"
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeScreen()))
                                                    : (item == "Settings"
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomeScreen()))
                                                        : Container())));
                                  },
                                  onMenuStateChange: (isOpen) {
                                    if (isOpen) {
                                      appBarMenuPressed = true;
                                    } else {
                                      appBarMenuPressed = false;
                                    }
                                  },
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 70,
                        ),
                        child: OrdersScreen(),
                      ),
                    ],
                  );
                })),
      ),
    );
  }
}
