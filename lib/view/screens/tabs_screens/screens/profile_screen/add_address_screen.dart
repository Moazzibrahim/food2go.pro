import 'package:flutter/material.dart';
import 'package:food2go_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'Home';
  GoogleMapController? _mapController;

  LatLng _initialPosition = const LatLng(31.2001, 29.9187); // Default location
  LatLng _selectedPosition = const LatLng(31.2001, 29.9187);
  Set<Marker> _markers = {};
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace('AIzaSyDuPxES-ul4k6UU4MiME97aoWHpxRt7Www');
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _selectedPosition = _initialPosition;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_initialPosition),
    );

    await _getAddressFromLatLng(_initialPosition);
  }

  void _onMapTap(LatLng position) async {
    setState(() {
      _selectedPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: position,
          infoWindow: const InfoWindow(title: 'Selected Location'),
        ),
      };
    });
    await _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      String address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
      setState(() {
        addressController.text = address;
      });
    } catch (e) {
      addressController.text = 'Unable to get address';
    }
  }

  Future<void> _handleSearch(String query) async {
    var result = await googlePlace.autocomplete.get(
      query,
      components: [Component("country", "eg")],
    );

    if (result != null && result.predictions != null) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<void> _selectPlace(String placeId) async {
    final details = await googlePlace.details.get(placeId);
    if (details != null && details.result != null) {
      final location = details.result!.geometry!.location;
      if (location != null) {
        final lat = location.lat ?? 0.0;
        final lng = location.lng ?? 0.0;
        LatLng selectedLatLng = LatLng(lat, lng);

        _mapController?.animateCamera(CameraUpdate.newLatLng(selectedLatLng));
        setState(() {
          _markers.add(
            Marker(
              markerId: const MarkerId('searchLocation'),
              position: selectedLatLng,
              infoWindow: InfoWindow(title: details.result!.name),
            ),
          );
        });

        await _getAddressFromLatLng(selectedLatLng);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a place',
                  filled: true,
                  fillColor:
                      Colors.grey.shade100, // Background color for the field
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                    borderSide: BorderSide.none, // Removes the outline border
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _handleSearch(value);
                  } else {
                    setState(() => predictions.clear());
                  }
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GoogleMap(
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: _initialPosition,
                              zoom: 14,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            markers: _markers,
                            onTap: _onMapTap,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          hintText: 'Selected Address',
                          filled: true,
                          fillColor: Colors.grey.shade100, // Background color
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                            borderSide:
                                BorderSide.none, // Removes the outline border
                          ),
                        ),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(predictions[index].description ?? ""),
                            onTap: () {
                              _selectPlace(predictions[index].placeId!);
                              setState(() => predictions.clear());
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryButton(context, 'Home'),
                          _buildCategoryButton(context, 'Work'),
                          _buildCategoryButton(context, 'Other'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(context, 'Selection Zone',
                          isDropdown: true, isRequired: true),
                      const SizedBox(height: 16),
                      _buildTextField(context, 'Street', isRequired: true),
                      const SizedBox(height: 16),
                      _buildTextField(context, 'Building No.',
                          isRequired: true),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(context, 'Floor No',
                                  isRequired: true)),
                          const SizedBox(width: 16),
                          Expanded(
                              child: _buildTextField(context, 'Apartment',
                                  isRequired: true)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(context, 'Additional Data'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Form is valid; proceed with saving the address
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label) {
    final bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? maincolor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: maincolor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : maincolor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      {bool isDropdown = false, bool isRequired = false}) {
    if (isDropdown) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        items: ['Zone 1', 'Zone 2', 'Zone 3']
            .map((zone) => DropdownMenuItem(
                  value: zone,
                  child: Text(zone),
                ))
            .toList(),
        onChanged: (value) {},
        validator: isRequired
            ? (value) =>
                value == null || value.isEmpty ? 'This field is required' : null
            : null,
        style: const TextStyle(color: Colors.black87),
      );
    } else {
      return TextFormField(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: isRequired
            ? (value) =>
                value == null || value.isEmpty ? 'This field is required' : null
            : null,
      );
    }
  }
}
