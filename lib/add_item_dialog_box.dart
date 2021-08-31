import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist_app_mobile/mock/db/Database.dart';
import 'package:shoppinglist_app_mobile/types/constants.dart';

class AddItemDialogBox extends StatefulWidget {
  final String title, itemName, text;
  final ItemList itemList;

  const AddItemDialogBox({required Key key, required this.itemList, required this.title, required this.itemName, required this.text}) : super(key: key);

  @override
  _AddItemDialogBoxState createState() => _AddItemDialogBoxState();
}

class _AddItemDialogBoxState extends State<AddItemDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.topRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.topRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Vad ska handlas?',
                ),
                onSubmitted: (String value) {
                  if(value != "") {
                    widget.itemList.addItemToList(value);
                    widget.itemList.printList();
                  }
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 22,),
            ],
          ),
        ),
      ],
    );
  }
}