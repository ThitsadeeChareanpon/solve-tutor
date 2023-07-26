import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'feature/calendar/constants/assets_manager.dart';

var db = FirebaseFirestore.instance;

class DbTest extends StatefulWidget {
  const DbTest({Key? key}) : super(key: key);

  @override
  State<DbTest> createState() => _DbTestState();
}

class _DbTestState extends State<DbTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.micMuteRed,
              width: 22,
            ),
            const Text('DB TEST PAGE'),
            ElevatedButton(
              onPressed: () {
                getCourse('1YA6uZ8TXwQqEw1layaA');
              },
              child: const Text('Action Button'),
            ),
          ],
        ),
      ),
    );
  }

  void getCourse(String documentId) async {
    final docRef = db.collection('course');
    try {
      final snapshot = await docRef.doc(documentId).get();
      if (snapshot.exists) {
        final courseData = snapshot.data()!;
        print(courseData);
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting course: $e');
    }
  }
}
