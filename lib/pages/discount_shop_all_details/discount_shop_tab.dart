import 'package:flutter/material.dart';
import 'package:user_panel/pages/discount_shop_all_details/discount_shop_category_page.dart';
import 'package:user_panel/pages/discount_shop_all_details/subscribed_discountshop_list.dart';


class DiscountShopTab extends StatefulWidget {
  @override
  _DiscountShopTabState createState() => _DiscountShopTabState();
}

class _DiscountShopTabState extends State<DiscountShopTab> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: Color(0xffF4F7F5),
        appBar: AppBar(
          title: Text("Discount Shop"),
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 13,
              ),
              tabs: [
                Tab(text: 'Shop Category'),
                Tab(text: 'Subscribed Shop'),

              ]),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
              children: [
                DiscountShopCategory(),
                SubscribedDiscountShop(),
              ]
          ),
        ),
        ),
      );
  }
}
