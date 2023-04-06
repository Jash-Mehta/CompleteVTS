/*import 'package:flutter/material.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';

class MultiSelectUserVehicle extends StatefulWidget {
  List<String> items;
  List<VehicleList> vehicleList=[];
  List<VehicleList> selectedvehicleIDlist=[];


  MultiSelectUserVehicle({Key? key, required this.items,required this.vehicleList,required this.selectedvehicleIDlist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectUserVehicleState();
}

class _MultiSelectUserVehicleState extends State<MultiSelectUserVehicle> {
  final List<String> _selectedItems = [];
  List<VehicleList> _selectedItemslist=[];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        _selectedItems.add(itemValue);
        for(int i=0;i<widget.vehicleList.length;i++){
          if(widget.vehicleList[i].vehicleRegNo==itemValue){
            _selectedItemslist.add(VehicleList(vehicleId: widget.vehicleList[i].vehicleId,vehicleRegNo: widget.vehicleList[i].vehicleRegNo));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist.removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);
    for(int i=0;i<_selectedItemslist.length;i++){
      print("selected list : ${_selectedItemslist[i].vehicleRegNo}");
    }

    Navigator.pop(context, {
      "SelectedUserItemsList":_selectedItems,
      "SelectedUserVehicleList":_selectedItemslist,

    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Vehicle'),
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
}*/



import 'package:flutter/material.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';

class MultiSelectUserVehicle extends StatefulWidget {
  List<String> items;
  List<VehicleList> vehicleList=[];
  List<VehicleList> selectedvehicleIDlist=[];


  MultiSelectUserVehicle({Key? key, required this.items,required this.vehicleList,required this.selectedvehicleIDlist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectUserVehicleState();
}

class _MultiSelectUserVehicleState extends State<MultiSelectUserVehicle> {
  final List<String> _selectedItems = [];
  List<VehicleList> _selectedItemslist=[];
  List<VehicleLists> vehiclelist=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i=0;i<widget.selectedvehicleIDlist.length;i++){
      _selectedItems.add(widget.selectedvehicleIDlist[i].vehicleRegNo!);
      _selectedItemslist.add(VehicleList(
          vehicleId: widget.selectedvehicleIDlist[i].vehicleId,
          vehicleRegNo: widget.selectedvehicleIDlist[i].vehicleRegNo));
    }

    for(int i=0;i<widget.items.length;i++){
      vehiclelist.add(VehicleLists(vehicleno: widget.items[i], vehicleselected: false));
    }


    for(int i=0;i<widget.items.length;i++){
      for(int j=0;j<widget.selectedvehicleIDlist.length;j++){
        if(widget.items[i]==widget.selectedvehicleIDlist[j].vehicleRegNo){
          vehiclelist[i].vehicleselected=true;
        }else{
        }
      }
    }

  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        _selectedItems.add(itemValue);
        for(int i=0;i<widget.vehicleList.length;i++){
          if(widget.vehicleList[i].vehicleRegNo==itemValue){
            _selectedItemslist.add(VehicleList(vehicleId: widget.vehicleList[i].vehicleId,vehicleRegNo: widget.vehicleList[i].vehicleRegNo));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist.removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);
    for(int i=0;i<_selectedItemslist.length;i++){
      print("selected list : ${_selectedItemslist[i].vehicleRegNo}");
    }

    Navigator.pop(context, {
      "SelectedUserItemsList":_selectedItems,
      "SelectedUserVehicleList":_selectedItemslist,

    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Vehicle'),
      content: SingleChildScrollView(
        child: ListBody(
          children: vehiclelist
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item.vehicleno),
            title: Text(item.vehicleno),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item.vehicleno, isChecked!),
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
class VehicleLists{
  late String vehicleno;
  late bool vehicleselected;

  VehicleLists({required this.vehicleno,required this.vehicleselected});
}
