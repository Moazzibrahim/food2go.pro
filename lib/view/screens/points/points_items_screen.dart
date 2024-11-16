import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/offer/offer_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/widgets/points_card.dart';
import '../../../models/offer/offer_model.dart';
import '../checkout/code_checkout_screen.dart';
import '../tabs_screen.dart';

class PointsItemsScreen extends StatefulWidget {
  const PointsItemsScreen({super.key});

  @override
  _PointsItemsScreenState createState() => _PointsItemsScreenState();
}

class _PointsItemsScreenState extends State<PointsItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OfferProvider>(context, listen: false).fetchOffers(context);
    });
  }

  Future<void> handleOfferPress(Offer offer) async {
    showRedeemBottomSheet(context, offer);
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
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: maincolor,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TabsScreen()),
              );
            },
          ),
          title: const Center(
            child: Text(
              'Redeem points',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24),
            ),
          ),
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
              child: Consumer<OfferProvider>(
                builder: (context, offerProvider, child) {
                  if (offerProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (offerProvider.offers.isEmpty) {
                    return const Center(child: Text('No offers available'));
                  } else {
                    final data = offerProvider.offers;
                    return Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final offer = data[index];
                          return PointsCard(
                            image: offer.imageLink,
                            title: offer.product,
                            points: offer.points,
                            status: offer.points > mypoints ? 0 : 1,
                            onPressed: () => handleOfferPress(
                                offer), // Pass offer ID to the function
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

void showRedeemBottomSheet(BuildContext context, Offer offer) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: maincolor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Redeem In Restaurant?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan the code at a restaurant within 3 minutes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: maincolor,
                  ),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: maincolor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Perform the same logic as handleOfferPress
                    final response =
                        await Provider.of<OfferProvider>(context, listen: false)
                            .buyOffer(context, offer.id);

                    final refNumber = response['ref_number'].toString();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CodeCheckoutScreen(
                          refNumber: refNumber,
                          title: offer.product, // Pass offer title
                          image: offer.imageLink, // Pass offer image
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: Colors.black26,
                  ),
                  icon: const Icon(
                    Icons.redeem,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Redeem',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
