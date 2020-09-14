import 'package:flutter_app_practice/model/ProductInfo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class DBSQLHelper {
  static final CREATE_TBL_PRODUCT = '''create table $TBL_PRODUCT(
  $PRO_COL_ID integer primary key autoincrement,
  $PRO_COL_NAME text not null,
  $PRO_COL_IMAGE text not null,
  $PRO_COL_PRICE real not null,
  $PRO_COL_CATAGORY text not null,
  $PRO_COL_RATING real not null,
  $PRO_COL_DESCRIPTION text not null,
  $PRO_COL_DATE integer not null,
  $PRO_COL_ISFAV integer not null
  )''';

  static Future<Database> open() async {
    final rootpath = await getDatabasesPath();
    final dbPath = Path.join(rootpath, 'food.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      db.execute(CREATE_TBL_PRODUCT);
    });
  }

  static Future<int> insertProduct(ProductInfo productInfo) async {
    final db = await open();
    return db.insert(TBL_PRODUCT, productInfo.toMap());
  }

  static Future<List<ProductInfo>> getAllProductList() async {
    final db = await open();
    List<Map<String, dynamic>> mapList =
        await db.rawQuery('select * from $TBL_PRODUCT');
    return List.generate(
        mapList.length, (index) => ProductInfo.fromMap(mapList[index]));
  }

  static Future<ProductInfo> getAllProductByID(int id) async {
    final db = await open();
    List<Map<String, dynamic>> mapList =
        await db.query(TBL_PRODUCT, where: '$PRO_COL_ID = ?', whereArgs: [id]);
    if (mapList.length > 0) {
      return ProductInfo.fromMap(mapList.first);
    }

  }
    static Future<int> deleteProduct(int id) async {
    final db = await open();
      return db.delete(TBL_PRODUCT,where: '$PRO_COL_ID = ?',whereArgs: [id]);
    }




  static Future<int> update(ProductInfo productInfo) async {
    final db = await open();
    return db.update(TBL_PRODUCT,productInfo.toMap(),  where: '$PRO_COL_ID = ?', whereArgs: [productInfo.id]);
  }


  static Future<int> updateIsFav(int id ,int value) async {
    final db = await open();
    return db.update(TBL_PRODUCT,{PRO_COL_ISFAV : value},  where: '$PRO_COL_ID = ?', whereArgs: [id]);
  }

  }
