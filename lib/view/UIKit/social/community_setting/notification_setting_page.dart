import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/notification_setting_comment_page.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/notification_setting_post.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import AmityCommunity here

class NotificationSettingPage extends StatefulWidget {
  // Assuming AmityCommunity has been defined elsewhere in your codebase
  final AmityCommunity community;

  const NotificationSettingPage({Key? key, required this.community})
      : super(key: key);

  @override
  _NotificationSettingPageState createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Provider.of<AmityUIConfiguration>(context).titleTextStyle
          .copyWith(
                  color: Color(0xff998455),
                  fontWeight: FontWeight.w800,
                  fontSize: 20
                ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Color(0xff998455)
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xFF292C45),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Section 1: Allow Notification
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Allow Notification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text(
              'Turn on to receive push notification from this community',
              style: TextStyle(color: Colors.white38),
            ),
            trailing: Switch(
              activeColor: Color(0xff3DDAB4),
              value: isNotificationEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationEnabled = value;
                });
              },
            ),
          ),
          const Divider(
            color: Color(0xff998455),
          ),

          // Section 2: Post and Comment

          !isNotificationEnabled
              ? const SizedBox()
              : Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(
                            8), // Adjust padding to your need
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust radius to your need
                          color: Color(0xff998455), // Choose the color to fit your design
                        ),
                        child: const Icon(Icons.newspaper_outlined,
                            color: Color(0xFF292C45)),
                      ), // You may want to replace with your icon
                      title: const Text('Posts',style: TextStyle(color: Colors.white),),
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xff3DDAB4)),
                      onTap: () {
                        // Navigate to post settings page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PostNotificationSettingPage(
                                community: widget.community)));
                      },
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(
                            8), // Adjust padding to your need
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              4), // Adjust radius to your need
                          color: Color(0xff998455), // Choose the color to fit your design
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outlined,
                          color: Color(0xFF292C45),
                        ),
                      ), // You may want to replace with your icon
                      title: const Text('Comments',style: TextStyle(color: Colors.white),),
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xff3DDAB4)),
                      onTap: () {
                        // Navigate to comment settings page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CommentsNotificationSettingPage(
                                    community: widget.community)));
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
