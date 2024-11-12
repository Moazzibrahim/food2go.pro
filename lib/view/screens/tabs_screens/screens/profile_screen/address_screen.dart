import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/tabs_screens/screens/profile_screen/add_address_screen.dart';
import 'package:food2go_app/view/widgets/custom_appbar.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final token = loginProvider.token!;

      Provider.of<GetProfileProvider>(context, listen: false)
          .fetchUserProfile(context);
      Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profilesProvider = Provider.of<GetProfileProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final token = loginProvider.token!;

    return Scaffold(
      appBar: buildAppBar(context, 'Addresses'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage(profilesProvider.userProfile!.imageLink!),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profilesProvider.userProfile!.name!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      profilesProvider.userProfile!.bio!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: addressProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : addressProvider.errorMessage != null
                      ? Center(child: Text(addressProvider.errorMessage!))
                      : ListView.builder(
                          itemCount: addressProvider.addresses.length,
                          itemBuilder: (context, index) {
                            final address = addressProvider.addresses[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: _buildAddressCard(
                                context,
                                token: token,
                                icon: Icons.home,
                                title: address.type == 'work' ? 'Work' : 'Home',
                                address:
                                    '${address.zone.zone}, ${address.address}, ${address.street}, ${address.buildingNum}',
                                addressId: address.id,
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: maincolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAddressScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context,
      {required String token,
      required IconData icon,
      required String title,
      required String address,
      required int addressId}) {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: maincolor),
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Address'),
                  content: const Text(
                      'Are you sure you want to delete this address?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmDelete == true) {
                await addressProvider.deleteAddress(token, addressId);
              }
            },
          ),
        ],
      ),
    );
  }
}
