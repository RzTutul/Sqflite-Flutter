import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_practice/db/ProductSQLDB.dart';
import 'package:flutter_app_practice/main.dart';
import 'package:flutter_app_practice/model/ProductInfo.dart';

import 'DetailsPage.dart';

class ProductRow extends StatefulWidget {
  final ProductInfo product;
  ProductRow(this.product);

  @override
  _ProductRowState createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:ValueKey(widget.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {

        DBSQLHelper.deleteProduct(widget.product.id).then((value) {

            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Deleted'),
              duration: Duration(seconds: 3),


            ));
           /// Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage()));

        });
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete ${widget.product.name}'),
                  content: Text("Are you want to delete?"),
                  actions: [
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Confirm'),
                      onPressed: () {

                          setState(() {
                            Navigator.of(context).pop(true);

                          });
                      },
                    ),
                  ],
                ));
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsPage(widget.product.id)));
        },
        child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              margin: EdgeInsets.all(5),
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                      tag: widget.product.id,
                      child: Image.file(
                        File(widget.product.image),
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ))),
            ),
            Text(
              widget.product.name,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    "\৳ ${widget.product.price}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            final value = widget.product.isFav ? 0: 1;
                            DBSQLHelper.updateIsFav(widget.product.id, value).then((value) {

                              setState(() {
                                widget.product.isFav = !widget.product.isFav;
                              });

                            });
                          });
                        },
                        child: widget.product.isFav ? Icon(
                                Icons.favorite,
                                size: 20,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 20,
                              )),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
