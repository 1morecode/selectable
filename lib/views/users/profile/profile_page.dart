//
// Created by 1 More Code on 12/11/24.
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable/views/auth/edit_account.dart';
import 'package:selectable/views/users/bookings/my_bookings.dart';

import '../../../helper/global_data.dart';
import '../../../helper/shared_preferences_helper.dart';
import '../../../provider/auth_provider.dart';
import '../../../theme/app_state.dart';
import '../../widgets/custom_border_container.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<AuthService>(
      builder: (context, authProvider, child) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                CustomBorderedContainer(
                    child: SizedBox(
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
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
                                  image: CachedNetworkImageProvider(
                                      PreferencesHelper.getUser()[
                                          'photoUrl']))),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          PreferencesHelper.getUser()['name'],
                          style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          PreferencesHelper.getUser()['email'],
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )),
                CupertinoButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(color: colorScheme.primary),
                        )
                      ],
                    ),
                    onPressed: () {
                      authProvider.initUpdate();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditAccount(),
                          ));
                    })
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            // Consumer<AppState>(builder: (context, appState, child) {
            //   return CustomBorderedContainer(
            //       child: ListTile(
            //           contentPadding:
            //               const EdgeInsets.symmetric(horizontal: 10),
            //           title: Text(
            //             "Appearance",
            //             style: TextStyle(
            //               color: colorScheme.onSecondary,
            //             ),
            //           ),
            //           trailing: CupertinoSlidingSegmentedControl<bool>(
            //             children: {
            //               false: Text(
            //                 "Light",
            //                 style: TextStyle(
            //                     color: colorScheme.onSecondary.withOpacity(0.7),
            //                     fontSize: 16),
            //               ),
            //               true: Text(
            //                 "Dark",
            //                 style: TextStyle(
            //                     color: colorScheme.onSecondary.withOpacity(0.7),
            //                     fontSize: 16),
            //               ),
            //             },
            //             thumbColor: colorScheme.onPrimary,
            //             groupValue: appState.isDarkModeOn,
            //             onValueChanged: (bool? value) async {
            //               if (value != null) {
            //                 appState.toggleChangeTheme(value);
            //               }
            //             },
            //           )));
            // }),
            // const SizedBox(
            //   height: 16,
            // ),
            CustomBorderedContainer(
                child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                "Booking History",
                style: TextStyle(
                  color: colorScheme.onSecondary,
                ),
              ),
              leading: Icon(
                CupertinoIcons.doc_text,
                color: colorScheme.error,
              ),
              trailing: Icon(
                CupertinoIcons.right_chevron,
                color: colorScheme.error,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyBookings(),));
              },
            )),
            const SizedBox(
              height: 16,
            ),
            CustomBorderedContainer(
                child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: colorScheme.onSecondary,
                ),
              ),
              trailing: Icon(
                Icons.logout,
                color: colorScheme.error,
              ),
              onTap: () {
                authProvider.signOut();
              },
            )),
          ],
        ),
      ),
    );
  }
}
