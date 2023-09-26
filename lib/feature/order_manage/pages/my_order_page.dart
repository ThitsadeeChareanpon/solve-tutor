import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/constants/theme.dart';
import 'package:solve_tutor/feature/order_manage/controller/my_order_controller.dart';
import 'package:solve_tutor/feature/order_manage/model/order_class_model.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  MyOrderController? controller;

  @override
  void initState() {
    controller = MyOrderController(context);
    controller!.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<MyOrderController>(builder: (context, con, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "รายการคำสั่งซื้อ",
              style: TextStyle(
                color: appTextPrimaryColor,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "รายการคำสั่งซื้อ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "ทั้งหมด ${con.orderList.length}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  titleBarWidget(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: con.orderList.length,
                    itemBuilder: (context, index) {
                      OrderCourseModel only = con.orderList[index];
                      return FutureBuilder(
                          future: con.getCourseInfo(only.classId ?? ""),
                          builder: (context, snap) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          only.refId ?? "",
                                          style: TextStyle(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${snap.data?.courseName ?? ""} ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: Text(
                                            "0",
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          if (only.createdTime != null) {
                                            return Text(
                                              "${con.inputFormat.format(only.createdTime!)} ",
                                              maxLines: 2,
                                            );
                                          }
                                          return const Text("");
                                        }),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          if (only.paymentTime != null) {
                                            return Text(
                                              "${con.inputFormat.format(only.paymentTime!)} ",
                                              maxLines: 2,
                                            );
                                          }
                                          return const Text("");
                                        }),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${only.paymentBy ?? ""} ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          String text = '';
                                          Color color = Colors.white;
                                          switch (only.paymentStatus) {
                                            case 'paid':
                                              text = 'ชำระแล้ว';
                                              color = Colors.green;
                                              break;
                                            case 'pending':
                                              text = 'รอชำระ';
                                              color = Colors.orange;
                                              break;
                                            case 'cancel':
                                              text = 'ยกเลิก';
                                              color = Colors.red;
                                              break;
                                            default:
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(0.2),
                                                  border: Border.all(
                                                    color: color,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "$text",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          if (only.paymentStatus == 'paid') {
                                            return GestureDetector(
                                              onTap: () {},
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "ใบเสร็จรับเงิน",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          // else if (only.paymentStatus !=
                                          //     'cancel') {
                                          //   return GestureDetector(
                                          //     onTap: () {
                                          //       con.updateOrderStatus(
                                          //           only.id ?? "", 'cancel');
                                          //       setState(() {});
                                          //     },
                                          //     child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         Container(
                                          //           decoration: BoxDecoration(
                                          //             color: Colors.white,
                                          //             border: Border.all(
                                          //               color: Colors.grey,
                                          //             ),
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     5),
                                          //           ),
                                          //           alignment: Alignment.center,
                                          //           child: Text(
                                          //             "ยกเลิกออเดอร์",
                                          //             style: TextStyle(
                                          //               fontWeight:
                                          //                   FontWeight.bold,
                                          //               color: Colors.grey,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   );
                                          // }
                                          return const SizedBox();
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget titleBarWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey)),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              "รหัสคำสั่งซื้อ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "คอร์สเรียน",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "จำนวนเงิน",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "วันที่ซื้อ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "ชำระโดย",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "วันที่ชำระ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "สถานะ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
