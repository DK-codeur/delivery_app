import 'package:flutter/material.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(context),
          ),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historiques de livraison', style: TextStyle(fontSize: 18, color: Colors.black54,)),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}