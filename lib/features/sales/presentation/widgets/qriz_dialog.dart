// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// class QRIZDialog extends StatefulWidget {
//   final String base64;

//   const QRIZDialog({Key? key, required this.base64}) : super(key: key);

//   @override
//   State<QRIZDialog> createState() => _QRIZDialogState();
// }

// class _QRIZDialogState extends State<QRIZDialog> {
//   Uint8List base64Decode(String str) {
//     final decoder = base64.decoder;
//     return decoder.convert(str);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("QRIZ"),
//       ),
//       body: Center(
//         child: Container(
//           child: Image.memory(
//             base64Decode(widget.base64),
//             fit: BoxFit.contain, // Adjust as needed
//           ),
//         ),
//       ),
//     );
//   }
// }
