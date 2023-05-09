import 'package:flutter/material.dart';

import '../../config/palette.dart';
import '../config/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  String title;
  int leadcount=0;
  GlobalKey<ScaffoldState> scaffoldKey;
 // CustomAppBar(this.title);
   CustomAppBar({Key? key, required this.title,required this.scaffoldKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.backgroundColor,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Constants.deepGreen,
        ), onPressed: () { scaffoldKey.currentState?.openDrawer(); },
      ),

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


}

