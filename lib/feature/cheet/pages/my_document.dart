import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/controller/document_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/model/document_model.dart';
import 'package:solve_tutor/feature/calendar/pages/update_document.dart';
import 'package:solve_tutor/feature/calendar/widgets/dropdown.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:solve_tutor/feature/cheet/pages/document_details.dart';

enum DocumentActionType { create, update }

class MyDocumentPage extends StatefulWidget {
  const MyDocumentPage({Key? key, required this.tutorId}) : super(key: key);
  final String tutorId;
  @override
  State<MyDocumentPage> createState() => _MyDocumentPageState();
}

class _MyDocumentPageState extends State<MyDocumentPage> {
  final util = UtilityHelper();

  var documentController = DocumentController();
  var courseController = CourseController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var selectedLevel = '';
  var selectedSubject = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    courseController = Provider.of<CourseController>(context, listen: false);
    documentController =
        Provider.of<DocumentController>(context, listen: false);
    documentController.isLoading = true;
    await courseController.getLevels();
    await courseController.getSubjects();
    await documentController.getDocumentListByTutorId(widget.tutorId);
  }

  @override
  void dispose() {
    super.dispose();
    courseController.courseFilter.clear();
  }

  @override
  Widget build(BuildContext context) {
    documentController.initialize();
    return Consumer<DocumentController>(builder: (_, document, child) {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: CustomColors.gray878787,
              )),
          centerTitle: false,
          backgroundColor: CustomColors.whitePrimary,
          elevation: 6,
          title: Text(
            CustomStrings.myDocument,
            style: CustomStyles.bold22Black363636,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateDocumentForm(
                          documentActionType: DocumentActionType.create,
                          documentId: '',
                          tutorId: widget.tutorId),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: CustomColors.green20B153,
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          S.w(10),
                          const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          S.w(10),
                          Text(
                            "สร้างเอกสาร",
                            style: CustomStyles.bold14White,
                          ),
                          S.w(10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              await document.getDocumentListByTutorId(widget.tutorId);
              Future.delayed(const Duration(seconds: 1));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                S.h(10.0),
                _textFieldFilter(),
                S.h(10.0),
                _rowDropdown(),
                Expanded(
                  child: document.isLoading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('กำลังโหลด...'),
                            ),
                          ],
                        )
                      : listMyCourse(
                          document.documentListFilter.isNotEmpty
                              ? document.documentListFilter
                              : document.documentList,
                        ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _textFieldFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 60,
        child: TextFormField(
          controller: documentController.keywordTextEditingController,
          textAlignVertical: TextAlignVertical.bottom,
          maxLines: 1,
          style: CustomStyles.med14Black363636,
          decoration: InputDecoration(
            hintText: 'ค้นหา...',
            hintStyle: CustomStyles.med14Black363636
                .copyWith(color: CustomColors.grayCFCFCF),
            // isDense: trueasas,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            prefixIcon: Icon(Icons.search),

            // suffix: Text('${controller.courseNames.length}/70'),
          ),
          onChanged: (value) {
            // controller.lastChangeName(courseName.text);
          },
        ),
      ),
    );
  }

  Widget _rowDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Dropdown(
                  selectedValue: selectedSubject,
                  items: courseController.subjects,
                  hintText: '-- เลือกหมวดหมู่ --',
                  onChanged: (value) {
                    selectedSubject = value ?? '';
                    documentController.documentListFilter = documentController
                        .documentList
                        .where((element) => element.data?.subjectId == value)
                        .toList();

                    setState(() {});
                  },
                ),
              ),
              S.w(5),
              Expanded(
                child: Dropdown(
                  selectedValue: selectedLevel,
                  items: courseController.levels,
                  hintText: '-- ระดับชั้นปีการศึกษา --',
                  onChanged: (value) {
                    selectedLevel = value ?? '';
                    debugPrint(value);
                    documentController.documentListFilter = documentController
                        .documentList
                        .where((element) => element.data?.levelId == value)
                        .toList();

                    setState(() {});
                    // debugPrint('${_courseFilter?.toList().toString()}');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget listMyCourse(List<DocumentModel> documents) {
    return Consumer<DocumentController>(builder: (_, document, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 8,
            children: List.generate(documents.length, (index) {
              return GestureDetector(
                onTap: () async {
                  // print(documents[index].id);
                  if (documents[index].id != null) {
                    final reload = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentDetails(
                            documentId: documents[index].id ?? '',
                            tutorId: widget.tutorId),
                      ),
                    );

                    if (reload != null && reload == true) {
                      await document.getDocumentListByTutorId(widget.tutorId);
                      Future.delayed(const Duration(seconds: 1));
                    }
                  }
                },
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Column(
                    children: [
                      (documents[index].data?.docFiles?.isEmpty == true)
                          ? Expanded(
                              child: Image.asset(
                                ImageAssets.emptyCourse,
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Expanded(
                              child: Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: CachedNetworkImage(
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                                imageUrl:
                                    documents[index].data?.docFiles?.first ??
                                        '',
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          documents[index].data?.documentName ?? '',
                          style: CustomStyles.med14Gray878787
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
      );
    });
  }

  Widget _isTablet(CourseModel course) {
    return Row(
      children: [
        _studentView(),
        _border(),
        // _lastUpdate(course.createTime!),
        Expanded(child: Container()),
        _videoView(course.lessons?.length ?? 0),
        _documentView(course.document?.data?.docFiles?.length ?? 0),
      ],
    );
  }

  Widget _isMobile(CourseModel course) {
    return Column(
      children: [
        Row(
          children: [
            _studentView(),
            _border(),
            _lastUpdate(course.createTime!),
          ],
        ),
        S.h(10),
        Row(
          children: [
            _videoView(course.lessons?.length ?? 0),
            S.w(10),
            _documentView(course.document?.data?.docFiles?.length ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _border() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 16,
      width: 1,
      color: Colors.grey,
    );
  }

  Widget _studentView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/student_view.png',
          scale: 4,
        ),
        S.w(5),
        Text(
          '5',
          style: CustomStyles.med12gray878787,
        ),
      ],
    );
  }

  Widget _lastUpdate(DateTime dt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'แก้ไขล่าสุด: ${FormatDate.dayOnly(dt)} ',
          style: CustomStyles.med12gray878787,
        ),
      ],
    );
  }

  Widget _videoView(int views) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/videocam.png',
          scale: 4,
        ),
        S.w(5),
        Text(
          '$views',
          style: CustomStyles.med12gray878787,
        ),
      ],
    );
  }

  Widget _documentView(int views) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/doc.png',
          scale: 4,
        ),
        S.w(5),
        Text(
          '$views',
          style: CustomStyles.med12gray878787,
        ),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(
    BuildContext context, {
    required String title,
    required String path,
    required Widget page,
  }) {
    return PopupMenuItem(
      enabled: false,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Row(
          children: [
            Image.asset(
              path,
              scale: 3,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: CustomStyles.bold14Green,
            ),
          ],
        ),
      ),
    );
  }
}
