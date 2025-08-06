import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../calendar/model/student_model.dart';

class StudentProvider extends ChangeNotifier {
  final Map<String, StudentModel> _studentMap = {};

  Map<String, StudentModel> get studentMap => _studentMap;

  /// Fetch a student by ID if not already cached
  Future<StudentModel?> fetchStudentById(String studentId) async {
    if (_studentMap.containsKey(studentId)) {
      return _studentMap[studentId];
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();
      if (doc.exists) {
        final student = StudentModel.fromJson(doc.data() ?? {});
        _studentMap[studentId] = student;
        notifyListeners();
        return student;
      } else {
        debugPrint("Student not found for ID: $studentId");
      }
    } catch (e) {
      debugPrint("Error fetching student: $e");
    }
    return null;
  }

  /// Get student name by ID (from cache only)
  String getStudentName(String studentId) {
    return _studentMap[studentId]?.name ?? 'Unknown Student';
  }

  /// Preload multiple student IDs at once
  Future<void> preloadStudents(List<String> studentIds) async {
    for (final id in studentIds) {
      if (!_studentMap.containsKey(id)) {
        await fetchStudentById(id);
      }
    }
  }
}
