import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/delivery/profile_delivery_provider.dart';
import '../../controllers/Auth/login_provider.dart';

class ProfileDeliveryScreen extends StatefulWidget {
  const ProfileDeliveryScreen({Key? key}) : super(key: key);

  @override
  _ProfileDeliveryScreenState createState() => _ProfileDeliveryScreenState();
}

class _ProfileDeliveryScreenState extends State<ProfileDeliveryScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<DeliveryUserProvider>(context, listen: false)
          .fetchUserData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final deliveryUserProvider = Provider.of<DeliveryUserProvider>(context);
    final user = deliveryUserProvider.user;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: deliveryUserProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : user != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Personal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: user.imageLink != null
                                ? NetworkImage(user.imageLink)
                                : const AssetImage('assets/profile_picture.jpg')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(user.firstName),
                      _buildTextField(user.email),
                      _buildTextField(user.phone),
                      const SizedBox(height: 30),
                      _buildOptionsCard(context),
                    ],
                  )
                : const Center(child: Text("No user data available")),
      ),
    );
  }

  Widget _buildTextField(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildOption(Icons.logout, 'Log Out', () {
            Provider.of<LoginProvider>(context, listen: false).logout(context);
          }),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
