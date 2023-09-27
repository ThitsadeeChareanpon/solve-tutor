import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_colors.dart';
import 'package:solve_tutor/feature/calendar/constants/custom_styles.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_controller.dart';
import 'package:solve_tutor/feature/calendar/controller/document_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/document_model.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_snackbar.dart';
import 'package:solve_tutor/feature/calendar/widgets/dropdown.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/sizebox.dart';
import 'package:solve_tutor/feature/cheet/pages/my_document.dart';

class UpdateDocumentForm extends StatefulWidget {
  UpdateDocumentForm({
    super.key,
    required this.documentId,
    required this.tutorId,
    required this.documentActionType,
  });
  final DocumentActionType documentActionType;
  String documentId;
  final String tutorId;

  @override
  State<UpdateDocumentForm> createState() => _UpdateDocumentFormState();
}

class _UpdateDocumentFormState extends State<UpdateDocumentForm> {
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
    getInit();
  }

  getInit() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.documentActionType == DocumentActionType.create) {
        await Alert.showOverlay(
          loadingWidget: Alert.getOverlayScreen(),
          asyncFunction: () async {
            try {
              documentController.document.data = Data.fromJson({
                "document_name": "",
                "tutor_id": widget.tutorId,
                "doc_files": [],
              });

              String id = await documentController
                  .createDocumentId(documentController.document.data ?? Data());
              documentController.document.id = id;
              await documentController.getDocumentByDocumentId(
                  tutorId: documentController.document.data?.tutorId ?? '',
                  documentId: documentController.document.id ?? '');
              await documentController.setRequestData();
            } catch (e) {
              rethrow;
            }
          },
          context: context,
        );
      } else {
        await Alert.showOverlay(
          loadingWidget: Alert.getOverlayScreen(),
          asyncFunction: () async {
            try {
              await documentController.getDocumentByDocumentId(
                  tutorId: widget.tutorId, documentId: widget.documentId);

              if (documentController.document.data?.documentName?.isNotEmpty ==
                  true) {
                documentController.documentName.text =
                    documentController.document.data?.documentName ?? '';
              }
            } catch (e) {
              rethrow;
            }
          },
          context: context,
        );
      }
    });
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
              onTap: () async {
                if (widget.documentActionType == DocumentActionType.create) {
                  await Alert.showOverlay(
                      loadingWidget: Alert.getOverlayScreen(),
                      asyncFunction: () async {
                        try {
                          await documentController.deleteDocument(
                              tutorId:
                                  documentController.document.data?.tutorId ??
                                      '',
                              documentId: documentController.document.id ?? '');
                        } catch (e) {
                          rethrow;
                        }
                      },
                      context: context);
                }
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: CustomColors.gray878787,
              )),
          title: Text(
            document.document.data?.documentName ?? 'ไม่ได้ตั้งชื่อเอกสาร',
            style: CustomStyles.bold22Black363636,
          ),
        ),
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async => _willPop(),
          child: Column(
            children: [
              Expanded(
                  child: (document.isLoading)
                      ? const Center(child: CircularProgressIndicator())
                      : document.document.data == null
                          ? const Text("Can't load data")
                          : SingleChildScrollView(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_util.isTablet()) ...[
                                        _isTablet(context)
                                      ] else ...[
                                        _isMobile(context)
                                      ],
                                      S.h(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _foundDocs(document
                                              .document.data?.updateTime),
                                          _buttonChooseFormGallery(context)
                                        ],
                                      ),
                                      S.h(10),
                                      Expanded(
                                        child: ReorderableBuilder(
                                          scrollController: _scrollController,
                                          automaticScrollExtent: 1.0,
                                          onReorder: (List<OrderUpdateEntity>
                                              orderUpdateEntities) {
                                            for (final orderUpdateEntity
                                                in orderUpdateEntities) {
                                              final fruit = document
                                                  .document.data?.docFiles
                                                  ?.removeAt(orderUpdateEntity
                                                      .oldIndex);
                                              document.document.data?.docFiles
                                                  ?.insert(
                                                      orderUpdateEntity
                                                          .newIndex,
                                                      fruit ?? '');
                                            }
                                          },
                                          builder: (children) {
                                            return GridView(
                                              key: _gridViewKey,
                                              controller: _scrollController,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 2 / 3,
                                                mainAxisSpacing: 4,
                                                crossAxisSpacing: 8,
                                              ),
                                              children: children,
                                            );
                                          },
                                          children: List.generate(
                                            document.document.data?.docFiles
                                                    ?.length ??
                                                0,
                                            (index) => GestureDetector(
                                              key: Key((index + 1).toString()),
                                              onTap: () {},
                                              child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    // image: DecorationImage(
                                                    //   image: NetworkImage(
                                                    //     document.document.data
                                                    //             ?.docFiles
                                                    //             ?.elementAt(
                                                    //                 index) ??
                                                    //         '',
                                                    //   ),
                                                    //   fit: BoxFit.fill,
                                                    // ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                        width: double.infinity,
                                                        fit: BoxFit.fitHeight,
                                                        imageUrl: document
                                                                .document
                                                                .data
                                                                ?.docFiles
                                                                ?.elementAt(
                                                                    index) ??
                                                            '',
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _hoverMove(),
                                                          _deleteImage(
                                                              document
                                                                          .document
                                                                          .data
                                                                          ?.docFiles?[
                                                                      index] ??
                                                                  '',
                                                              index),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      S.h(150),
                                    ],
                                  ),
                                ),
                              ),
                            )),
              _tabBottom(),
            ],
          ),
        ),
      );
    });
  }

  Widget _hoverMove() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.grey)),
            child: Image.asset(
              'assets/images/arrow_move.png',
              height: 20,
            )), //Button icon
      ),
    );
  }

  Widget _deleteImage(String imageUrl, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          final String fileId = _getIdImage(imageUrl);
          await Alert.showOverlay(
            loadingWidget: Alert.getOverlayScreen(),
            asyncFunction: () async {
              try {
                await documentController.deleteFileById(
                    documentId: documentController.document.id ?? '',
                    fileId: fileId,
                    tutorId: documentController.document.data?.tutorId ?? '');
                documentController.removeImage(index);
                print(documentController.document.toJson());
              } catch (e) {
                rethrow;
              }
            },
            context: context,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.grey)),
          child: const Icon(
            Icons.delete,
            size: 20,
            color: Colors.grey,
          ),
        ), //Button icon
      ),
    );
  }

  Widget _buttonChooseFormGallery(context) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.add,
        size: 20,
        color: Colors.white,
      ), //Button icon
      label: PopupMenuButton(
        child: Text(
          "เพิ่มรูปจากอุปกรณ์",
          style: CustomStyles.med14White,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                value: '0',
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_select_pdf.png',
                      scale: 2,
                    ),
                    S.w(10),
                    Text(
                      'เลือก PDF',
                      style: CustomStyles.med16Green,
                    ),
                  ],
                )),
            PopupMenuItem(
                value: '1',
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/icon_select_image.png',
                      scale: 2,
                    ),
                    S.w(10),
                    Text(
                      'เลือกรูปภาพ',
                      style: CustomStyles.med16Green,
                    ),
                  ],
                ))
          ];
        },
        onSelected: (String value) async {
          if (value == '0') {
            await Alert.showOverlay(
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                try {
                  await documentController.openFiles(
                      context: context,
                      documentId: documentController.document.id ?? '',
                      tutorId: documentController.document.data?.tutorId ?? '');
                } catch (e) {
                  rethrow;
                }
              },
              context: context,
            );
          }
          if (value == '1') {
            await Alert.showOverlay(
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                await documentController.openGallery(
                    context: context,
                    documentId: documentController.document.id ?? '',
                    tutorId: documentController.document.data?.tutorId ?? '');
              },
              context: context,
            );
          }
        },
      ),
      onPressed: () async {},
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.green20B153,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _buttonSaveDocument() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.check_circle_rounded,
          size: 20,
          color: Colors.white,
        ), //Button icon
        label: Text(
          "บันทึก",
          style: CustomStyles.med14White,
        ),
        onPressed: () async {},
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.green20B153,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _foundDocs(DateTime? dt) {
    return Text(
      'แก้ไขล่าสุด: ${FormatDate.dt(dt)}',
      style: CustomStyles.blod16gray878787,
    );
  }

  Widget _textfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: TextFormField(
          controller: documentController.documentName,
          decoration: InputDecoration(
            labelText: 'ชื่อเอกสาร',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            suffix: Text('${documentController.documentName.text.length}/70'),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(70),
          ],
          onChanged: (value) {
            setState(() {});
            documentController.document.data?.documentName = value;
          },
        ),
      ),
    );
  }

  Widget _dropdownCategory() {
    return Row(
      children: [
        Expanded(
          child: Dropdown(
            selectedValue: documentController.document.data?.levelId,
            items: courseController.levels,
            hintText: '-- เลือกหมวดหมู่ --',
            onChanged: (value) {
              documentController.setLevel(value ?? '');
            },
          ),
        ),
        S.w(5),
        Expanded(
          child: Dropdown(
            selectedValue: documentController.document.data?.subjectId,
            items: courseController.subjects,
            hintText: '-- ระดับชั้นปีการศึกษา --',
            onChanged: (value) {
              documentController.setSubject(value ?? '');
            },
          ),
        ),
      ],
    );
  }

  Widget _isMobile(BuildContext context) {
    return Column(
      children: [
        _textfield(),
        _dropdownCategory(),
      ],
    );
  }

  Widget _isTablet(BuildContext context) {
    return Column(
      children: [
        _textfield(),
        _dropdownCategory(),
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
        children: [_backtoDocument(), _saveDocument()],
      ),
    );
  }

  Widget _backtoDocument() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.arrow_back,
          size: 20, color: CustomColors.black363636),
      label: Text(
        "ย้อนกลับ",
        style: CustomStyles.med14greenPrimary,
      ),
      onPressed: () async {
        if (widget.documentActionType == DocumentActionType.create) {
          await Alert.showOverlay(
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                try {
                  await documentController.deleteDocument(
                      tutorId: documentController.document.data?.tutorId ?? '',
                      documentId: documentController.document.id ?? '');
                } catch (e) {
                  rethrow;
                }
              },
              context: context);
        }
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  Widget _saveDocument() {
    return ElevatedButton(
      onPressed: () async {
        var requestError = false;
        await Alert.showOverlay(
            loadingWidget: Alert.getOverlayScreen(),
            asyncFunction: () async {
              try {
                // print(documentController.document.toJson());
                await documentController
                    .updateDocumentDetails(documentController.document);
              } catch (e) {
                requestError = true;
              }
            },
            context: context);
        if (requestError) {
        } else {
          showSnackBar(context, 'บันทึกสำเร็จ');
          var reload = true;
          Navigator.of(context).pop(reload);
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
          "บันทึก",
          style: CustomStyles.med14White,
        ),
      ),
    );
  }

  String _getIdImage(String imageUrl) {
    var urlToken = imageUrl.split('?');
    var url = urlToken[0].split('/');
    var filePath = url[url.length - 1].replaceAll("%2F", "/");
    var name = filePath.split('/');
    return name[name.length - 1];
  }

  Future<bool> _willPop() async {
    // if (widget.documentActionType == DocumentActionType.create) {
    await Alert.showOverlay(
        loadingWidget: Alert.getOverlayScreen(),
        asyncFunction: () async {
          try {
            await documentController.deleteDocument(
                tutorId: widget.tutorId, documentId: widget.documentId);
          } catch (e) {
            rethrow;
          }
        },
        context: context);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    return false;
  }
}
