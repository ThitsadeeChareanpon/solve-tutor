await Alert.showOverlay(
          asyncFunction: () async {
            await courseController
                .updateCourseDestails(courseController.courseData);
          },
          context: context,
          loadingWidget: Alert.getOverlayScreen(),
        );
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'อัwเดทสำเร็จ');