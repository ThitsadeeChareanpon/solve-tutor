import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/authentication/service/auth_provider.dart';
import 'package:solve_tutor/feature/order_manage/model/course_market_model.dart';
import 'package:solve_tutor/feature/order_manage/model/order_class_model.dart';

class MyOrderController extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  MyOrderController(this.context);
  BuildContext context;
  AuthProvider? auth;
  var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  List<OrderCourseModel> orderList = [];
  init() {
    orderList = [];
    auth = Provider.of<AuthProvider>(context, listen: false);
    getMyCourseList();
  }

  getMyCourseList() async {
    orderList = [];
    await firebaseFirestore
        .collection('orders')
        .where('tutorId', isEqualTo: auth?.uid ?? "")
        .get()
        .then((data) async {
      if (data.size != 0) {
        for (var i = 0; i < data.docs.length; i++) {
          var only = OrderCourseModel.fromJson(data.docs[i].data());
          orderList.add(only);
        }
      }
    });
    notifyListeners();
  }

  Future<CourseMarketModel?> getCourseInfo(String id) async {
    CourseMarketModel? only;
    await firebaseFirestore
        .collection('course')
        .doc(id)
        .get()
        .then((userFirebase) async {
      if (userFirebase.exists) {
        only = CourseMarketModel.fromJson(userFirebase.data()!);
      } else {
        only = CourseMarketModel();
      }
    });
    return only;
  }

  updateOrderStatus(
    String orderId,
    String status,
  ) async {
    var orders = firebaseFirestore.collection("orders");
    await orders.doc(orderId).update({
      'paymentStatus': status,
      'payment_time': DateTime.now().millisecondsSinceEpoch,
    });
    init();
  }
}
