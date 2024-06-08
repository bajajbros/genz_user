import 'package:customer/backend/request_assistant.dart';
import 'package:customer/components/color.dart';
import 'package:customer/components/text_style.dart';
import 'package:customer/global/global.dart';
import 'package:customer/module/direction_module.dart';
import 'package:customer/module/predicted_place.dart';
import 'package:customer/module_helper/app_info.dart';
import 'package:customer/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class PlacePredictionTileDesign extends StatefulWidget {
  bool? disableTap = false;
  final PredictedPlace? predictedPlace;
   PlacePredictionTileDesign({Key? key, this.predictedPlace, this.disableTap})
      : super(key: key);

  @override
  State<PlacePredictionTileDesign> createState() =>
      _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, BuildContext context) async {
    // CustomText()
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Please Wait...',
                  style: TStyleMedia.whiteMohave18Medium0,
                )
              ],
            ),
          );
        });

    String placeDirectionDetails =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetails);

    Navigator.pop(context);

    if (responseApi['status'] == 'OK') {
      Direction direction = Direction();

      direction.locationName = responseApi['result']['name'];
      direction.locationId = placeId;
      direction.locationLatitude =
          responseApi['result']['geometry']['location']['lat'];
      direction.locationLongitude =
          responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false)
          .updateDropOffLocation(direction);

      Navigator.pop(context, 'obtainedDropOff');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.disableTap?? false ?null: () {
        print('Hello This funtion is caling');
       getPlaceDirectionDetails(widget.predictedPlace!.placeId, context);
      },
      leading: const CircleAvatar(
        backgroundColor: primaryColor,
        child: Center(
          child: Icon(
            Icons.location_on,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        widget.predictedPlace!.mainText!.isEmpty
            ? ''
            : widget.predictedPlace!.mainText!,
        style: TStyleMedia.whiteRoboto14Medium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.predictedPlace!.secondaryText!.isEmpty
            ? ''
            : widget.predictedPlace!.secondaryText!,
        style: TStyleMedia.white50Roboto11Medium2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class PlacePredictionTileDesignForPickup extends StatefulWidget {
  final PredictedPlace? predictedPlace;
  const PlacePredictionTileDesignForPickup({Key? key, this.predictedPlace})
      : super(key: key);

  @override
  State<PlacePredictionTileDesignForPickup> createState() =>
      _PlacePredictionTileDesignForPickupState();
}

class _PlacePredictionTileDesignForPickupState
    extends State<PlacePredictionTileDesignForPickup> {
  getPlaceDirectionDetails(String? placeId, BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              children: [
                CircularProgressIndicator(
                  color: primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'Please Wait...',
                  style: TStyleMedia.whiteMohave18Medium0,
                )
              ],
            ),
          );
        });

    String placeDirectionDetails =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi =
        await RequestAssistant.receiveRequest(placeDirectionDetails);

    Navigator.pop(context);

    if (responseApi['status'] == 'OK') {
      Direction direction = Direction();

      direction.locationName = responseApi['result']['name'];
      direction.locationId = placeId;
      direction.locationLatitude =
          responseApi['result']['geometry']['location']['lat'];
      direction.locationLongitude =
          responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false)
          .updatePickUpLocation(direction);

      Navigator.pop(context, 'obtainedDropOff');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('Hello This funtion is caling');
        getPlaceDirectionDetails(widget.predictedPlace!.placeId, context);
      },
      leading: const CircleAvatar(
        backgroundColor: primaryColor,
        child: Center(
          child: Icon(
            Icons.location_on,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        widget.predictedPlace!.mainText!.isEmpty
            ? ''
            : widget.predictedPlace!.mainText!,
        style: TStyleMedia.whiteRoboto14Medium,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.predictedPlace!.secondaryText!.isEmpty
            ? ''
            : widget.predictedPlace!.secondaryText!,
        style: TStyleMedia.white50Roboto11Medium2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
