// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/offer/offer_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/models/offer/offer_model.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/points_card.dart';

class PointsItemsScreen extends StatefulWidget {
  const PointsItemsScreen({super.key});

  @override
  _PointsItemsScreenState createState() => _PointsItemsScreenState();
}

class _PointsItemsScreenState extends State<PointsItemsScreen> {
  late Future<List<Offer>> offers;

  @override
  void initState() {
    super.initState();
    offers = fetchOffers(context);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<GetProfileProvider>(context);
    final int mypoints = profileProvider.userProfile?.points ?? 0;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Redeem points',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
          )),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 90.w,
                  height: 44.h,
                  margin: EdgeInsets.all(8.0.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mypoints.toString(),
                        style: TextStyle(
                          color: maincolor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      SvgPicture.asset(
                        'assets/images/coin.svg',
                        width: 16.w,
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Offer>>(
                future: offers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No offers available'));
                  } else {
                    final data = snapshot.data!;
                    return Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          childAspectRatio:
                              3 / 4, // Adjust aspect ratio as needed
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final offer = data[index];
                          return PointsCard(
                            image: 'assets/images/dealsandwich.png',
                            title: offer.product,
                            points: offer.points,
                            status: offer.points > mypoints ? 0 : 1,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
