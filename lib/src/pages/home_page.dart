import 'package:flutter/material.dart';
import 'package:products_shop_app/src/bloc/provider.dart';
import 'package:products_shop_app/src/models/product_model.dart';
import 'package:products_shop_app/src/providers/products_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _createList(),
      floatingActionButton: _createButton(context),
    );
  }

  _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product').then((value) {
        setState(() {});
      }),
    );
  }

  _createList() {
    return FutureBuilder(
      future: productsProvider.loadProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) => _createItem(context, snapshot.data[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red[200],
      ),
      onDismissed: (direction) {
        productsProvider.deleteProduct(product.id);
      },
      child: Card(
        child: Column(
          children: [
            (product.urlPicture == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(product.urlPicture),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text('${product.id}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: product)
                      .then((value) {
                setState(() {});
              }),
            )
          ],
        ),
      ),
    );
  }
}
