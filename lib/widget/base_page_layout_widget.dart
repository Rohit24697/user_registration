import 'package:flutter/material.dart';

class BasePageLayoutWidget extends StatelessWidget {
  const BasePageLayoutWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.cardBody,
  });

  final String title;
  final String subTitle;
  final Widget cardBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBBB3B),
        elevation: 0.0,
        // toolbarHeight: 15.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        // leading: const SizedBox.shrink(),
      ),
      body: SafeArea(child: Stack(alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(40)),
              color: Color(0xFFFBBB3B),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                Text(
                  subTitle,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                cardBody,
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}