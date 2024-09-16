import '../../GlobalComponents/GlobalPackages.dart';

import 'constants.dart';

// local virtual login
Future<void> login({
  required String userID,
  required String userName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheUserIDKey, userID);

  currentUser.id = userID;
  currentUser.name = 'user_$userID';
}

// local virtual logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(cacheUserIDKey);
}

// on user login
void onUserLogin() {
  //initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: Statics.appID,
    appSign: Statics.appSign,
    userID: currentUser.id,
    userName: currentUser.name,
    plugins: [
      ZegoUIKitSignalingPlugin(),
    ],
    ringtoneConfig: ZegoRingtoneConfig(
      incomingCallPath: "assets/offline_invitation.mp3",
      outgoingCallPath: "assets/ringtone/outgoingCallRingtone.mp3",
    ),
    notificationConfig: ZegoCallInvitationNotificationConfig(
      androidNotificationConfig: ZegoCallAndroidNotificationConfig(
        showFullScreen: true,
        vibrate: true,
        messageVibrate: true,
        fullScreenBackground: 'assets/image/call.png',
        channelID: "ZegoUIKit",
        channelName: "Call Notifications",
        sound: "assets/offline_invitation.mp3",
        icon: "call",
      ),
      iOSNotificationConfig: ZegoCallIOSNotificationConfig(
        systemCallingIconName: 'CallKitIcon',
      ),
    ),
    requireConfig: (ZegoCallInvitationData data) {
      final config = (data.invitees.length > 1)
          ? ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
          : ZegoCallType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

      config.avatarBuilder = GlobalFunction().customAvatarBuilder;

      // support minimizing, show minimizing button
      config.topMenuBar.isVisible = true;
      config.topMenuBar.buttons
          .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

      return config;
    },
  );
}

// on user logout
void onUserLogout() {
  //  de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}
