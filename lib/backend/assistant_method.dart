// ignore_for_file: avoid_print

import 'package:customer/backend/request_assistant.dart';
import 'package:customer/module/direction_module.dart';
import 'package:customer/module_helper/app_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../module/direction_details_info.dart';

class AssistantMethod{

  static Future<String> searchAddressForGeographicCoOrdinates(Position  position, context) async{
    String humanReadable = '';
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var requestResponseValue = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponseValue == null){
      return humanReadable;
    }else{

      humanReadable = requestResponseValue['results'][0]['formatted_address'];
      Direction userPickUpAddress = Direction();

      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadable;

  

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocation(userPickUpAddress);

      return humanReadable;
    }

  }



  static obtainOriginToDestinationDirectionDetails(LatLng originalPosition, LatLng destinationPosition )async{

    print(originalPosition.longitude);

    print(originalPosition.longitude);
    // '
    //       https://maps.googleapis.com/maps/api/staticmap?key=YOUR_API_KEY&center=47.72459020306614,-122.4230673877157&zoom=12&format=png&maptype=roadmap&style=element:geometry%7Ccolor:0x242f3e&style=element:labels.text.fill%7Ccolor:0x746855&style=element:labels.text.stroke%7Ccolor:0x242f3e&style=feature:administrative.locality%7Celement:labels.text.fill%7Ccolor:0xd59563&style=feature:poi%7Celement:labels.text.fill%7Ccolor:0xd59563&style=feature:poi.park%7Celement:geometry%7Ccolor:0x263c3f&style=feature:poi.park%7Celement:labels.text.fill%7Ccolor:0x6b9a76&style=feature:road%7Celement:geometry%7Ccolor:0x38414e&style=feature:road%7Celement:geometry.stroke%7Ccolor:0x212a37&style=feature:road%7Celement:labels.text.fill%7Ccolor:0x9ca5b3&style=feature:road.highway%7Celement:geometry%7Ccolor:0x746855&style=feature:road.highway%7Celement:geometry.stroke%7Ccolor:0x1f2835&style=feature:road.highway%7Celement:labels.text.fill%7Ccolor:0xf3d19c&style=feature:transit%7Celement:geometry%7Ccolor:0x2f3948&style=feature:transit.station%7Celement:labels.text.fill%7Ccolor:0xd59563&style=feature:water%7Celement:geometry%7Ccolor:0x17263c&style=feature:water%7Celement:labels.text.fill%7Ccolor:0x515c6d&style=feature:water%7Celement:labels.text.stroke%7Ccolor:0x17263c&size=480x360
    //     '

    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originalPosition.latitude},${originalPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    print('3');
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    print('4');
    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();

    print('5');

    print(responseDirectionApi);
    print(responseDirectionApi['routes'][0]['overview_polyline']);
    print(responseDirectionApi['routes'][0]['legs'][0]);
    print(responseDirectionApi['routes'][0]['legs'][0]['duration']);

    //print(responseDirectionApi['routes'][0]['legs']['duration']['text']);

    directionDetailsInfo.ePoint = responseDirectionApi['routes'][0]['overview_polyline']['points'];
    print(directionDetailsInfo.ePoint);
    directionDetailsInfo.durationText = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];

    print(directionDetailsInfo.durationText);
    directionDetailsInfo.durationValue = responseDirectionApi['routes'][0]['legs'][0]['duration']['value'];

    print(directionDetailsInfo.durationValue);
    directionDetailsInfo.distanceValue = responseDirectionApi['routes'][0]['legs'][0]['distance']['value'];


    print(directionDetailsInfo.distanceValue);
    directionDetailsInfo.distanceText = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];


    print('6');



    print(directionDetailsInfo.distanceText);

    return directionDetailsInfo;

  }


}