import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Screens/login_screen.dart';
import 'package:lojavirtual/models/usuario_model.dart';
import 'package:lojavirtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(UserModel.of(context).isLoggedin()){
      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }else{
            return ListView(
              children: snapshot.data.documents.map((doc) => OrderTile(doc.documentID)).toList().reversed.toList(),
            );
          }
        },
      );
    }else{
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.view_list, size: 80, color: Theme.of(context).primaryColor,),
              SizedBox(height: 16,),
              Text("Faça login para acompanhar os pedidos",
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
    }

  }
}
