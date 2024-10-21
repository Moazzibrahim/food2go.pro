import 'package:flutter/material.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: buildAppBar(context, 'Category'),
    );
  }
}