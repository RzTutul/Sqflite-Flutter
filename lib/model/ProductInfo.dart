import 'package:flutter/cupertino.dart';
final String TBL_PRODUCT = 'product_tbl';
final String PRO_COL_ID = 'pro_id';
final String PRO_COL_NAME = 'pro_name';
final String PRO_COL_IMAGE = 'pro_image';
final String PRO_COL_PRICE = 'pro_price';
final String PRO_COL_CATAGORY = 'pro_catagory';
final String PRO_COL_RATING = 'pro_rating';
final String PRO_COL_DESCRIPTION = 'pro_description';
final String PRO_COL_DATE = 'pro_date';
final String PRO_COL_ISFAV = 'pro_isfav';

class ProductInfo {



  int id;
  String name;
  String image;
  double price;
  String categories;
  double rating;
  String description;
  int date;
  bool isFav ;

  ProductInfo(
      {this.id,
       this.name,
      this.image,
      this.price,
      this.rating,
      this.isFav = false,
      });

  Map<String,dynamic> toMap()
  {
    var map =<String,dynamic>  {
      PRO_COL_NAME :name,
      PRO_COL_IMAGE :image,
      PRO_COL_PRICE :price,
      PRO_COL_CATAGORY :categories,
      PRO_COL_RATING :rating,
      PRO_COL_DESCRIPTION :description,
      PRO_COL_DATE :date,
      PRO_COL_ISFAV : isFav ? 1: 0,

    };

    if(id != null)
      {
        map[PRO_COL_ID] = id;
      }

    return map;

  }


  ProductInfo.fromMap(Map<String, dynamic> map){
    id = map[PRO_COL_ID];
    name = map[PRO_COL_NAME];
    image = map[PRO_COL_IMAGE];
    price = map[PRO_COL_PRICE];
    categories = map[PRO_COL_CATAGORY];
    description = map[PRO_COL_DESCRIPTION];
    date = map[PRO_COL_DATE];
    rating = map[PRO_COL_RATING];
    isFav = map[PRO_COL_ISFAV] == 0 ? false: true;
  }

  @override
  String toString() {
    return 'ProductInfo{id: $id, name: $name, image: $image, price: $price, categories: $categories, rating: $rating, description: $description, date: $date}';
  }
}
