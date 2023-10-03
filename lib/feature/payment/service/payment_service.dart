import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:solve_tutor/feature/calendar/app_client/app_client.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/payment/chillpay/endpoint.dart';
import 'package:solve_tutor/firebase/firestore.dart';

class PaymentService {
  final endpoint = PaymentEndpoint();
  final client = AppClient();
  final db = FirestoreService('chillpay_orders');
  final md = 'N9t7EbrXu6ccnEwIT7zysYK65L0yIZrXmL1J0KVwubnb1RQwqyGBRYnFqAGyrrIqdokw1lTjaOEP2iIGspqQ4jqk5QngvTkPgiJkj1Fs1MSeEux5f2zm46jbScETDN6D2GNM0sM4cnHRQZVgkOiup6E9pQ5r7bB5vXdRV';

  Future generateLink(Map<String, dynamic> body) async {
    try{
      var now = DateTime.now();
      var tomorrow = now.add(const Duration(hours: 24));
      body['StartDate'] = FormatDate.dateTimeWithSecond(now);
      body['ExpiredDate'] = FormatDate.dateTimeWithSecond(tomorrow);
      var preSum = '${body['ProductImage']}'
          '${body['ProductName']}'
          '${body['ProductDescription']}'
          '${body['PaymentLimit']}'
          '${body['StartDate']}'
          '${body['ExpiredDate']}'
          '${body['Currency']}'
          '${body['Amount']}'
          '$md';
      body['Checksum'] = generateMd5(preSum);
      print(body);
      Map<String, dynamic> json =
      await client.post(endpoint.generateLink(), body: body, preferHeader: {
        "CHILLPAY-MerchantCode": "M034702",
        "CHILLPAY-ApiKey": "K23xkzZETiAXREM5xvfXfi88UH1xJL9AnP9luicolo4KPPeXqn4ebGbbzjvWvA7D",
        "Content-Type": "application/json",
      });
      if(json != null) {
        json['data'];
        await db.addDocument(json['data'], body['ProductName']
            .split('_')
            .last);
      }
      print(json);
      return json;
    } catch (error) {
      rethrow;
    }
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}