import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_practice/db/ProductDB.dart';
import 'package:flutter_app_practice/db/ProductSQLDB.dart';
import 'package:flutter_app_practice/main.dart';
import 'package:flutter_app_practice/model/ProductInfo.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddProduct extends StatefulWidget {
  final int id;
  AddProduct(this.id);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final _formKey = GlobalKey<FormState>();
  var productInfo = new ProductInfo();
  int SelectdateTime;
  double rating =2.5;
  String catagory = 'Fast Food';
  String imagePath = null;
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();


  void _selectDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2030))
        .then((date) => {
              setState(() {
                SelectdateTime = date.millisecondsSinceEpoch;
                productInfo.date = SelectdateTime;
              })
            });
  }


  void CaptureImage() {
    ImagePicker().getImage(source: ImageSource.camera).then((imgFile) => {
          setState(() {
            imagePath = imgFile.path;
            productInfo.image = imagePath;
          })
        });
  }

  void PicImageFromGallery() {
    ImagePicker().getImage(source: ImageSource.gallery).then((imgFile) => {
          setState(() {
            imagePath = imgFile.path;
            productInfo.image = imagePath;
          })
        });
  }
  void _saveItem()
  {
    if(_formKey.currentState.validate())
      {
        _formKey.currentState.save();
        if(widget.id>0)
          {
            productInfo.id = widget.id;
            print(productInfo.toString());

            DBSQLHelper.update(productInfo).then((value) {
              if(value>0)
                {


                  Navigator.push(context, MaterialPageRoute(builder:(context) => MyHomePage()));
                }
            });
          }
        else
          {

            DBSQLHelper.insertProduct(productInfo).then((value){
              if(value>0)
                {
                  Navigator.push(context, MaterialPageRoute(builder:(context) => MyHomePage()));
                }
            });
          }



      }
  }


@override
  void didChangeDependencies() {
    super.didChangeDependencies();
if(widget.id>0)
  {
    DBSQLHelper.getAllProductByID(widget.id).then((value) {
      setState(() {
        nameController.text = value.name;
        priceController.text = (value.price).toString();
        descriptionController.text = value.description;
         catagory = value.categories;
         SelectdateTime = value.date;
         rating = value.rating;
        imagePath = value.image;

        productInfo.categories = catagory;
        productInfo.rating = rating;
        productInfo.image = imagePath;
        productInfo.date = SelectdateTime;
      });
    });
  }


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Item"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(

                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                    labelText: "Product name", border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The field must not empty';
                  }
                  return null;
                },
                onSaved: (name) {
                  productInfo.name = name;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: priceController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Product price", border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The field must not empty';
                  }
                  return null;
                },
                onSaved: (price) {
                  productInfo.price = double.parse(price);
                },
              ),
              DropdownButton(
                value: catagory,
                items: catagories
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    catagory = value;
                    productInfo.categories = catagory;
                  });
                },
              ),
              SizedBox(
                height: 8,
              ),
              RatingBar(
                initialRating: rating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  half: Icon(
                    Icons.star_half,
                    color: Colors.amber,
                  ),
                  empty: Icon(Icons.star_border),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  //print(rating);
                  productInfo.rating = rating;

                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                controller: descriptionController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                maxLines: 6,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Product Description",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'The field must not empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  productInfo.description = value ;
                },
              ),
              SizedBox(
                height: 8,
              ),
              FlatButton.icon(
                  onPressed: _selectDate,
                  icon: Icon(Icons.date_range),
                  label: Text(SelectdateTime == null ? 'Select date' : DateFormat('EEE dd/MMM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(SelectdateTime)))),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: imagePath == null
                          ? Icon(
                              Icons.fastfood,
                              color: Colors.white,
                              size: 50,
                            )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                            child: Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                              ),
                          )),
                  Column(
                    children: [
                      RaisedButton.icon(
                          onPressed: CaptureImage,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey)),
                          icon: Icon(Icons.camera_alt),
                          label: Text("From Camera")),
                      RaisedButton.icon(
                          onPressed: PicImageFromGallery,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey)),
                          icon: Icon(Icons.photo_album),
                          label: Text("From Gallery ")),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: RaisedButton(
                  color: Colors.black54,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text( widget.id>0? 'Update':
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: _saveItem,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
