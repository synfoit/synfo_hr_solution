import 'package:flutter/material.dart';

class Headers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Personimage(),
          ),
          const SizedBox(
            height: 10,
            width: 10,
          ),
        ],
      ),
    );
  }
}

class Personimage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = const AssetImage('assets/images/crm.png');
    Image image = Image(
      image: assetImage,
      width: 200.0,
      height: 150.0,
    );
    return Container(
      child: image,
    );
  }
}
