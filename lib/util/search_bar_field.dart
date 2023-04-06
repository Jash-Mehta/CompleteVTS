import 'package:flutter/material.dart';
import 'package:flutter_vts/model/searchString.dart';

import 'MyColor.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen(
      {Key? key,
      required this.searchStrClass,
      required this.controller,
      required this.onChanged})
      : super(key: key);
  final SearchStringClass searchStrClass;
  final TextEditingController controller;
  final Function(String) onChanged;
  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  // This list holds the data for the list view
  SearchStringClass searchStrClass = SearchStringClass(searchStr: '');
  TextEditingController searchController = TextEditingController();

  String str = '';

  @override
  initState() {
    super.initState();
    if (str == '' || str.isEmpty) {
      str = searchStrClass.searchStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLength: 150,
          controller: widget.controller,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  widget.onChanged;
                }),
            // prefixIcon: IconButton(icon:const Icon(Icons.clear), onPressed: () {
            //
            //   widget.controller.clear() ;
            // }
            //  ),
            hintText: "Search Here",
            filled: true,
            fillColor: MyColors.whiteColorCode,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide:
                  BorderSide(width: 2, color: MyColors.blueChartColorCode),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              // borderSide: BorderSide(width: 2,)
            ),
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  onSearchTextChanged(String? text) async {
    if (text!.isEmpty) {
      setState(() {
        searchStrClass.searchStr = '';
      });
      return;
    } else {
      setState(() {
        searchStrClass.searchStr = text;
      });
    }
  }
}
