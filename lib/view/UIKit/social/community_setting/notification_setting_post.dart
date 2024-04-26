import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ReactPostNotificationSetting { everyone, onlyModerator, off }

enum NewPostNotificationSetting { everyone, onlyModerator, off }

class PostNotificationSettingPage extends StatefulWidget {
  final AmityCommunity community;

  const PostNotificationSettingPage({Key? key, required this.community})
      : super(key: key);

  @override
  _PostNotificationSettingPageState createState() =>
      _PostNotificationSettingPageState();
}

class _PostNotificationSettingPageState
    extends State<PostNotificationSettingPage> {
  ReactPostNotificationSetting _reactPostSetting =
      ReactPostNotificationSetting.everyone;
  NewPostNotificationSetting _newPostSetting =
      NewPostNotificationSetting.everyone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E2034),
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(
            color: Color(0xff998455),
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          // Section 1: React Posts

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "React Posts",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
            child: Text(
              "Receive notifications when someone make a reaction to your posts in this community",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),

          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'Everyone',
            value: ReactPostNotificationSetting.everyone,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'Only Moderator',
            value: ReactPostNotificationSetting.onlyModerator,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<ReactPostNotificationSetting>(
            title: 'Off',
            value: ReactPostNotificationSetting.off,
            groupValue: _reactPostSetting,
            onChanged: (value) {
              setState(() {
                _reactPostSetting = value!;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              thickness: 1,
              color: Color(0xff998455),
            ),
          ),

          // Section 2: New Posts
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "React Posts",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16),
            child: Text(
              "Receive notifications when someone make a reaction to your posts in this community",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title: 'Everyone',
            value: NewPostNotificationSetting.everyone,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title: 'Only Moderator',
            value: NewPostNotificationSetting.onlyModerator,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          _buildRadioTile<NewPostNotificationSetting>(
            title: 'Off',
            value: NewPostNotificationSetting.off,
            groupValue: _newPostSetting,
            onChanged: (value) {
              setState(() {
                _newPostSetting = value!;
              });
            },
          ),
          const Divider(
            color: Color(0xff998455),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xff292B32),
        ),
      ),
    );
  }

  Widget _buildRadioTile<T>(
      {required String title,
      required T value,
      required T groupValue,
      required void Function(T?) onChanged}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white54,
        ),
      ),
      trailing: Radio<T>(
        activeColor: Color(0xff3DDAB4),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
