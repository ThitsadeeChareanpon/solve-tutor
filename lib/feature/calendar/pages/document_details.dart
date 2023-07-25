import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/controller/document_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/pages/preview_document.dart';
import 'package:solve_tutor/feature/calendar/pages/update_document.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:solve_tutor/feature/cheet/pages/alert_other.dart';
import 'package:solve_tutor/feature/cheet/pages/my_document.dart';

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({
    super.key,
    required this.documentId,
    required this.tutorId,
  });

  final String documentId;
  final String tutorId;
  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  var documentController = DocumentController();
  var courseController = CourseController();
  final _util = UtilityHelper();
  String? choice;

  int a = 10;
  Widget buildItem(String text) {
    return Card(
      key: ValueKey(text),
      child: Text(text),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    documentController =
        Provider.of<DocumentController>(context, listen: false);
    courseController = Provider.of<CourseController>(context, listen: false);
    documentController.getDocumentByDocumentId(
        tutorId: widget.tutorId, documentId: widget.documentId);
  }

  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentController>(builder: (_, document, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: CustomColors.white,
          elevation: 6,
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: CustomColors.gray878787,
              )),
          title: Text(
            'ดูเอกสาร',
            style: CustomStyles.bold22Black363636,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: (document.isLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : document.document.data == null
                      ? const Center(child: Text("Can't load data"))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_util.isTablet()) ...[
                                  _isTablet(context)
                                ] else ...[
                                  _isMobile(context)
                                ],
                                const Divider(),
                                S.h(10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _textPageLength(),
                                    _foundDocs(
                                        document.document.data?.updateTime),
                                  ],
                                ),
                                S.h(10),
                                Expanded(
                                  child: ReorderableBuilder(
                                    enableDraggable: false,
                                    scrollController: _scrollController,
                                    automaticScrollExtent: 1.0,
                                    onReorder: (List<OrderUpdateEntity>
                                        orderUpdateEntities) {
                                      for (final orderUpdateEntity
                                          in orderUpdateEntities) {
                                        final fruit = document
                                            .document.data?.docFiles
                                            ?.removeAt(
                                                orderUpdateEntity.oldIndex);
                                        document.document.data?.docFiles
                                            ?.insert(orderUpdateEntity.newIndex,
                                                fruit ?? '');
                                      }
                                    },
                                    builder: (children) {
                                      return GridView.count(
                                        key: _gridViewKey,
                                        crossAxisCount: 3,
                                        childAspectRatio: 2 / 3,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 8,
                                        children: children,
                                      );
                                    },
                                    children: List.generate(
                                      document.document.data?.docFiles
                                              ?.length ??
                                          0,
                                      (index) => GestureDetector(
                                        key: Key((index + 1).toString()),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewDocument(
                                                        images: document
                                                                .document
                                                                .data
                                                                ?.docFiles ??
                                                            [],
                                                        name: document
                                                                .document
                                                                .data
                                                                ?.documentName ??
                                                            '',
                                                        index: index,
                                                      )));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: CachedNetworkImage(
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            imageUrl: document
                                                    .document.data?.docFiles
                                                    ?.elementAt(index) ??
                                                '',
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                S.h(10),
                              ],
                            ),
                          ),
                        ),
            ),
            _tabBottom()
          ],
        ),
      );
    });
  }

  Widget _textPageLength() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '${documentController.document.data?.docFiles?.length} หน้า',
        style: CustomStyles.bold18Black363636,
      ),
    );
  }

  Widget _foundDocs(DateTime? dt) {
    return Text(
      'แก้ไขล่าสุด: ${FormatDate.dt(dt)}',
      style:
          CustomStyles.blod16gray878787.copyWith(fontWeight: FontWeight.normal),
    );
  }

  Widget _text() {
    String documentName = '';
    documentName = documentController.document.data?.documentName ?? '';
    if (documentName.isEmpty == true) {
      documentName = 'ยังไม่ได้ตั้งชื่อ';
    } else {}
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        documentName,
        textAlign: TextAlign.left,
        style: CustomStyles.bold22Black363636,
      ),
    );
  }

  Widget _category() {
    var filterLevelId = courseController.levels
        .where((e) => e.id == documentController.document.data?.levelId)
        .toList();
    var filterSubjectId = courseController.subjects
        .where((e) => e.id == documentController.document.data?.subjectId)
        .toList();

    return Row(
      children: [
        _tagType('${filterLevelId.isEmpty ? '' : filterLevelId.first.name}'),
        S.w(5),
        _tagType(
            '${filterSubjectId.isEmpty ? '' : filterSubjectId.first.name}'),
      ],
    );
  }

  Widget _isMobile(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _text(),
        S.w(5),
        _category(),
      ],
    );
  }

  Widget _isTablet(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _text(),
        _category(),
      ],
    );
  }

  Widget _tabBottom() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: double.infinity,
        color: CustomColors.grayE5E6E9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_deleteDocument(context), _editDocument()],
        ));
  }

  Widget _deleteDocument(context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.add,
          size: 20, color: CustomColors.redB71C1C), //Button icon
      label: Text(
        "ลบเอกสาร",
        style: CustomStyles.med14redB71C1C,
      ),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (context) => AlertDeleteDocument(onTap: () async {
            bool requestError = false;
            await Alert.showOverlay(
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                try {
                  await documentController.deleteDocument(
                      tutorId: widget.tutorId, documentId: widget.documentId);
                } catch (e) {
                  requestError = true;
                }
              },
              context: context,
            );
            if (requestError) {
            } else {
              var reload = true;
              Navigator.of(context).pop(reload);
            }
          }),
        );
        if (result != null && result == true) {
          Navigator.of(context).pop(result);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _editDocument() {
    return ElevatedButton(
      onPressed: () async {
        if (widget.documentId.isNotEmpty) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateDocumentForm(
                  documentActionType: DocumentActionType.update,
                  documentId: widget.documentId,
                  tutorId: widget.tutorId),
            ),
          );
          if (result != null && result) {
            documentController.getDocumentByDocumentId(
                tutorId: widget.tutorId, documentId: widget.documentId);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.greenPrimary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "แก้ไข",
          style: CustomStyles.med14White,
        ),
      ),
    );
  }

  Widget _tagType(String tag) {
    if (tag.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: CustomColors.grayF3F3F3,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        tag,
        style: CustomStyles.med12gray878787.copyWith(color: Colors.black),
      ),
    );
  }
}
