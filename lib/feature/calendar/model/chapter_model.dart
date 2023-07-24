// import 'package:cloud_firestore/cloud_firestore.dart';

class Chapter {
  String id;
  String name;
  String detail;
  String sheetId;
  String duration;
  List<ChapterPart> parts;

  Chapter({
    required this.id,
    required this.name,
    required this.detail,
    required this.sheetId,
    required this.duration,
    required this.parts,
  });

  // factory Chapter.fromSnapshot(
  //     QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return Chapter(
  //     id: snapshot.id,
  //     name: snapshot.get('name'),
  //     detail: snapshot.get('detail'),
  //     sheetId: snapshot.get('sheetId'),
  //     duration: snapshot.get('duration'),
  //     parts: [],
  //   );
  // }

  Chapter copyWith({
    String? name,
    String? detail,
    String? sheetId,
    String? duration,
  }) {
    return Chapter(
      id: id,
      name: name ?? this.name,
      detail: detail ?? this.detail,
      sheetId: sheetId ?? this.sheetId,
      duration: duration ?? this.duration,
      parts: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'detail': detail,
      'sheetId': sheetId,
      'duration': duration,
    };
  }
}

class ChapterPart {
  String id;
  String name;
  String? solvepadId; // Add this optional field

  ChapterPart({
    required this.id,
    required this.name,
    this.solvepadId, // Add this optional parameter
  });

  // factory ChapterPart.fromSnapshot(
  //     QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
  //   return ChapterPart(
  //     id: snapshot.id,
  //     name: snapshot.get('name'),
  //     solvepadId: snapshot.data().containsKey('solvepadId')
  //         ? snapshot.get('solvepadId')
  //         : null, // Check if the solvepadId field exists before getting its value
  //   );
  // }

  ChapterPart copyWith({String? name, String? solvepadId}) {
    return ChapterPart(
      id: id,
      name: name ?? this.name,
      solvepadId: solvepadId ?? this.solvepadId, // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'solvepadId': solvepadId, // Add this line
    };
  }
}
