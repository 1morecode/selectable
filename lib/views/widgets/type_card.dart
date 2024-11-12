
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/global_data.dart';


class TypeCard extends StatelessWidget {
  final Function onPressed;
  final String image;
  final Color borderColor;
  const TypeCard({super.key, required this.onPressed, required this.image, this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (){
        onPressed();
      },
      padding: const EdgeInsets.all(0),
      child: Container(
          height: size.width * 0.5 - 24,
          width: size.width * 0.5 - 24,
          decoration: BoxDecoration(
            // border: Border.all(color: borderColor, width: 2),
            // color: cs.onPrimary
            borderRadius: BorderRadius.circular(8),
          ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover
              )
          ),
        ),
      ),
    );
  }
}
