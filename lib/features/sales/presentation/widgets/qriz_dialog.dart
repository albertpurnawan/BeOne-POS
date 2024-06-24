// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class QRIZDialog extends StatefulWidget {
//   final String base64;

//   const QRIZDialog({Key? key, required this.base64}) : super(key: key);

//   @override
//   State<QRIZDialog> createState() => _QRIZDialogState();
// }

// class _QRIZDialogState extends State<QRIZDialog> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.base64 == null) return Container();
//     Uint8List bytes = BASE64.decode(widget.base64);
//     return Scaffold(
//       appBar: AppBar(title: Text('Example App')),
//       body: ListTile(
//         leading: Image.memory(bytes),
//         title: Text(widget.base64),
//       ),
//     );
//   }
// }
