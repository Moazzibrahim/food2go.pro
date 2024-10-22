import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key, required this.image, required this.title, required this.subtitle, required this.points, required this.status});
  final String image;
  final String title;
  final String subtitle;
  final int points;
  final int status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(image),
                ],
              ),
              const SizedBox(height: 5,),
              Text(title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
              const SizedBox(height: 5,),
              Text(subtitle,style: const TextStyle(fontSize: 11,color: Colors.grey),),
              const SizedBox(height: 5,),
              Container(
                height: 21,
                width: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: maincolor),
                  borderRadius: BorderRadius.circular(4),
                  color: status == 0 ? Colors.white : maincolor
                ),
                child: Center(child: Text('150 PTS',style: TextStyle(color: status == 0 ? maincolor : Colors.white,fontSize: 11),)),
              ),
            ],
          ),
        ),
          status == 0 ? Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: maincolor
                  ),
                  child: const Center(
                    child: Text('Unavailable Now',style: TextStyle(color: Colors.white,fontSize: 12),),
                  ),
                ),
                const SizedBox(height: 75,)
              ],
            ),
          ),
        ) : const SizedBox()
      ],
    );
  }
}