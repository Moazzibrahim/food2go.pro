import 'package:flutter/material.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/points_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class PointsItemsScreen extends StatelessWidget {
  const PointsItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<PointsDataFake> data = [
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 1,
          points: 150),
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 0,
          points: 150),
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 1,
          points: 150),
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 0,
          points: 150),
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 1,
          points: 150),
      PointsDataFake(
          image: 'assets/images/pasta.png',
          title: 'Free Pasta',
          subtitle: 'Pasta, Basil, Cheese',
          status: 1,
          points: 150),
    ];
    return Scaffold(
      appBar: buildAppBar(context, 'Redeams points'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return PointsCard(
              image: data[index].image,
              title: data[index].title,
              subtitle: data[index].subtitle,
              points: data[index].points,
              status: data[index].status,
            );
          },
        ),
      ),
    );
  }
}

class PointsDataFake {
  final String image;
  final String title;
  final String subtitle;
  final int status;
  final int points;

  PointsDataFake(
      {required this.image,
      required this.title,
      required this.subtitle,
      required this.status,
      required this.points});
}
