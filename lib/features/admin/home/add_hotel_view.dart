import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

class AddHotelView extends StatefulWidget {
  const AddHotelView({super.key});

  @override
  _AddHotelViewScreenState createState() => _AddHotelViewScreenState();
}

class _AddHotelViewScreenState extends State<AddHotelView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _singleRoompriceController =
      TextEditingController();
  final TextEditingController _doubleRoompriceController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? _imagePath;
  List<String> imagesPath = ['', '', ''];
  File? file;
  String? coverUrl;
  String? image1;
  String? image2;
  String? image3;

  Future<String> uploadImageToFireStore(File image, String imageName) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://hotel-wave.appspot.com')
            .ref()
            .child('hotels/${DateTime.now().toIso8601String()}$imageName');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    coverUrl = await uploadImageToFireStore(file!, 'cover');
  }

  Future<void> _pickImages(int index) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagesPath[index] = pickedFile.path;
      });
    }
    if (index == 0) {
      image1 = await uploadImageToFireStore(File(imagesPath[index]), '$index');
    } else if (index == 1) {
      image2 = await uploadImageToFireStore(File(imagesPath[index]), '$index');
    } else {
      image3 = await uploadImageToFireStore(File(imagesPath[index]), '$index');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
          text: 'Add Hotel',
          onTap: () {
            if (formKey.currentState!.validate() && coverUrl != null) {
              var id = DateTime.now().toString();
              FirebaseFirestore.instance.collection("hotels").doc(id).set({
                "id": id,
                "name": _nameController.text,
                "location": _addressController.text,
                "contactNumber": _contactController.text,
                "email": _emailController.text,
                "cover": coverUrl,
                "description": _descController.text,
                "images": [image1, image2, image3],
                "rating": 4.0,
                "rooms": [
                  {
                    "id": "101",
                    "type": "Single Room",
                    "description": "Cozy single room with a comfortable bed",
                    "amenities": ["Wi-Fi", "TV", "Air Conditioning"],
                    "pricePerNight":
                        double.parse(_singleRoompriceController.text)
                  },
                  {
                    "id": "102",
                    "type": "Double Room",
                    "description": "Spacious double room with a king-sized bed",
                    "amenities": [
                      "Wi-Fi",
                      "TV",
                      "Air Conditioning",
                      "Mini Bar"
                    ],
                    "pricePerNight":
                        double.parse(_doubleRoompriceController.text)
                  }
                ],
                "reviews": [
                  {
                    "name": "Ahmed Ali",
                    "rate": 4.0,
                    "comment": "Great experience, friendly staff!"
                  },
                  {
                    "name": "Mohammed Ali",
                    "rate": 5.0,
                    "comment": "Absolutely loved my stay. Highly recommended!"
                  }
                ]
              });
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const Text('Cover'),
              const Gap(5),
              InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: _imagePath == null
                      ? BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : BoxDecoration(
                          border: Border.all(color: AppColors.shadeColor),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_imagePath!)))),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                ),
              ),
              const Gap(16),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => InkWell(
                      onTap: () {
                        _pickImages(index);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: imagesPath[index].isEmpty
                            ? BoxDecoration(
                                border: Border.all(color: AppColors.shadeColor),
                                borderRadius: BorderRadius.circular(10),
                              )
                            : BoxDecoration(
                                border: Border.all(color: AppColors.shadeColor),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(File(imagesPath[index])))),
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )),
              const Gap(16),
              const Text('Hotel Name'),
              const Gap(5),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Hotel Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Description'),
              const Gap(5),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(height: 16.0),
              const Text('Location'),
              const Gap(5),
              TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Location'),
              ),
              const SizedBox(height: 16.0),
              const Text('Contact Number'),
              const Gap(5),
              TextFormField(
                controller: _contactController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              const Text('Email'),
              const Gap(5),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '* Required';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Single Room Price'),
                        const Gap(5),
                        TextFormField(
                          controller: _singleRoompriceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '* Required';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'EX: 100'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Double Room Price'),
                        const Gap(5),
                        TextFormField(
                          controller: _doubleRoompriceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '* Required';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(hintText: 'eX: 200'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}
