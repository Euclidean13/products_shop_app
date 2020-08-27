import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products_shop_app/src/models/product_model.dart';
import 'package:products_shop_app/src/providers/products_provider.dart';
import 'package:products_shop_app/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productProvider = new ProductsProvider();
  ProductModel product = new ProductModel();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPicture,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePicture,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _showPicture(),
                  _createName(),
                  _createPrice(),
                  _createAvailable(),
                  _createButton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Introduce the name of the product';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Only numbers';
        }
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.available = value;
      }),
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Save'),
      icon: Icon(Icons.save),
      onPressed: (_saving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    // To excute onSave of _createPrice and _createButton:
    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.urlPicture = await productProvider.uploadImage(photo);
    }

    if (product.id == null) {
      productProvider.createProduct(product);
    } else {
      productProvider.editProduct(product);
    }

    // setState(() {
    //   _saving = false;
    // });
    showSnackbar('Saved register');
    Navigator.pop(context);
  }

  void showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPicture() {
    if (product.urlPicture != null) {
      return FadeInImage(
        image: NetworkImage(product.urlPicture),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPicture() async {
    _processImage(ImageSource.gallery);
  }

  _takePicture() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource origin) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(source: origin);

    photo = File(pickedFile.path);

    if (photo != null) {
      product.urlPicture = null;
    }

    setState(() {});
  }
}
