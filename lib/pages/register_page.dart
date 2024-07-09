import 'dart:io';

import 'package:adda/consts.dart';
import 'package:adda/models/user_profile.dart';
import 'package:adda/services/alert_service.dart';
import 'package:adda/services/auth_service.dart';
import 'package:adda/services/database_service.dart';
import 'package:adda/services/media_service.dart';
import 'package:adda/services/navigation_service.dart';
import 'package:adda/services/storage_service.dart';
import 'package:adda/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late MediaService _mediaService;
  late AuthService _authService;
  late AlertService _alertService;
  late NavigationService _navigationService;
  late StorageService _storageService;
  late DatabaseService _databaseService;
  String? email, password, name;
  File? selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _storageService = _getIt.get<StorageService>();
    _databaseService = _getIt.get<DatabaseService>();
    _alertService = _getIt.get<AlertService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  //build UI

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          _headerText(),
          if (!isLoading) _registerForm(),
          if (!isLoading) _loginAccountLink(),
          if (isLoading)
            Expanded(
                child: Center(
              child: CircularProgressIndicator(),
            ))
        ],
      ),
    ));
  }

//header text

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  //register form

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pfpSelection(),
            CustomFormField(
                hintText: "Name",
                height: MediaQuery.sizeOf(context).height * 0.1,
                validationRegEx: NAME_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                }),
            CustomFormField(
                hintText: "Email",
                height: MediaQuery.sizeOf(context).height * 0.1,
                validationRegEx: EMAIL_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                }),
            CustomFormField(
                obscureText: true,
                hintText: "Password",
                height: MediaQuery.sizeOf(context).height * 0.1,
                validationRegEx: PASSWORD_VALIDATION_REGEX,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                }),
            _registerButton(),
          ],
        ),
      ),
    );
  }

// profile pic

  Widget _pfpSelection() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          selectedImage = file;
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  //register button

  // Widget _registerButton() {
  //   return SizedBox(
  //     width: MediaQuery.sizeOf(context).width,
  //     child: MaterialButton(
  //       onPressed: () async {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         try {
  //           if ((_registerFormKey.currentState?.validate() ?? false) &&
  //               selectedImage != null) {
  //             _registerFormKey.currentState?.save();
  //             bool result = await _authService.signup(email!, password!);
  //             if (result) {
  //               String? pfpURL = await _storageService.uploadUserPfp(
  //                   file: selectedImage!, uid: _authService.user!.uid);
  //               if (pfpURL != null) {
  //                 await _databaseService.createUserProfile(
  //                     userProfile: UserProfile(
  //                         uid: _authService.user!.uid,
  //                         name: name,
  //                         pfpURL: pfpURL));
  //                 _alertService.showToast(
  //                     text: "User registered successfully!", icon: Icons.check);
  //               }
  //             }
  //             print(result);
  //           }
  //         } catch (e) {
  //           print(e);
  //         }
  //         setState(() {
  //           isLoading = false;
  //         });
  //       },
  //       color: Theme.of(context).colorScheme.primary,
  //       child: Text(
  //         "Register",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }



  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState?.save();
              bool result = await _authService.signup(email!, password!);
              if (result) {
                String? pfpURL = await _storageService.uploadUserPfp(
                    file: selectedImage!, uid: _authService.user!.uid);
                if (pfpURL != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                      uid: _authService.user!.uid,
                      name: name,
                      pfpURL: pfpURL,
                    ),
                  );
                  _alertService.showToast(
                      text: "User registered successfully!", icon: Icons.check);
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed("/home");
                }
                else{
                  throw Exception("Unable to upload user profile picture");
                }
              }
              else{
                throw Exception("Unable to register user");
              }
            }




          } catch (e) {
            // _alertService.showToast(
            //     text: "An error occurred: $e", icon: Icons.error);
            _alertService.showToast(
                text: "Failed to register, Please try again", icon: Icons.error);
            print("Error: $e");
          }


          setState(() {
            isLoading = false;
          });
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  //create login account link

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text("Already have an account? "),
        GestureDetector(
            onTap: () {
              _navigationService.goBack();
            },
            child: Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.w800),
            ))
      ],
    ));
  }
}



