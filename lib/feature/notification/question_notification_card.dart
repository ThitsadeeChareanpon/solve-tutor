import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/notification/student_provider.dart';

import '../calendar/controller/create_course_controller.dart';
import '../calendar/model/course_model.dart';
import '../calendar/model/student_model.dart';

class QuestionNotificationCard extends StatelessWidget {
  final String questionText;
  final String studentId;
  final String courseId;
  final int lesson;

  const QuestionNotificationCard({
    super.key,
    required this.questionText,
    required this.studentId,
    required this.courseId,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = Provider.of<CourseController>(context, listen: false);
    final studentProvider = Provider.of<StudentProvider>(context);

    return FutureBuilder<CourseModel>(
      future: courseController.getCourseById(courseId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }

        final course = snapshot.data!;
        final courseImage = course.thumbnailUrl ?? 'assets/images/default_course.png';
        final courseName = course.courseName ?? 'Unknown Course';
        final lessonNumber = lesson ?? '1';

        return FutureBuilder<StudentModel?>(
          future: studentProvider.fetchStudentById(studentId),
          builder: (context, studentSnapshot) {
            final studentName = studentSnapshot.data?.name ?? 'Unknown Student';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  // Left: Image
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(courseImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Right: Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questionText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text("Student: $studentName"),
                          Text("Course: $courseName"),
                          Text("Lesson: $lessonNumber"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }
}
