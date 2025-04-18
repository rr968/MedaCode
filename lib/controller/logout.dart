import 'package:http/http.dart' as http;
import '/controller/var.dart';

Future<bool> logout() async {
  var headers = {'Cookie': 'PHPSESSID=1ljp80udb4p4rbib2mgqomsue8'};
  var request = http.Request(
      'GET',
      Uri.parse(
          '$baseUrl/logout.php?input_key=$input_key&input_secret=$input_secret'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
