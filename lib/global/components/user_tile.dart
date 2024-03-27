import 'package:chat_app/global/utils/constant_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.onTap,
    required this.text,
  });
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ConstantHelper.sizex20),
        margin:  EdgeInsets.symmetric(vertical: ConstantHelper.sizex08, horizontal: ConstantHelper.sizex20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(ConstantHelper.sizex12)),
        child: Row(
          children: [
            // icon user
            Padding(
              padding:  EdgeInsets.all(ConstantHelper.sizex08),
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
             SizedBox(width: ConstantHelper.sizex20),
            // text
            Padding(
              padding:  EdgeInsets.all(ConstantHelper.sizex08),
              child: Text(
                text,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
