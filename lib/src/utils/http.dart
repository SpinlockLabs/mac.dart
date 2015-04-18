part of osx.utils;

Future<String> fetch(String url) async {
  var uri = Uri.parse(url);
  var client = new HttpClient();
  var request = await client.getUrl(uri);
  var response = await request.close();
  if (response.statusCode != 200) {
    throw new Exception("Failed to fetch ${url}");
  }
  return response.transform(UTF8.decoder).join().then((out) {
    client.close();
    return out;
  });
}

Future<dynamic> fetchJSON(String url) async {
  var text = await fetch(url);
  var json = JSON.decode(text);
  return json;
}
