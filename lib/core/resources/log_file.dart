import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class LogFile {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _getLogFile async {
    final path = await _localPath;
    log(path);
    return File('./pos_logger.txt');
  }

  static Future<File> write(String data) async {
    final file = await _getLogFile;
    // Write the file in append mode so it would append the data to
    //existing file
    return file.writeAsString('$data\n', mode: FileMode.append);
  }
}
