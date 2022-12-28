import 'package:ekskul/constant/color.dart';
import 'package:flutter/material.dart';

class AnnouncementsDetail extends StatefulWidget {
  final String image;
  const AnnouncementsDetail({Key? key, required this.image}) : super(key: key);

  @override
  State<AnnouncementsDetail> createState() => _AnnouncementsDetailState();
}

class _AnnouncementsDetailState extends State<AnnouncementsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Announcements',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Image.asset(widget.image),
    );
  }
}
