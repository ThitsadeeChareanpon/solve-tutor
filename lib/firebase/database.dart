import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserById(userId) async {
    final collectionRef = db.collection('users');
    try {
      final snapshot = await collectionRef.doc(userId).get();
      if (snapshot.exists) {
        final user = snapshot.data()!;
        return user;
      } else {
        log('Document does not exist');
        return {};
      }
    } catch (e) {
      log('Error getting course: $e');
      return {};
    }
  }

  Future<String> writeSolvepadData(String texUrl, String audioUrl) async {
    final collectionRef = db.collection('solvepad');
    DocumentReference documentReference = await collectionRef.add({
      'solvepad': texUrl,
      'voice': audioUrl,
    });
    return documentReference.id;
  }

  Future<List<String>> uploadMarketSolvepad(String fileName) async {
    final storageRef = FirebaseStorage.instance.ref();
    final tempDirectory = await getTemporaryDirectory();

    final solvepadRef = storageRef.child("flutter/$fileName.txt");
    String localSolvepadPath = '${tempDirectory.path}/solvepad.txt';
    File solvepadFile = File(localSolvepadPath);

    final voiceRef = storageRef.child("flutter/$fileName.mp4");
    String localVoicePath = '${tempDirectory.path}/tau_file.mp4';
    File voiceFile = File(localVoicePath);

    if (!(await solvepadFile.exists() || await voiceFile.exists())) {
      throw Exception("File does not exist");
    } else {
      log('file exist');
    }
    final voiceFileSize = await voiceFile.length();
    if (voiceFileSize == 0) {
      throw Exception("File is empty");
    } else {
      log('fileSize $voiceFileSize');
    }

    TaskSnapshot solvepadSnapshot = await solvepadRef.putFile(solvepadFile);
    final String solvepadUrl = await solvepadSnapshot.ref.getDownloadURL();
    TaskSnapshot voiceSnapshot = await voiceRef.putFile(voiceFile);
    final String voiceUrl = await voiceSnapshot.ref.getDownloadURL();

    return [solvepadUrl, voiceUrl];
  }
}
