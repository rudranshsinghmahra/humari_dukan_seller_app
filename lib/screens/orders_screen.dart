import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../services/firebase_services.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  FirebaseServices firebaseServices = FirebaseServices();
  late AnimationController animationController;

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
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: firebaseServices.orders.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return spinkit;
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No Order(s) received till now...",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var timestamp = snapshot.data?.docs[index]['orderPlacedOn'];
                  var formattedDate = DateFormat('dd-MM-yyyy, hh:mm a')
                      .format(timestamp.toDate());
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4, top: 5, bottom: 2),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreen(
                                documentSnapshot: snapshot.data!.docs[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          shadowColor: Colors.pink,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order: ${snapshot.data?.docs[index]['orderNumber']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.network(
                                        "https://usapple.org/wp-content/uploads/2019/10/apple-empire.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Order Status:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            "${snapshot.data?.docs[index]['deliveryStatus']}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    RatingBar.builder(
                                      initialRating: snapshot.data?.docs[index]
                                          ['rating'],
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (_) {},
                                      itemSize: 20,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
