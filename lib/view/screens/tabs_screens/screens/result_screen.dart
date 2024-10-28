import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/view/screens/popular_food/widget/popular_food_widget.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/filter_screen.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Result'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSearchAndFilter(),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: maincolor),
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: const Center(
                    child: Text('Burger',style: TextStyle(fontSize: 16,color: maincolor,fontWeight: FontWeight.w400),),
                  ),
                ),
                  Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: maincolor),
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: const Center(
                    child: Text('price from 100 to 200',style: TextStyle(fontSize: 16,color: maincolor,fontWeight: FontWeight.w400),),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 230
                        ),
                        itemCount: foodItems.length,
                        itemBuilder: (context, index) {
              return const FoodCard(
                name: 'Big Burger',
                  description: 'Juicy grilled beef patty with fresh lettuce and tomatoes.',
                  image: 'assets/images/medium.png',
                  price: 50.0,
              );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          backgroundColor: maincolor,
          child: IconButton(
            icon: SvgPicture.asset('assets/images/filter.svg'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FilterScreen()));
            },
          ),
        ),
      ],
    );
  }
}

