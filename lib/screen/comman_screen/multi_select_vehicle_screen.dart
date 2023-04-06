
import 'package:flutter/material.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/add_alert_master_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';

class MultiSelect extends StatefulWidget {
  List<String> items;
  // List<VehicleFillResponse> vehiclelist=[];
  List<VehiclesDetail> vehiclelist = [];
  List<VehiclesDetail> selectedvehicleSrNoDetailslist=[];

  MultiSelect({Key? key, required this.items, required this.vehiclelist,required this.selectedvehicleSrNoDetailslist})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  // final List<VehicleFillResponse> _selectedItemslist = [];
  List<VehiclesDetail> _selectedItemslist = [];

  List<bool> _isChecked=[];
  List<VehicleList> vehiclelist=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i=0;i<widget.selectedvehicleSrNoDetailslist.length;i++){
      _selectedItems.add(widget.selectedvehicleSrNoDetailslist[i].vehicleRegNo!);
      _selectedItemslist.add(VehiclesDetail(
          vsrNo: widget.selectedvehicleSrNoDetailslist[i].vsrNo,
          vehicleRegNo: widget.selectedvehicleSrNoDetailslist[i].vehicleRegNo));
    }

      for(int i=0;i<widget.items.length;i++){
      vehiclelist.add(VehicleList(vehicleno: widget.items[i], vehicleselected: false));
    }


    for(int i=0;i<widget.items.length;i++){
      for(int j=0;j<widget.selectedvehicleSrNoDetailslist.length;j++){
        if(widget.items[i]==widget.selectedvehicleSrNoDetailslist[j].vehicleRegNo){
          vehiclelist[i].vehicleselected=true;
        }else{
        }
      }
    }

    for(int i=0;i<vehiclelist.length;i++){
      print("Selected vehicle list :${vehiclelist[i].vehicleselected}");

    }

  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
        for (int i = 0; i < widget.vehiclelist.length; i++) {
          if (widget.vehiclelist[i].vehicleRegNo == itemValue) {
            _selectedItemslist.add(VehiclesDetail(
                vsrNo: widget.vehiclelist[i].vsrNo,
                vehicleRegNo: widget.vehiclelist[i].vehicleRegNo));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist
            .removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);
    for (int i = 0; i < _selectedItemslist.length; i++) {
      print("selected list : ${_selectedItemslist[i].vehicleRegNo}");
    }


    Navigator.pop(context, {
      "VehicleList": _selectedItems,
      "VehicleListDemo": _selectedItemslist,
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
                    onChanged: (isChecked) {
                      _itemChange(item.vehicleno, isChecked!);
                    } ,
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


class VehicleList{
  late String vehicleno;
  late bool vehicleselected;

  VehicleList({required this.vehicleno,required this.vehicleselected});
}
