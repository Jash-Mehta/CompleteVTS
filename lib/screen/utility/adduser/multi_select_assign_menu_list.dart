/*import 'package:flutter/material.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';


class MultiSelectAssignMenuList extends StatefulWidget {
  List<MenuList> menuList=[];
  List<String> assignallmenulist = [];
  List<MenuList> selectedmenuList=[];

  MultiSelectAssignMenuList({Key? key,required this.assignallmenulist, required this.menuList,required this.selectedmenuList}) : super(key: key);

  @override
  _MultiSelectAssignMenuListState createState() => _MultiSelectAssignMenuListState();
}

class _MultiSelectAssignMenuListState extends State<MultiSelectAssignMenuList> {
  List<MenuList> selectedmenuList=[];
  List<String> selectedassignallmenulist = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        selectedassignallmenulist.add(itemValue);
        for(int i=0;i<widget.menuList.length;i++){
          if(widget.menuList[i].menuCaption==itemValue){
            selectedmenuList.add(MenuList(menuId: widget.menuList[i].menuId,menuCaption: widget.menuList[i].menuCaption));
          }
        }
      } else {
        selectedassignallmenulist.remove(itemValue);
        selectedmenuList.removeWhere((item) => item.menuCaption == itemValue);
      }
    });
  }


  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(selectedassignallmenulist);
    for(int i=0;i<selectedmenuList.length;i++){
      print("selected list : ${selectedmenuList[i].menuCaption}");
    }

    // Navigator.pop(context, _selectedItems);
    Navigator.pop(context, {
      "SelectedAssignMenuItemsList":selectedassignallmenulist,
      "SelectedAssignMenuList":selectedmenuList,

    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Assign Menu'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.assignallmenulist
              .map((item) => CheckboxListTile(
                value: selectedassignallmenulist.contains(item),
                title: Text(item),
                controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}*/



import 'package:flutter/material.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';


class MultiSelectAssignMenuList extends StatefulWidget {
  List<MenuList> menuList=[];
  List<String> assignallmenulist = [];
  List<MenuList> selectedmenuList=[];

  MultiSelectAssignMenuList({Key? key,required this.assignallmenulist, required this.menuList,required this.selectedmenuList}) : super(key: key);

  @override
  _MultiSelectAssignMenuListState createState() => _MultiSelectAssignMenuListState();
}

class _MultiSelectAssignMenuListState extends State<MultiSelectAssignMenuList> {
  List<MenuList> selectedmenuList=[];
  List<String> selectedassignallmenulist = [];
  List<AlertTypesList> alertTypelist=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i=0;i<widget.selectedmenuList.length;i++){
      selectedassignallmenulist.add(widget.selectedmenuList[i].menuCaption!);
      selectedmenuList.add(MenuList(
          menuId: widget.selectedmenuList[i].menuId,
          menuCaption: widget.selectedmenuList[i].menuCaption));
    }

    for(int i=0;i<widget.assignallmenulist.length;i++){
      alertTypelist.add(AlertTypesList(alertType: widget.assignallmenulist[i], alertTypeSelected: false));
    }


    for(int i=0;i<widget.assignallmenulist.length;i++){
      for(int j=0;j<widget.selectedmenuList.length;j++){
        if(widget.assignallmenulist[i]==widget.selectedmenuList[j].menuCaption){
          alertTypelist[i].alertTypeSelected=true;
        }else{
        }
      }
    }

  }



  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        selectedassignallmenulist.add(itemValue);
        for(int i=0;i<widget.menuList.length;i++){
          if(widget.menuList[i].menuCaption==itemValue){
            selectedmenuList.add(MenuList(menuId: widget.menuList[i].menuId,menuCaption: widget.menuList[i].menuCaption));
          }
        }
      } else {
        selectedassignallmenulist.remove(itemValue);
        selectedmenuList.removeWhere((item) => item.menuCaption == itemValue);
      }
    });
  }


  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(selectedassignallmenulist);
    for(int i=0;i<selectedmenuList.length;i++){
      print("selected list : ${selectedmenuList[i].menuCaption}");
    }

    // Navigator.pop(context, _selectedItems);
    Navigator.pop(context, {
      "SelectedAssignMenuItemsList":selectedassignallmenulist,
      "SelectedAssignMenuList":selectedmenuList,

    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Assign Menu'),
      content: SingleChildScrollView(
        child: ListBody(
          children: alertTypelist
              .map((item) => CheckboxListTile(
            value: selectedassignallmenulist.contains(item.alertType),
            title: Text(item.alertType),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item.alertType, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

class AlertTypesList{
  late String alertType;
  late bool alertTypeSelected;

  AlertTypesList({required this.alertType,required this.alertTypeSelected});
}

