import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gpa_calculator/core/common/loader.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:http/http.dart' as http;

class AboutDevloperScreen extends StatelessWidget {
  const AboutDevloperScreen({super.key});

  Future<Map<String, dynamic>> getDeveloperInfo() async {
    print("a");
    var data = await http.get(
      Uri.parse(
        "https://gist.githubusercontent.com/JustYousefSameh/3e529c0112489ca14590f6b8281988f0/raw/",
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (data.statusCode == 200) {
      print(data.body);
      final decoded = jsonDecode(data.body);
      print(decoded["name"]);
      return decoded;
    } else {
      throw Failure("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getDeveloperInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else if (snapshot.hasError) {
              return Center(child: Text("Failed to load data"));
            } else {
              final data = snapshot.data!;
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(data["name"]),
                    Text(data["mail"]),
                    Text(data["github"]),
                    Text(data["linkedin"]),
                    Text(data["discord"]),
                  ],
                ),
              );
            }
          }),
    );
  }
}
