import 'dart:io';


import 'package:firebase_authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_authentication/enum/categoryEnum.dart';
import 'package:firebase_authentication/models/Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Postadpage extends StatefulWidget {
  const Postadpage({super.key});

  @override
  PostadpageState createState() => PostadpageState();
}

class PostadpageState extends State<Postadpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool isNegotiable = false;
  Categoryenum? selectedCategory;
  List<File> selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        selectedImages = images.map((image) => File(image.path)).toList();
      });
    }
  }

  Future<File> _compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    '${file.parent.path}/compressed_${file.path.split('/').last}',
    quality: 70, // Adjust quality here to reduce file size (0-100)
  );

  return result ?? file; // Return the compressed file or original if compression fails
  }

  Future<void> _postAd() async {
    if (_formKey.currentState!.validate()) {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Upload images to Firebase Storage and get their URLs
        List<String> imageUrls = [];
        for (var imageFile in selectedImages) {

          final compressedImage = await _compressImage(imageFile);

          String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${compressedImage.path.split('/').last}';
          final storageRef = FirebaseStorage.instance.ref().child(fileName);
          
          // Upload the image
          await storageRef.putFile(compressedImage);
          
          //Get the download URL
          String downloadUrl = await storageRef.getDownloadURL();
          imageUrls.add(downloadUrl);

          
        }

        // Create an Item object with the entered details
        final item = {
          'itemName': _productNameController.text,
          'itemPrice': double.parse(_priceController.text),
          'itemLocation': _locationController.text,
          'itemDescription': '512 GB hard drive',
          'dateTime': DateTime.now().toIso8601String(),
          'itemCategory': selectedCategory?.displayTitle ?? 'Uncategorized',
          'itemImageURL': imageUrls,
          'isNegotiable': isNegotiable,
          'itemStock': 20,
          'itemRating': 4.5,
          'likes': 120,
          'views': 250,
          'reviews': ['Excellent!', 'Highly recommended.'],
          'user': {
            'name': 'Aashiq',
            'emailAddress': 'me@gmail.com',
            'location': 'Colombo',
            'phoneNumber': '0769744114'
          }
        };

        // Save the item to Firestore
        await FirebaseFirestore.instance.collection('items').add(item);

        // Close the loading indicator
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item posted successfully!')),
        );
      } catch (e) {
        Navigator.pop(context);
        print('Error posting item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post ad: $e')),
        );
      }
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an Ad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker Section
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: selectedImages.isEmpty
                      ? const Center(
                          child: Icon(Icons.add, size: 40, color: Colors.black54),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(selectedImages[index], fit: BoxFit.cover),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Product Name Field
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Location Field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Price Field
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Negotiable Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isNegotiable,
                    onChanged: (bool? value) {
                      setState(() {
                        isNegotiable = value ?? false;
                      });
                    },
                  ),
                  const Text('Negotiable'),
                ],
              ),
              const SizedBox(height: 16.0),

              // Category Dropdown
              DropdownButtonFormField<Categoryenum>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: selectedCategory,
                items: Categoryenum.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayTitle),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),

              // Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Post Ad Button
                  ElevatedButton(
                    onPressed: _postAd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Black background color
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text(
                      'Post Ad',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Cancel Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the page
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black), // Black border
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black), // Black text color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
