class PaymentEndpoint {
  //prod
  // final url = "https://api-paylink.chillpay.co/api/v1";
  //dev
  final url = "https://sandbox-apipaylink.chillpay.co/api/v1";

  Uri generateLink() {
    return Uri.parse('$url/paylink/generate');
  }
}