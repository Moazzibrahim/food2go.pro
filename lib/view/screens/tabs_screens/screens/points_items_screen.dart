import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/offer/offer_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/models/offer/offer_model.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/points_card.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class PointsItemsScreen extends StatefulWidget {
  const PointsItemsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

    return Scaffold(
      appBar: buildAppBar(context, 'Redeem points'),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 44,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mypoints.toString(),
                      style: const TextStyle(
                        color: maincolor,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/images/coin.svg'),
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
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
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
    );
  }
}
