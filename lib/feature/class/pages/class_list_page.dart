import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/authentication/models/user_model.dart';
import 'package:solve_tutor/authentication/service/auth_provider.dart';
import 'package:solve_tutor/constants/school_subject_constants.dart';
import 'package:solve_tutor/constants/theme.dart';
import 'package:solve_tutor/feature/class/models/class_model.dart';
import 'package:solve_tutor/feature/class/pages/create_class_page.dart';
import 'package:solve_tutor/feature/class/pages/find_class_page.dart';
import 'package:solve_tutor/feature/class/pages/my_class_page.dart';
import 'package:solve_tutor/feature/class/services/class_provider.dart';
import 'package:solve_tutor/widgets/date_time_format_util.dart';
import 'package:solve_tutor/widgets/sizer.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({super.key});

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage>
    with TickerProviderStateMixin {
  AuthProvider? authProvider;
  ClassProvider? classProvider;

  // String selectClass = "วิชาคณิตศาสตร์";
  int count = 0;
  final txtSearchName = TextEditingController();
  String selectClass = SchoolSubjectConstants.schoolSubjectFilterList.first;
  String selectClassLevel = SchoolSubjectConstants.schoolClassLevel.first;
  String startDate = "";
  String startTime = "";

  late final TabController _tabController;

  Size size = const Size(0, 0);

  List<ClassModel> searchClassList = [];
  int currentPage = 0;
  int totalPage = 0;
  int limit = 4;
  int showCount = 2;

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      classProvider = Provider.of<ClassProvider>(context, listen: false);
      selectClassLevel = authProvider!.user!.classLevel == ""
          ? SchoolSubjectConstants.schoolClassLevel.first
          : authProvider!.user!.classLevel!;
      initSearchClassList();
      setState(() {});
    });
  }

  initSearchClassList() async {
    searchClassList = [];
    var getItemList = await classProvider?.firestore
        .collection(authProvider?.user!.role! == "tutor"
            ? 'class_study'
            : 'class_tutor')
        .get();

    var filterList = onFilter(getItemList!.docs);
    if (filterList.isNotEmpty) {
      if (filterList.length > limit) {
        totalPage = filterList.length ~/ limit;
        if (filterList.length % limit != 0) {
          totalPage = (filterList.length ~/ limit) + 1;
        }
      } else {
        totalPage = 1;
      }
      for (int i = 0; i < filterList.length; i++) {
        if (i >= ((limit * (currentPage + 1)) - limit) &&
            i <= (limit * (currentPage + 1) - 1)) {
          ClassModel item = ClassModel.fromJson(filterList[i].data());
          searchClassList.add(item);
        }
      }
    }
    setState(() {});
  }

  // List<QueryDocumentSnapshot<Map<String, dynamic>>> getDataFilter(
  //     List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList) {
  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> result = [];
  //   List<QueryDocumentSnapshot<Map<String, dynamic>>> getItemList = [];
  //   getItemList = onFilter(dataList);
  //   // result = getItemList;

  //   // print('aaaa: ${getItemList.length}');
  //   for (int i = 0; i < getItemList.length; i++) {
  //     // print('xxx: ${getItemList[i]["id"]}');
  //     // i>=(limit-currentPage)-limit && i<=(limit*currentPage-1)
  //     if (i >= ((2 * 2) - 2) && i <= (2 * 2 - 1)) {
  //       // print('object: $i');
  //       result.add(getItemList[i]);
  //     }
  //   }

  //   return result;
  // }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> onFilter(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> result = [];
    if (selectClass != "ทั้งหมด") {
      result = dataList.where((el1) {
        var cData = el1.data();
        // DateTime sDate = DateTime.parse(cData["startDate"]);
        return cData["schoolSubject"] == selectClass &&
            cData["name"].toString().toLowerCase().startsWith(
                  txtSearchName.text.toLowerCase(),
                ) &&
            (cData["classLevel"] == selectClassLevel) &&
            (cData["isBooking"] == null || cData["isBooking"] == 0);
      }).toList();
    } else {
      result = dataList.where((el1) {
        var cData = el1.data();
        return cData["name"].toString().toLowerCase().startsWith(
                  txtSearchName.text.toLowerCase(),
                ) &&
            (cData["classLevel"] == selectClassLevel) &&
            (cData["isBooking"] == null || cData["isBooking"] == 0);
      }).toList();
    }

    if (startDate != "") {
      result = result.where((el1) {
        var cData = el1.data();
        String d1 = DateTime.parse(startDate).date();
        String d2 = DateTime.parse(cData["startDate"]).date();
        return d1.compareTo(d2) == 0 || d1.compareTo(d2) == -1;
      }).toList();
    }
    if (startTime != "") {
      result = result.where((el1) {
        var cData = el1.data();
        String d1 = startTime;
        String d2 = DateFormat(
          'HH:mm',
        ).format(DateTime.parse(cData["startTime"]));
        return d1.compareTo(d2) == 0 || d1.compareTo(d2) == -1;
      }).toList();
    }
    // result.sort((a,b)=> a);
    return result;
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    showCount = Sizer(context).w <= 850 ? 1 : 2;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              // color: Colors.red,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: greyColor,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                unselectedLabelColor: greyColor,
                labelStyle: GoogleFonts.kanit(
                  fontSize: 18,
                ),
                indicatorWeight: 2,
                tabs: <Widget>[
                  Tab(
                    text: authProvider?.user!.getRoleType() == RoleType.tutor
                        ? 'ค้นหานักเรียน'
                        : 'ประกาศของนักเรียน',

                    // icon: Icon(Icons.account_circle),
                  ),
                  const Tab(
                    text: "ประกาศของฉัน",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  // tabView1(),
                  // tabView2(),
                  FindClassPage(),
                  MyClassPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'ค้นหางานสอน',
        style: TextStyle(color: appTextPrimaryColor),
      ),
      // elevation: 0,
      // centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.black,
        ),
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateClassPage()),
                  );
                },
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(
                      Icons.add,
                      size: 16,
                    ),
                    Text(
                      authProvider?.user!.getRoleType() == RoleType.tutor
                          ? 'สร้างประกาศหานักเรียน'
                          : 'สร้างประกาศหางานสอน',
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
