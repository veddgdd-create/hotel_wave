import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:hotel_wave/features/auth/presentation/view/signin_view.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://hotel-wave.appspot.com',
  );
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  List labelName = ['First Name', 'Last Name'];

  List value = ["fname", "lname"];

  String? _imagePath;
  File? file;
  String? profileUrl;

  Future<String> uploadImageToFireStore(File image, String imageName) async {
    Reference ref = _storage.ref().child(
          'users/${_auth.currentUser!.uid}$imageName',
        );
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        file = File(pickedFile.path);
      });
    }
    profileUrl = await uploadImageToFireStore(file!, 'user');
    FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'image': profileUrl,
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              splashRadius: 25,
              icon: Icon(Icons.logout, color: AppColors.primary),
              onPressed: () {
                showDialog(
                  barrierColor: Colors.black.withOpacity(.7),
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: AppColors.accentColor,
                      title: Text(
                        'Are you want to logout?',
                        style: getTitleStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: getbodyStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.redColor,
                          ),
                          onPressed: () async {
                            await _auth.signOut().then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginView(),
                                ),
                                (route) => false,
                              );
                            });
                          },
                          child: Text(
                            'LOGOUT',
                            style: getbodyStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var userData = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.white,
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                radius: 60,
                                backgroundImage: (userData?['image'] != null)
                                    ? NetworkImage(userData?['image'])
                                    : (_imagePath != null)
                                        ? FileImage(File(_imagePath!))
                                            as ImageProvider
                                        : const AssetImage('assets/user.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await _pickImage();
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: AppColors.darkScaffoldbg,
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userData!['fname']} ${userData['lname']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTitleStyle(),
                              ),

                              // Text(
                              //   "@${userData['username']}",
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: getsmallStyle(),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.shadeColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.verified_user_rounded,
                                color: AppColors.primary,
                              ),
                              const Gap(10),
                              Text(
                                "Role : ${userData['role']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getTitleStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: AppColors.primary,
                              ),
                              const Gap(10),
                              Text(
                                "${userData['email']}",
                                style: getsmallStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Divider(color: AppColors.primary),
                    const Gap(10),
                    Row(
                      children: [
                        Text(
                          " Edit Information",
                          style: getTitleStyle(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: List.generate(
                        labelName.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.shadeColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                labelName[index],
                                style: getTitleStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      var con = TextEditingController(
                                        text: userData[value[index]]?.isEmpty ??
                                                true
                                            ? 'Not Added'
                                            : userData[value[index]],
                                      );
                                      var form = GlobalKey<FormState>();
                                      return SimpleDialog(
                                        backgroundColor:
                                            AppColors.darkScaffoldbg,
                                        alignment: Alignment.center,
                                        contentPadding: const EdgeInsets.all(
                                          10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        children: [
                                          Form(
                                            key: form,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Enter ${labelName[index]}',
                                                  style: getbodyStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                TextFormField(
                                                  controller: con,
                                                  // decoration: InputDecoration(
                                                  //     hintText: value[index]),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please Enter the ${labelName[index]}.';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 20),
                                                CustomButton(
                                                  text: 'EDIT',
                                                  onTap: () {
                                                    if (form.currentState!
                                                        .validate()) {
                                                      updateData(
                                                        value[index],
                                                        con.text,
                                                        userData,
                                                      );
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.mode_edit_outline_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Divider(color: AppColors.primary),
                    const Gap(10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.shadeColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Help Center',
                            style: getTitleStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.help_outline_sharp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateData(String key, value, userData) async {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      key: value,
    }, SetOptions(merge: true));
    if (key.compareTo('fname') == 0) {
      await user?.updateDisplayName(value + ' ' + userData['lname']);
    } else if (key.compareTo('lname') == 0) {
      await user?.updateDisplayName(userData['fname'] + ' ' + value);
    } else if (key.compareTo('email') == 0) {
      await user?.verifyBeforeUpdateEmail(value);
    } else if (key.compareTo('password') == 0) {
      await user?.updatePassword(value);
    }
  }
}
