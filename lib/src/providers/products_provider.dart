import 'dart:convert';
import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:products_shop_app/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:products_shop_app/src/user_preferences/user_preferences.dart';

class ProductsProvider {
  final String _url = 'https://flutter-product-page.firebaseio.com';
  final _prefs = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = new List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);
      prodTemp.id = id;
      products.add(prodTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print('Delete product response: ${resp.body}');

    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'http://api.cloudinary.com/v1_1/dn1vqhgof/image/upload?upload_preset=hfalyy4x');

    final mimeType = mime(image.path).split('/'); //image/jpeg

    final imageUploadResquest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadResquest.files.add(file);

    final streamResponse = await imageUploadResquest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something went wrong');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }
}
