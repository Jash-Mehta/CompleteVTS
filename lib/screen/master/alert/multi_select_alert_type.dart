
import 'package:flutter/material.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/fill_alert_response.dart';


class MultiSelectAlertType extends StatefulWidget {
  List<String> items;
  // List<FillAlertResponse> alerttypelist=[];
  List<AlertsDetail> selectedalerttypelist=[];

  List<AlertsDetail> alerttypelist=[];

  MultiSelectAlertType({Key? key,required this.items,required this.alerttypelist,required this.selectedalerttypelist}) : super(key: key);

  @override
  _MultiSelectAlertTypeState createState() => _MultiSelectAlertTypeState();
}

class _MultiSelectAlertTypeState extends State<MultiSelectAlertType> {

  // this variable holds the selected items
  final List<String> _selectedItems = [];
  // final List<FillAlertResponse> _selectedItemslist = [];
  List<AlertsDetail> _selectedItemslist=[];
  List<AlertTypeList> alertTypelist=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i=0;i<widget.selectedalerttypelist.length;i++){
      _selectedItems.add(widget.selectedalerttypelist[i].alertIndication!);
      _selectedItemslist.add(AlertsDetail(
          alertCode: widget.selectedalerttypelist[i].alertCode,
          alertIndication: widget.selectedalerttypelist[i].alertIndication));
    }

    for(int i=0;i<widget.items.length;i++){
      alertTypelist.add(AlertTypeList(alertType: widget.items[i], alertTypeSelected: false));
    }


    for(int i=0;i<widget.items.length;i++){
      for(int j=0;j<widget.selectedalerttypelist.length;j++){
        if(widget.items[i]==widget.selectedalerttypelist[j].alertIndication){
          alertTypelist[i].alertTypeSelected=true;
        }else{
        }
      }
    }
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        _selectedItems.add(itemValue);
        for(int i=0;i<widget.alerttypelist.length;i++){
          if(widget.alerttypelist[i].alertIndication==itemValue){
            _selectedItemslist.add(AlertsDetail(alertCode: widget.alerttypelist[i].alertCode,alertIndication: widget.alerttypelist[i].alertIndication));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist.removeWhere((item) => item.alertIndication == itemValue);
        print(_selectedItemslist.length);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text('Select Alert Type'),
      content: SingleChildScrollView(
        child: ListBody(
          children: alertTypelist
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item.alertType),
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


  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    print(_selectedItems);
    for(int i=0;i<_selectedItemslist.length;i++){
      print("selected list : ${_selectedItemslist[i].alertIndication}");
    }

    // Navigator.pop(context, _selectedItems);
    Navigator.pop(context, {
      "AlertTypeList":_selectedItems,
      "AlertTypeCodeList":_selectedItemslist,
    });

  }
}

class AlertTypeList{
  late String alertType;
  late bool alertTypeSelected;

  AlertTypeList({required this.alertType,required this.alertTypeSelected});
}

/*import 'package:flutter/material.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';


class MultiSelectAlertType extends StatefulWidget {
  List<String> items;
  // List<FillAlertResponse> alerttypelist=[];
  List<AlertsDetail> selectedalerttypelist=[];

  List<AlertsDetail> alerttypelist=[];

  MultiSelectAlertType({Key? key,required this.items,required this.alerttypelist,required this.selectedalerttypelist}) : super(key: key);

  @override
  _MultiSelectAlertTypeState createState() => _MultiSelectAlertTypeState();
}

class _MultiSelectAlertTypeState extends State<MultiSelectAlertType> {

  final List<String> _selectedItems = [];
  // final List<FillAlertResponse> _selectedItemslist = [];
  List<AlertsDetail> _selectedItemslist=[];


  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        _selectedItems.add(itemValue);
        for(int i=0;i<widget.alerttypelist.length;i++){
          if(widget.alerttypelist[i].alertIndication==itemValue){
            _selectedItemslist.add(AlertsDetail(alertCode: widget.alerttypelist[i].alertCode,alertIndication: widget.alerttypelist[i].alertIndication));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist.removeWhere((item) => item.alertIndication == itemValue);
        print(_selectedItemslist.length);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text('Select Alert Type'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
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


  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);
    for(int i=0;i<_selectedItemslist.length;i++){
      print("selected list : ${_selectedItemslist[i].alertIndication}");
    }

    Navigator.pop(context, {
      "AlertTypeList":_selectedItems,
      "AlertTypeCodeList":_selectedItemslist,
    });

  }
}*/
