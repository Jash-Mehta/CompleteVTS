import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:http/http.dart' as http;


class DropDownScreen extends StatelessWidget {
  String token;
  DropDownScreen({Key? key,required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JsonSpinner(token: token,);
  }
}


class JsonSpinner extends StatefulWidget {
  String token;

  JsonSpinner({Key? key,required this.token}) : super(key: key);

  @override
  _JsonSpinnerState createState() => _JsonSpinnerState();
}

class _JsonSpinnerState extends State<JsonSpinner> {
  // String selectedSpinnerItem = 'Eliseo@gardner.biz';
  String selectedSpinnerItem = '';

  List data = [];
  late Future<String> myFuture;
  final String uri = 'https://jsonplaceholder.typicode.com/comments?postId=1';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  /*  myFuture =*/
    // fetchData();
    getvendorname();
  }

  @override
  Widget build(BuildContext context) {
    return /*FutureBuilder<String>(
        future: myFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return *//*Scaffold(
            body: */data.length==0 ? CircularProgressIndicator() :Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton(
                          items: data.map((item) {
                            return DropdownMenuItem(
                              child: Text(item['vendorName']),
                              value: item['vendorName'],
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              selectedSpinnerItem = newVal.toString();
                            });
                          },
                          value: selectedSpinnerItem,
                        ),
                      ),
                      Text(
                        'Selected Item = ' + '$selectedSpinnerItem',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ]));
          // );
      /*  }
        );*/

  }



  Future<String> fetchData() async {
    var response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var res = await http
          .get(Uri.parse(uri), headers: {"Accept": "application/json"});

      var resBody = json.decode(res.body);

      setState(() {
        selectedSpinnerItem=resBody[0]["email"];
        if(selectedSpinnerItem!=''){
         data = resBody;
        }
      });

      print('Loaded Successfully');

      return "Loaded Successfully";
    } else {
      throw Exception('Failed to load data.');
    }
  }


  Future<String> getvendorname() async {
    var response = await http.get(Uri.parse(Constant.vendorNameUrl),  headers: <String, String>{
      'Authorization': "Bearer ${widget.token}",
    },);
    if (response.statusCode == 200) {
      var res = await http.get(
        Uri.parse(Constant.vendorNameUrl),
        headers: <String, String>{
          'Authorization': "Bearer ${widget.token}",
        },
      );
      var resBody = json.decode(res.body);

      setState(() {

        selectedSpinnerItem=resBody[1]["vendorName"];
        if(selectedSpinnerItem!=''){
          data = resBody;
        }
      });

      print(resBody);

      return "Sucess";
    }else{
      throw Exception('Failed to load data.');
    }

  }




}













/*class VtsLiveScreen extends StatefulWidget {
  const VtsLiveScreen({Key? key}) : super(key: key);

  @override
  _VtsLiveScreenState createState() => _VtsLiveScreenState();
}

class _VtsLiveScreenState extends State<VtsLiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MH324365"),
      ),
      body: _vtsLiveScreen(),
    );
  }

  _vtsLiveScreen(){
    return SingleChildScrollView(
      child: Container(
        // color: Colors.red,
        // height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                child: Text("MH324365")
            ),

          ],
        ),
      ),
    );
  }
}*/
