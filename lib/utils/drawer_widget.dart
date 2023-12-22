import 'package:flutter/material.dart';
import 'package:task_09/constants/dimension_resource.dart';

class DrawerWidget extends StatelessWidget {
  final String screenName;
  final IconData leadingIcon;

  final VoidCallback navigate;

  const DrawerWidget({
    required this.navigate,
    required this.leadingIcon,
    required this.screenName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DimensResource.D_10),
        child: ListTile(
          title: Text(screenName,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          leading: Icon(leadingIcon, color: Colors.red),
          onTap: navigate,
        ),
      ),
    );
  }
}
