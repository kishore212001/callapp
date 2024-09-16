import 'package:flutter/cupertino.dart';
import '../../GlobalComponents/GlobalPackages.dart';
import 'package:flutter/material.dart';

class GlobalFunction {
  //----Custom Avatar for calling page-----------//
  Widget customAvatarBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    return CachedNetworkImage(
      imageUrl: 'https://robohash.org/${user?.id}.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        ZegoLoggerService.logInfo(
          '$user avatar url is invalid',
          tag: 'live audio',
          subTag: 'live page',
        );
        return ZegoAvatar(user: user, avatarSize: size);
      },
    );
  }

  //-------------------Logout Button-------------//
  Widget logoutButton(context) {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20,
        color: Colors.white,
        onPressed: () async {
          await FirebaseService.removeUserModel();
          logout().then((value) {
            onUserLogout();
            Navigator.pushNamed(
              context,
              PageRouteNames.login,
            );
          });
        },
      ),
    );
  }
}
