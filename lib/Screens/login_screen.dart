import 'package:flutter/material.dart';
import 'package:lojavirtual/Screens/signup_screen.dart';
import 'package:lojavirtual/models/usuario_model.dart';
import 'package:scoped_model/scoped_model.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SignUpScreen()
                ));
              },
              child: Text("CRIAR CONTA",
                style: TextStyle(fontSize: 15),
              ),
              textColor: Colors.white,

            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator(),);
            else
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "Email invalido";
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(hintText: "Senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Senha invalida";
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                            if(_emailController.text.isEmpty){
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Insira seu email para recuperação"),
                                    backgroundColor: Colors.redAccent,
                                    duration: Duration(seconds: 2),
                                  ));
                            }else{
                              model.recoverPass(_emailController.text);
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Confira seu email"),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    duration: Duration(seconds: 2),
                                  ));
                            }

                        },
                        child: Text(
                          "Esqueci minha senha", textAlign: TextAlign.right,),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        child: Text('Entrar',
                          style: TextStyle(fontSize: 18),
                        ),
                        textColor: Colors.white,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          model.signIn(email: _emailController.text,
                              pass: _passController.text,
                              onSucess: _onSucess,
                              onFailed: _onFailed);
                        },
                      ),
                    )
                  ],
                ),
              );
          },
        )
    );
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFailed() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao entrar"),
          backgroundColor: Colors.redAccent,
         duration: Duration(seconds: 2),
        ));
  }

}

