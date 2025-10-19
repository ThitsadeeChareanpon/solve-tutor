import 'package:flutter/material.dart';

/// Placeholder page used when VideoSDK features are disabled.
class TutorLiveClassroom extends StatelessWidget {
  final String meetingId, userId, token, displayName, courseId;
  final bool micEnabled, camEnabled, chatEnabled, isHost, isMock;
  final int startTime;

  const TutorLiveClassroom({
    Key? key,
    required this.meetingId,
    required this.userId,
    required this.token,
    required this.displayName,
    required this.isHost,
    required this.courseId,
    required this.startTime,
    this.micEnabled = true,
    this.camEnabled = false,
    this.chatEnabled = false,
    this.isMock = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Classroom Disabled'),
      ),
      body: const Center(
        child: Text('Video conferencing is currently disabled.'),
      ),
    );
  }
}
