//
// Created by 1 More Code on 20/11/24.
//

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:selectable/helper/shared_preferences_helper.dart';

import '../../helper/global_data.dart';
import '../../main.dart';
import '../../provider/auth_provider.dart';
import '../widgets/custom_widgets.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late String photoUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    photoUrl = PreferencesHelper.getUser()['photoUrl'];
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthService>(
      builder: (context, authService, child) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: colorScheme.onSurface, width: 4),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(photoUrl))),
                    ),
                    if (authService.isPhotoLoading)
                      const CupertinoActivityIndicator()
                    else
                      CupertinoButton(
                        onPressed: () {
                          pickImageFromGallery(context);
                        },
                        borderRadius: BorderRadius.circular(50),
                        padding: const EdgeInsets.all(5),
                        color: colorScheme.onSurface.withOpacity(0.5),
                        minSize: 20,
                        child: Icon(
                          Icons.edit_outlined,
                          color: colorScheme.onSecondary,
                        ),
                      )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            getFieldTitle("Display Name *", context),
            CupertinoTextField(
              controller: authService.nameController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              placeholder: "Enter Full Name",
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(
              height: 16,
            ),
            getFieldTitle("Phone *", context),
            CupertinoTextField(
              controller: authService.phoneController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              placeholder: "Enter Phone Number",
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    child: CupertinoButton(
                  color: colorScheme.primary,
                  onPressed: authService.isUpdateLoading
                      ? null
                      : () async {
                    FocusScope.of(context).unfocus();
                    await authService.updateProfile({
                      "name": authService.nameController.text,
                      "phone": authService.phoneController.text,
                      "photoUrl": photoUrl
                    });
                  },
                  child: authService.isUpdateLoading
                      ? const CupertinoActivityIndicator()
                      : const Text('Update'),
                ))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  pickImageFromGallery(context) async {
    try {
      var provider = Provider.of<AuthService>(context, listen: false);
      bool status = await checkPermission(Permission.storage);
      if (status) {
        File? ff = await captureImage(ImageSource.gallery, context);
        if (ff != null) {
          String? url = await provider.updatePhoto(file: ff);
          logger.e(url);
          if (url != null && url.isNotEmpty) {
            setState(() {
              photoUrl = url;
            });
          }
        }
      } else {
        /// Open Setting
      }
      return null;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
