import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart'; // Import the file opener package

Future<void> downloadAndOpenStatement({
  required BuildContext context,
  required String url,
  required String fileName,
}) async {
  final Dio dio = Dio();

  try {
    // 1. Get safe Application Directory (works 100% on Simulators & Real Devices)
    final Directory storageDir = await getApplicationDocumentsDirectory();
    final String savePath = "${storageDir.path}/$fileName.pdf";

    // 2. Clear out any previous version if it exists
    final File existingFile = File(savePath);
    if (await existingFile.exists()) {
      await existingFile.delete();
    }

    // 3. Download the fresh PDF bytes natively via Dio
    await dio.download(url, savePath);

    // 4. THE DIRECT LINK: Force the OS to natively open the file right now
    final result = await OpenFilex.open(savePath);

    // Optional error logging if the device fails to run the file handler
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloaded, but could not open file: ${result.message}")),
      );
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Download failed: $e"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}