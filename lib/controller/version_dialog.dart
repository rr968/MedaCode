//app_version.php

import 'dart:developer';
import 'dart:io';

import '/controller/var.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Update Required"),
        content: const Text(
            "The app is closed for maintenance. Please update to continue."),
        actions: [
          ElevatedButton(
            onPressed: () async {
              String url = Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=com.example.yourapp"
                  : "https://apps.apple.com/app/id123456789"; // Replace with your app ID

              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                log("Could not launch URL");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: orange),
            child:
                const Text("Update Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
