import 'dart:convert';
import 'package:http/http.dart' as http;

gatewayrequest(String payid) async {
  // await refreshrequest();

  var response = await http.post(
      Uri.parse(
          "http://tylleumv1-env.eba-x3mwenff.us-east-1.elasticbeanstalk.com/api/v1/transaction/paymentstatus"),
      headers: {
        "content-type": "application/json",
      },
      body: json.encode({"paymentId": payid}));
  print(response.body);
  return json.decode(response.body);
}
