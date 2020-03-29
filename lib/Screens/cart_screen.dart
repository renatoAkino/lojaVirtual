import 'package:flutter/material.dart';
import 'package:lojavirtual/Screens/login_screen.dart';
import 'package:lojavirtual/Screens/order_screen.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/usuario_model.dart';
import 'package:lojavirtual/tiles/cart_tile.dart';
import 'package:lojavirtual/widgets/cart_price.dart';
import 'package:lojavirtual/widgets/descount_card.dart';
import 'package:lojavirtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;

                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}", style: TextStyle(fontSize: 17),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
          builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedin()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(!UserModel.of(context).isLoggedin()){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16,),
                  Text("Faça login para adicionar produtos!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    child: Text("Entrar",
                      style: TextStyle(fontSize: 18)),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },
                  )
                ],
              ),
            );
          }else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text("Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              )
            );
          } else{
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map(
                      (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderID = await model.finishOrder();
                  if(orderID != null){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OrderScreen(orderID))
                    );
                  }
                })
              ],
            );
          }
          return Container();
      }),
    );
  }
}
