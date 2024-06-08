// ignore_for_file: use_build_context_synchronously

// import 'dart:js';

import 'package:customer/api/api_value.dart';
// import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

// ignore_for_file: avoid_print

Future enableUser(String userId) async {
  io.Socket socket = io.io(baseUrl,
      OptionBuilder().setTransports(['websocket']).build());
  socket.connect();
  socket.onConnect((data) async {
    socket.emit("ENABLE_USER", userId);
    print('user enabled');
  });
  socket.on(
    "ENABLED_USER",
    ((data) async {
      print(data);
      return await data;
    }),
  );
}



