import 'package:customer/backend/request_assistant.dart';
import 'package:customer/components/color.dart';
import 'package:customer/module/predicted_place.dart';
import 'package:flutter/material.dart';

import '../../components/sized.dart';
import '../../components/text_style.dart';
import '../../global/global.dart';
import '../../widget/place_prediction_tile.dart';

class SearchScreenDrop extends StatefulWidget {
  const SearchScreenDrop({Key? key}) : super(key: key);

  @override
  State<SearchScreenDrop> createState() =>
      _SearchScreenDropState();
}

class _SearchScreenDropState extends State<SearchScreenDrop> {


  List<PredictedPlace> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText)async{

    if(inputText.length > 1){
      String urlAutoCompleteSearch = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:IN';

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
      //print(responseAutoCompleteSearch['status']);

      if(responseAutoCompleteSearch['status'] == 'OK'){
        var placePredicationResponse = responseAutoCompleteSearch['predictions'];



        var placePredictionList = (placePredicationResponse as List).map((jsonData)=>PredictedPlace.fromJson(jsonData)).toList();



        setState((){
          placePredictedList = placePredictionList;
        });

        //print(placePredictedList);



        //print(placePredicationResponse);
      }


    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: backgroundColor,

      // appBar: AppBar(
      //   backgroundColor: ColorMedia.white,
      //   leading: IconButton(
      //       onPressed: (){},
      //       icon: Icon(
      //         Icons.arrow_back_rounded,
      //         color: ColorMedia.blue,
      //       ),
      //   ),
      // ),


      body: Column(
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius:  BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.white24,
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset:  Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
               const SizedBox(height: 35,),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: primaryColor,
                      ),
                    ),
                    Center(
                      child: Text('Search & Set DropOff Location',
                        style: TStyleMedia.whiteRoboto17Medium5,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    const SizedBox(width: 16,),
                    const Icon(Icons.adjust_outlined, color: primaryColor,),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                       decoration: BoxDecoration(
                         color: ColorMedia.greyLight,
                         borderRadius: const BorderRadius.all(Radius.circular(5))
                       ),
                        width: SizedMedia.widthDivide(context, 1.5),
                        height: SizedMedia.heightDivide(context, 18),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                         onChanged: (value){
                            findPlaceAutoCompleteSearch(value);
                         },
                         // controller: mobile,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorMedia.greyLight,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5, color: ColorMedia.green50)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.5, color: ColorMedia.greyLight)
                            ),
                            hintText: 'Search Dropdown Location',
                            hintStyle: TStyleMedia.blue20Roboto16Medium2,
                            contentPadding: const EdgeInsets.only(top: 5, left: 20),
                            hintMaxLines: 1,
                          ),
                          onSaved: (value){
                            
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          (placePredictedList.isNotEmpty) ?
          Expanded(
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index){

                // print(placePredictedList.length);
                // print(placePredictedList[index].placeId);
                // print(placePredictedList[index].mainText);
                // print(placePredictedList[index].secondaryText);
                  return PlacePredictionTileDesign(
                      predictedPlace : placePredictedList[index]
                  );
              },
              separatorBuilder: (context, index){
                return const Divider();
              },
              itemCount: placePredictedList.length)
          )
              : Container()
        ],
      ),
    );
  }
}
