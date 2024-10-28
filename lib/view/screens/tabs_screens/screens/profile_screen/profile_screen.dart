import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/Auth/login_screen.dart';
import 'package:food2go_app/view/screens/order_tracing_screen.dart';
import 'package:provider/provider.dart';
import 'address_screen.dart';
import 'personal_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user profile when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProfileProvider>(context, listen: false)
          .fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<GetProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Profile')),
        automaticallyImplyLeading: false,
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileProvider.userProfile == null
              ? const Center(child: Text("Failed to load profile data"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Display profile information
                      Text(
                        'Welcome, ${profileProvider.userProfile!.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileOption(
                        icon: Icons.person_outline,
                        label: 'Personal Info',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalInfo(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.location_on_outlined,
                        label: 'Addresses',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Order Tracking',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderTrackingScreen(),
                            ),
                          );
                        },
                      ),
                      _buildProfileOption(
                        icon: Icons.logout,
                        label: 'Log Out',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(icon, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[700], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
