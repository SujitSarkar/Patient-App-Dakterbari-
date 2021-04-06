import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    //DoctorProvider drProvider=Provider.of<DoctorProvider>(context);
    return Consumer<DoctorProvider>(
      builder: (context, operation,child){
        return Scaffold(
          backgroundColor: Colors.white,
          //backgroundColor: Color(0xffF4F7F5),

          body: AnimationLimiter(
            child: ListView.builder(
              itemCount: faqDataList(operation).length,
              itemBuilder: (context, index){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 400,
                      child: FadeInAnimation(
                        child: EntryItemTile(
                            faqDataList(operation)[index],MediaQuery.of(context).size),
                      ),
                    )
                );
              },
            ),
          ),
        );
      },
    );
  }
}

///Create the widget for the row...
class EntryItemTile extends StatelessWidget {
  Size size;

  final Entry entry;

  EntryItemTile(this.entry,this.size);

  Widget _buildTiles(Entry root) {

    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title,style: TextStyle(color: Colors.grey[800],fontSize: size.width*.033),),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title,style: TextStyle(fontWeight: FontWeight.w500,fontSize: size.width*.040),),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return _buildTiles(entry);
  }
}
