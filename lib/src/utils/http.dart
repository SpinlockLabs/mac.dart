part of mac.utils;

Future<String> fetch(String url) async {
  var uri = Uri.parse(url);
  var client = HttpClient();
  var request = await client.getUrl(uri);
  var response = await request.close();
  if (response.statusCode != 200) {
    throw Exception("Failed to fetch ${url}");
  }
  return response.transform(const Utf8Decoder()).join().then((out) {
    client.close();
    return out;
  });
}

Future<dynamic> fetchJSON(String url) async {
  var text = await fetch(url);
  var json = jsonDecode(text);
  return json;
}
