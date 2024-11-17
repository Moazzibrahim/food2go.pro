import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';


class NotificationsScreens extends StatelessWidget {
  const NotificationsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Order Received',
        'message': 'You have received a new order. Please check.',
        'timestamp': '2 mins ago',
      },
      {
        'title': 'Payment Successful',
        'message': 'Your payment was successful! Thank you for your purchase.',
        'timestamp': '5 mins ago',
      },
      {
        'title': 'Product Restocked',
        'message': 'The item you requested is back in stock!',
        'timestamp': '1 hour ago',
      },
      {
        'title': 'Account Verified',
        'message': 'Your account has been successfully verified.',
        'timestamp': 'Yesterday',
      },
    ];


Future<List<String>> fetchAllFcmTokens() async {
  try {
    // Query the Firestore 'users' collection
    final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Extract FCM tokens from each document
    final fcmTokens = querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          if (data.containsKey('fcm_token')) {
            return data['fcm_token'] as String;
          }
          return null;
        })
        .whereType<String>() // Filter out any null values
        .toList();

        log('$fcmTokens');

    return fcmTokens;
  } catch (e) {
    log('Error fetching FCM tokens: $e');
    return []; // Return an empty list on error
  }
}


    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          ElevatedButton(onPressed: (){
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (ctx)=> const PushNotificationScreen())
            // );
            fetchAllFcmTokens();
          }, child: const Icon(Icons.notification_add_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Dismissible(
              key: Key(notification['title']!),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Handle dismiss action (e.g., remove from list)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${notification['title']} dismissed')),
                );
              },
              background: Container(
                color: maincolor,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blueAccent),
                  title: Text(
                    notification['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(notification['message']!),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        notification['timestamp']!,
                        style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
