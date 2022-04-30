import 'dart:convert';

import 'package:improve/config.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

toJson(String str) {
  var s = str;

  var kv = s.substring(0, s.length - 1).substring(1).split(",");
  final Map<String, String> pairs = {};

  for (int i = 0; i < kv.length; i++) {
    var thisKV = kv[i].split(":");
    pairs[thisKV[0]] = thisKV[1].trim();
  }

  var encoded = json.encode(pairs);
  return encoded;
}

void main(List<String> arguments) async {
  final app = Router();
  var settings = ConnectionSettings(
      host: conf.host, user: conf.user, password: conf.password, db: conf.db);

  var conn = await MySqlConnection.connect(settings);
  List<String> actu = [];
  int i = 0;
  var id = 1;
  var results = await conn.query('select * from client ');

  for (int isa = results.length; isa > i; i++) {
    var test = results.elementAt(i);
    var te = test.fields.toString();
    String res = toJson(te);
    actu.add(res);
  }
  // print(actu);

  app.get('/', (Request request) async {
    return Response.ok(actu.toString());
  });

  await io.serve(app, 'localhost', 3000);
}
