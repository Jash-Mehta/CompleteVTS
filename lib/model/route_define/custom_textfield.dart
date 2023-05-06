import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_webservice/places.dart';

import '../../util/MyColor.dart';

class CustomTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final Function(PlacesAutocompleteResponse) onTextChanged;

  CustomTextformfield({
    Key? key,
    required this.controller,
    required this.onTextChanged,
  }) : super(key: key);

  @override
  State<CustomTextformfield> createState() => _CustomTextformfieldState();
}

TextEditingController _waypointcontrollers = TextEditingController();
final _placesApiClient =
    GoogleMapsPlaces(apiKey: 'AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY');
List<Prediction> _predictions = [];
var textfiled;
bool customtextclicked = false;

class _CustomTextformfieldState extends State<CustomTextformfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onTap: () {},

          enabled: true,
          onEditingComplete: () {},
          onChanged: (value) async {
            if (value.isNotEmpty) {
              customtextclicked = true;
              setState(() {});
              PlacesAutocompleteResponse response =
                  await _placesApiClient.autocomplete(
                value,
                language: "en",
                types: [],
                components: [Component(Component.country, "IND")],
              );
              setState(() {
                _predictions = response.predictions;
              });
              widget.onTextChanged(response);
            } else {
              customtextclicked = false;
              setState(() {});
            }
          },
          controller: widget.controller,
          // to trigger disabledBorder
          decoration: InputDecoration(
            filled: true,
            fillColor: MyColors.whiteColorCode,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: MyColors.buttonColorCode),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.orange),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide:
                  BorderSide(width: 1, color: MyColors.textBoxBorderColorCode),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                    width: 1, color: MyColors.textBoxBorderColorCode)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 2, color: MyColors.buttonColorCode)),
            hintText: "Searchable Dropdown",
            hintStyle:
                TextStyle(fontSize: 16, color: MyColors.textFieldHintColorCode),
            errorText: "",
          ),
          // controller: _passwordController,
          // onChanged: _authenticationFormBloc.onPasswordChanged,
          obscureText: false,
        ),
        customtextclicked
            ? SizedBox(height: 150.0, child: _buildSuggestions())
            : SizedBox()
      ],
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _predictions.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            widget.controller.text = _predictions[index].description.toString();

            setState(() {
              customtextclicked = false;
            });
          },
          title: Text(_predictions[index].description.toString()),
        );
      },
    );
  }
}
