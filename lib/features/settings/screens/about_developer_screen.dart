import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
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
  late final Map<String, dynamic> data;
  late String textToShow;
  late String profileUrl;
  int selectedIndex = 0;

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

  String secondButtonText() {
    if (selectedIndex == 0) return "Send mail";
    return "Go to Profile";
  }

  void setSelected(int index) {
    switch (index) {
      case 0:
        textToShow = data['mail']!;
        profileUrl = data['mail']!;
      case 1:
        textToShow = data['github_username']!;
        profileUrl = data['github']!;
      case 2:
        textToShow = data['linkedin_username']!;
        profileUrl = data['linkedin']!;
      case 3:
        textToShow = data['discord_username']!;
    }
    selectedIndex = index;
    setState(() {});
  }

  void _launchMailClient() async {
    String mailUrl = 'mailto:${data['mail']!}';
    try {
      await launchUrlString(mailUrl);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: data['mail']!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: getDeveloperInfo()
          ..then((value) {
            data = value;
            textToShow = data['mail']!;
            profileUrl = data['mail']!;
          }),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      data['name']!,
                      speed: const Duration(milliseconds: 100),
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  spacing: 8,
                  children: [
                    SocialWidget(
                      imagePath: "assets/images/gmail.png",
                      isSelected: selectedIndex == 0,
                      function: () {
                        setSelected(0);
                      },
                    ),
                    SocialWidget(
                      imagePath: isDarkMode
                          ? "assets/images/github_dark.png"
                          : "assets/images/github_light.png",
                      isSelected: selectedIndex == 1,
                      function: () {
                        setSelected(1);
                      },
                    ),
                    SocialWidget(
                      imagePath: "assets/images/linkedin.png",
                      isSelected: selectedIndex == 2,
                      function: () {
                        setSelected(2);
                      },
                    ),
                    SocialWidget(
                      imagePath: "assets/images/discord.png",
                      isSelected: selectedIndex == 3,
                      function: () {
                        setSelected(3);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        textToShow,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: textToShow));
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: const Text("Copy"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: selectedIndex == 3
                            ? null
                            : () {
                                if (selectedIndex == 0) {
                                  _launchMailClient();
                                } else {
                                  launchUrl(
                                    Uri.parse(profileUrl),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        child: Text(
                          secondButtonText(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SocialWidget extends StatefulWidget {
  const SocialWidget(
      {super.key,
      required this.imagePath,
      required this.function,
      required this.isSelected});

  final String imagePath;
  final bool isSelected;
  final VoidCallback function;

  @override
  State<SocialWidget> createState() => _SocialWidgetState();
}

class _SocialWidgetState extends State<SocialWidget>
    with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.05).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, 0), end: const Offset(0, -0.2))
              .animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.ease,
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.grey),
                ),
                backgroundColor: widget.isSelected
                    ? Theme.of(context).colorScheme.surfaceContainer
                    : null),
            onPressed: () {
              animationController.forward().whenComplete(() {
                animationController.reverse();
              });
              widget.function();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(widget.imagePath),
            ),
          ),
        ),
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
    required this.animaton,
  });

  final Image icon;
  final String text;
  final void Function() function;
  final Animation<double> animaton;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position:
          Tween<Offset>(begin: const Offset(-1.2, 0), end: const Offset(0, 0))
              .animate(animaton),
      child: SizedBox(
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
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
