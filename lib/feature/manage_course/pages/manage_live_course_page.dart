import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/authentication/service/auth_provider.dart';
import 'package:solve_tutor/constants/theme.dart';
import 'package:solve_tutor/feature/calendar/pages/my_course_live.dart';
import 'package:solve_tutor/feature/cheet/pages/my_document.dart';
import 'package:solve_tutor/feature/class/pages/class_list_page.dart';
import 'package:solve_tutor/feature/market_place/pages/my_course_vdo.dart';
import 'package:solve_tutor/feature/payment/pages/solve_fund.dart';
import 'package:solve_tutor/widgets/sizer.dart';

import '../../live_classroom/utils/responsive.dart';
import '../../maintenance/maintenance.dart';

class ManageLiveCoursePage extends StatefulWidget {
  const ManageLiveCoursePage({super.key});

  @override
  State<ManageLiveCoursePage> createState() => _ManageLiveCoursePageState();
}

class _ManageLiveCoursePageState extends State<ManageLiveCoursePage> {
  AuthProvider? auth;
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: Sizer(context).w,
          height: Sizer(context).h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    mobileCard(
                        'assets/images/calendar.png',
                        'Hybrid Solution',
                        'สร้างคอร์ส Hybrid ของคุณ',
                        true,
                        const MaintenancePage()),
                    mobileCard(
                        'assets/images/graph.png',
                        'การใช้งาน',
                        'ดูรายการค่าใช้จ่ายคอร์สสอนสด',
                        false,
                        const SolveFundPage()),
                  ],
                ),
                if (!Responsive.isMobile(context))
                  GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(30),
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    crossAxisCount: Sizer(context).w <= 600 ? 1 : 3,
                    children: <Widget>[
                      // gridCard(
                      //   context,
                      //   onTap: () {},
                      //   image: 'assets/images/graph1.png',
                      //   title: "ภาพรวม",
                      //   content:
                      //       "ดูคอร์สขายดี, รายได้ของคุณ, จำนวนนักเรียนในคอร์ส, รีวิว, และคะแนนของคุณ",
                      // ),
                      // gridCard(
                      //   context,
                      //   onTap: () async {
                      //     await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => MyCourseVDOPage(
                      //           tutorId: auth?.uid ?? "",
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   image: 'assets/images/menu_my_course.png',
                      //   title: "คอร์ส Marketplace",
                      // ),
                      gridCard(
                        context,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyCourseLivePage(
                                tutorId: auth?.uid ?? "",
                              ),
                            ),
                          );
                        },
                        image: 'assets/images/menu_my_course.png',
                        title: "สร้างคอร์สสอนสด",
                        content:
                            "เพิ่มชีท เพิ่มนักเรียน จัดตารางสอน และรอสอนได้เลย",
                      ),
                      // gridCard(
                      //   context,
                      //   onTap: () {},
                      //   image: 'assets/images/student1.png',
                      //   title: "จัดการนักเรียน",
                      //   content:
                      //       "แชร์คอร์ส จัดการรายชื่อ นักเรียนที่ลงทะเบียนในคอร์สของคุณ",
                      // ),
                      gridCard(
                        context,
                        onTap: () async {
                          var route = MaterialPageRoute(
                            builder: (context) => MyDocumentPage(
                              tutorId: auth?.uid ?? "",
                            ),
                          );
                          await Navigator.push(context, route);
                        },
                        image: 'assets/images/menu_create_sheet.png',
                        title: "สร้างชีท",
                        content: "อัปโหลดเอกสารประกอบการสอน",
                      ),
                      gridCard(
                        context,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MaintenancePage(),
                            ),
                          );
                        },
                        image: 'assets/images/menu_qa.png',
                        title: "ตอบคำถามนักเรียน",
                        content:
                            "อธิบายนักเรียนด้วยนวัตกรรม virtual one-on-one tutoring",
                      ),
                      // gridCard(
                      //   context,
                      //   onTap: () {
                      //     var route = MaterialPageRoute(
                      //         builder: (context) => const ClassListPage());
                      //     Navigator.push(context, route);
                      //   },
                      //   image: 'assets/images/menu_find_job.png',
                      //   title: "ค้นหางานสอน",
                      //   content:
                      //       "ประกาศของนักเรียนที่กำลังมองหาติวเตอร์ คุณสามารถเข้า ไปเสนอราคาเพื่อรับงานได้",
                      // ),
                    ],
                  ),
                if (Responsive.isMobile(context))
                  Row(
                    children: [
                      mobileCard(
                        'assets/images/menu_my_course.png',
                        'สร้างคอร์สสอนสด',
                        'เพิ่มชีท เพิ่มนักเรียน จัดตารางสอน และรอสอนได้เลย',
                        true,
                        MyCourseLivePage(
                          tutorId: auth?.uid ?? "",
                        ),
                      ),
                      mobileCard(
                        'assets/images/menu_create_sheet.png',
                        'สร้างชีท',
                        'อัปโหลดเอกสารประกอบการสอน',
                        false,
                        MyDocumentPage(
                          tutorId: auth?.uid ?? "",
                        ),
                      ),
                    ],
                  ),
                if (Responsive.isMobile(context))
                  Row(
                    children: [
                      mobileCard(
                          'assets/images/menu_qa.png',
                          'ตอบคำถามนักเรียน',
                          'อธิบายนักเรียนด้วยนวัตกรรม virtual one-on-one tutoring',
                          true,
                          const MaintenancePage()),
                    ],
                  ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileCard(
      String img, String title, String desc, bool left, Widget link) {
    return Expanded(
      child: Container(
        height: Responsive.isMobile(context) ? 200 : 230,
        margin: left
            ? const EdgeInsets.fromLTRB(30, 30, 15, 0)
            : const EdgeInsets.fromLTRB(15, 30, 30, 0),
        padding: Responsive.isMobile(context)
            ? const EdgeInsets.all(15)
            : const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => link,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: Image.asset(
                    img,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: appTextPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.isMobile(context) ? 14 : 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            desc,
                            style: TextStyle(
                              color: appTextSecondaryColor,
                              fontSize: Responsive.isMobile(context) ? 13 : 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gridCard(
    BuildContext context, {
    required Function()? onTap,
    required String image,
    required String title,
    String? content,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: appTextPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          content ?? "",
                          style: const TextStyle(
                            color: appTextSecondaryColor,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
