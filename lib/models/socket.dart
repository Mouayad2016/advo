import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static SocketService? _instance;
  dynamic socket;
  IO.Socket sockett() {
    final IO.Socket socket = IO.io(
        'http://192.168.1.49:8080',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({"userid": 1})
            .disableAutoConnect()
            // .setQuery({"token": jwt})
            // .setAuth({"token": jwt})
            .build());
    return socket;
  }

  SocketService._internal() {
    socket = sockett(); // assumes sockett is defined
    if (socket.disconnected) {
      socket.connect();
    }
  }

  factory SocketService() {
    _instance ??= SocketService._internal();
    return _instance!;
  }

  void doConnect(Function callback) {
    socket.off("response"); // remove old event listener
    socket.on("response", (data) {
      callback(data);
    });
  }
}
