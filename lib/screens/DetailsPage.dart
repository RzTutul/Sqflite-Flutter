import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_practice/db/ProductSQLDB.dart';
import 'package:flutter_app_practice/model/ProductInfo.dart';
import 'package:flutter_app_practice/screens/AddProduct.dart';

import '../db/ProductDB.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  DetailsPage(this.id);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
   ProductInfo productInfo = ProductInfo();
  @override
  Widget build(BuildContext context) {

 /*   DBSQLHelper.getAllProductByID(widget.id).then((value) => {
      productInfo = value
    });*/

     return Scaffold(
      body: FutureBuilder(
        future: DBSQLHelper.getAllProductByID(widget.id) ,
         builder: (context, AsyncSnapshot<ProductInfo> snapshot){
          if(snapshot.hasData)
            {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    actions: [
                      IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct(widget.id)));

                        },
                        icon:Icon( Icons.edit),)
                    ],

                    pinned: true,
                    floating: true,
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(snapshot.data.name,),
                      background: Hero(
                          tag: snapshot.data.id,
                          child: Image.file(File(snapshot.data.image),fit: BoxFit.cover,)),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                        [
                          ListTile(
                            title: Text(snapshot.data.name),
                            subtitle: Text('\৳ ${snapshot.data.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star),
                                Text('${snapshot.data.rating}')
                              ],

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data.description,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(description,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),),
                          ),
                        ]

                    ),
                  )
                ],
              );
            }

          if(snapshot.hasError)
            {
              return Center(child: Text("Data can't fitch"),);
            }

          return Center(child: CircularProgressIndicator(),);
       }

      )
    );
  }
}
