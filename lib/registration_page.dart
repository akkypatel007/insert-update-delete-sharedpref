import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practical_test2/view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
import 'model.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  Uint8List? _profilePicture;
  String? _gender;
  XFile? _imageFile;

  Future<void> _saveImageToPrefs() async {
    if (_profilePicture != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(User.IMG_KEY, base64String(_profilePicture!));
    }
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Future<void> _selectProfilePicture() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile == null) {
      // User cancelled image selection
      return;
    }
    setState(() async {
      _imageFile = pickedFile;
      _profilePicture = await pickedFile.readAsBytes();
      await _saveImageToPrefs();
    });
  }

  Future<void> _takeProfilePicture() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile == null) {
      // User cancelled image selection
      return;
    }
    setState(() async {
      _imageFile = pickedFile;
      _profilePicture = await pickedFile.readAsBytes();
      await _saveImageToPrefs();
    });
  }

  bool _validateAndSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void _submitForm() {
    if (_validateAndSaveForm()) {
      User user = User(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        mobile: _mobileController.text,
        city: _cityController.text,
        state: _stateController.text,
        pincode: _pincodeController.text,
        gender: _gender,
        profilePicture: _profilePicture,
      );
      DatabaseHelper.addUser(user);
      print("++++${user.state}");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(
                    width: 159,
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your first name'
                          : null,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your last name' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email address' : null,
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(
                    width: 159,
                    child: TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10 digit mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(
                    width: 159,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: 'City'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your city' : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(
                    width: 159,
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(labelText: 'State'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your state' : null,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(
                    width: 159,
                    child: TextFormField(
                      controller: _pincodeController,
                      decoration: InputDecoration(labelText: 'Pincode'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your pincode';
                        } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                          return 'Please enter a valid 6 digit pincode';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Profile pic:-"),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select profile picture'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Text('Gallery'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await _selectProfilePicture();
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  GestureDetector(
                                    child: Text('Camera'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await _takeProfilePicture();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _profilePicture != null
                          ? MemoryImage(_profilePicture!)
                          : null,
                      child: _profilePicture == null
                          ? Icon(Icons.camera_alt, size: 50.0)
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Gender'),
              SizedBox(height: 8),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String?;
                      });
                    },
                  ),
                  Text('Male'),
                  SizedBox(width: 16),
                  Radio(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value as String?;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
