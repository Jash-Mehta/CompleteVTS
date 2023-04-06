import 'package:flutter/material.dart';
import 'package:flutter_vts/screen/onboarding/explanation_data.dart';
import 'package:flutter_vts/util/MyColor.dart';



class ExplanationPage extends StatelessWidget {
  final ExplanationData data;
  ExplanationPage({required this.data});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
              child:Container(
                alignment: Alignment.center,
                height: 150,
                child: Text(data.title,textAlign: TextAlign.center,style: TextStyle(fontSize: 33,fontWeight: FontWeight.bold),)
           )
          ),
          Expanded(
            flex: 4,
            child: Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                child: Image.asset(data.localImageSrc,
                    // fit: BoxFit.fill,
                    width: 359,
                    // height: 200,
                    height: MediaQuery.of(context).size.height * 0.58,
                    alignment: Alignment.center)
            ),
          ),
          // Text("damini"),
          Expanded(
            child: Text(
              data.description,
              style: TextStyle(fontSize:20,color: MyColors.textColorCode),
              // style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            )
          ),
        ],
      ),
    );
  }
}

