import 'package:flutter/material.dart';

class ProfileDeliveryScreen extends StatelessWidget {
  const ProfileDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'Personal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/profile_picture.jpg'),
                ),
                SizedBox(width: 20),
                Text(
                  'Muhammad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildTextField('Muhammad'),
            _buildTextField('Amalghanm555@gmail.com'),
            _buildTextField('015685577745'),
            SizedBox(height: 30),
            _buildOptionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildOption(Icons.privacy_tip, 'Privacy Policy'),
          _buildOption(Icons.description, 'Terms of Service'),
          _buildOption(Icons.logout, 'Log Out'),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        // Handle tap events
      },
    );
  }
}
