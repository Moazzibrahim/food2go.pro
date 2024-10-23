import 'package:flutter/material.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'profile'),
    );
  }
}
