import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      CartModel.of(context).updatePrices();
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(cartProduct.productData.images[0], fit: BoxFit.cover,),

          ),
          Expanded(child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(cartProduct.productData.title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
                Text('Tamanho: ${cartProduct.size}',
                  style: TextStyle(fontWeight: FontWeight.w300),),
                Text('R\$ ${cartProduct.productData.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Theme.of(context).primaryColor ,fontSize: 16, fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cartProduct.quantity <= 1 ? null : (){
                          CartModel.of(context).decProduct(cartProduct);
                        }
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CartModel.of(context).incProduct(cartProduct);
                        }),
                    FlatButton(
                      child:  Text("Remover"),
                      textColor: Colors.grey[500],
                      onPressed: (){
                        CartModel.of(context).removeCartItem(cartProduct);

                      },
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProduct.category)
          .collection('itens').document(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            }else{
              return Container(
                height: 70,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) : _buildContent()
      ,
    );
  }
}
