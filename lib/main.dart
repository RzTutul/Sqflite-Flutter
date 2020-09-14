import 'package:flutter/material.dart';
import 'package:flutter_app_practice/db/ProductDB.dart';
import 'package:flutter_app_practice/model/ProductInfo.dart';
import 'package:flutter_app_practice/screens/AddProduct.dart';

import 'db/ProductSQLDB.dart';
import 'screens/ProductRow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Icon(
                    Icons.fastfood,
                    color: Colors.deepOrangeAccent,
                    size: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Food Panda",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.add_circle_outline),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Food item",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct(0) ));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.category),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Add Categories",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),

        ///leading: Icon(Icons.format_list_bulleted,color: Colors.black.withOpacity(0.2)),
        actions: [
          Padding(

              padding: EdgeInsets.all(1),
              child: IconButton(icon: Icon(Icons.search),color: Colors.white,onPressed: (){},)),
      Padding(

              padding: EdgeInsets.all(1),
              child: IconButton(icon: Icon(Icons.add_shopping_cart),color: Colors.white,onPressed: (){},)),


        ],
      ),
      body: Body(),
    );
  }


}

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DBSQLHelper.getAllProductList(),
      builder: (context, AsyncSnapshot<List<ProductInfo>> snapshot){
        if(snapshot.hasData){
          if(snapshot.data.length == 0)
            {
             return Center(child: Text("No data Found"),);
            }
          return   buildGridView (snapshot);
        }
        return Center(child: CircularProgressIndicator(),);
      }

    );
  }

  GridView buildGridView(AsyncSnapshot<List<ProductInfo>> snapshot) {
    return GridView.builder(
          itemCount: snapshot.data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.75),
          itemBuilder: (context, index) => ProductRow(snapshot.data[index]),
        );
  }

  ListView mapListView() {
    return ListView(
      children: products.map((e) => ProductRow(e)).toList(),
    );
  }

  ListView buildListView(AsyncSnapshot<List<ProductInfo>> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) => ProductRow(snapshot.data[index]),
      itemCount: snapshot.data.length,
    );
  }
}
