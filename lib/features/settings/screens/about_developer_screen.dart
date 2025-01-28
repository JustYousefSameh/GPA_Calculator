import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_calculator/core/failure.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutDevloperScreen extends StatefulWidget {
  const AboutDevloperScreen({super.key});

  @override
  State<AboutDevloperScreen> createState() => _AboutDevloperScreenState();
}

class _AboutDevloperScreenState extends State<AboutDevloperScreen>
    with SingleTickerProviderStateMixin {
  final Size buttonSize = const Size(60, 60);
  late final AnimationController animationController;

  Future<Map<String, dynamic>> getDeveloperInfo() async {
    var data = await http.get(
      Uri.parse(
        "https://gist.githubusercontent.com/JustYousefSameh/3e529c0112489ca14590f6b8281988f0/raw/",
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (data.statusCode == 200) {
      final decoded = jsonDecode(data.body);
      return decoded;
    } else {
      throw Failure("Failed to load data");
    }
  }

  void _launchMailClient(String targetEmail) async {
    String mailUrl = 'mailto:$targetEmail';
    try {
      await launchUrlString(mailUrl);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: targetEmail));
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: getDeveloperInfo()..then((_) => animationController.forward()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load data"));
          } else {
            final data = snapshot.data!;
            return SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: animationController,
                        curve: Curves.bounceOut,
                      ),
                      child: Text(
                        data["name"],
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "Software enginner",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      spacing: 8,
                      children: [
                        InfoCard(
                          icon:
                              Image.asset('assets/images/gmail.png', width: 40),
                          text: data['mail'],
                          function: () {
                            _launchMailClient(data['mail']);
                          },
                        ),
                        InfoCard(
                            icon: Image.asset('assets/images/discord.png',
                                width: 40),
                            text: data['discord'],
                            function: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: data['discord']));
                            }),
                        InfoCard(
                          icon: isDarkMode
                              ? Image.asset('assets/images/github_dark.png',
                                  width: 40)
                              : Image.asset('assets/images/github_light.png',
                                  width: 40),
                          text: 'JustYousefSameh',
                          function: () {
                            launchUrl(Uri.parse(data['github']));
                          },
                        ),
                        InfoCard(
                          icon: Image.asset('assets/images/linkedin.png',
                              width: 40),
                          text: 'Yousef Sameh',
                          function: () {
                            launchUrl(Uri.parse(data['linkedin']));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.text,
    required this.function,
  });

  final Image icon;
  final String text;
  final void Function() function;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: Theme.of(context).textTheme.labelMedium!.color,
        ),
        onPressed: function,
        child: Row(
          spacing: 12,
          children: [
            icon,
            Text(
              text,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
