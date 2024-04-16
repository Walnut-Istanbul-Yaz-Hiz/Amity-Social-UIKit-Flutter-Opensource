import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/community_setting/posts/post_cpmponent.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/create_postV2_viewmodel.dart';
// import 'package:amity_uikit_beta_service/viewmodel/create_post_viewmodel.dart';
// import 'package:amity_uikit_beta_service/viewmodel/media_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmityCreatePostV2Screen extends StatefulWidget {
  final AmityCommunity? community;

  const AmityCreatePostV2Screen({
    super.key,
    this.community,
  });

  @override
  State<AmityCreatePostV2Screen> createState() =>
      _AmityCreatePostV2ScreenState();
}

class _AmityCreatePostV2ScreenState extends State<AmityCreatePostV2Screen> {
  bool hasContent = true;

  @override
  void initState() {
    Provider.of<CreatePostVMV2>(context, listen: false).inits();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CreatePostVMV2>(builder: (context, vm, _) {
      return Scaffold(
        backgroundColor: Color(0xff1E2034),
        appBar: AppBar(
          backgroundColor: Color(0xFF292C45),
          elevation: 0,
          title: Text(
            widget.community != null
                ? widget.community?.displayName ?? "Community"
                : "My Feed",
            style: Provider.of<AmityUIConfiguration>(context).titleTextStyle
            .copyWith(
              color: Color(0xff998455),
              fontWeight: FontWeight.w800,
              fontSize: 20
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Color(0xff998455),
            ),
            onPressed: () {
              if (hasContent) {
                ConfirmationDialog().show(
                  context: context,
                  title: 'Discard Post?',
                  detailText: 'Do you want to discard your post?',
                  leftButtonText: 'Cancel',
                  rightButtonText: 'Discard',
                  onConfirm: () {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: hasContent
                  ? () async {
                      if (vm.isUploadComplete) {
                        if (widget.community == null) {
                          //creat post in user Timeline
                          await vm.createPost(context,
                              callback: (isSuccess, error) {
                            if (isSuccess) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } else {}
                          });
                        } else {
                          //create post in Community
                          await vm.createPost(context,
                              communityId: widget.community?.communityId!,
                              callback: (isSuccess, error) {
                            if (isSuccess) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ChangeNotifierProvider(
                              //           create: (context) => CommuFeedVM(),
                              //           child: CommunityScreen(
                              //             isFromFeed: true,
                              //             community: widget.community!,
                              //           ),
                              //         )));
                            }
                          });
                        }
                      }
                    }
                  : null,
              child: Text("Post",
                  style: TextStyle(
                      color: vm.isPostValid
                          ? Color(0xff3DDAB4)
                          : Color(0xff998455))),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) => vm.updatePostValidity(),
                          controller: vm.textEditingController,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          style: TextStyle(color: Colors.white),
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write something to post",
                            hintStyle: TextStyle(color: Color(0xff3DDAB4))
                          ),
                          // style: t/1heme.textTheme.bodyText1.copyWith(color: Colors.grey),
                        ),
                        Consumer<CreatePostVMV2>(
                          builder: (context, vm, _) =>
                              PostMedia(files: vm.files),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Color(0xff998455),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconButton(
                      Icons.camera_alt_outlined,
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.image]!,
                      label: "Photo",
                      // debugingText:
                      //     "${vm2.isNotSelectVideoYet()}&& ${vm2.isNotSelectedFileYet()}",
                      onTap: () {
                        _handleCameraTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.image_outlined,
                      label: "Image",
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.image]!,
                      onTap: () async {
                        _handleImageTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.play_circle_outline,
                      label: "Video",
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.video]!,
                      onTap: () async {
                        _handleVideoTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.attach_file_outlined,
                      label: "File",
                      isEnable:
                          vm.availableFileSelectionOptions()[MyFileType.file]!,
                      onTap: () async {
                        _handleFileTap(context);
                      },
                    ),
                    _iconButton(
                      Icons.more_horiz,
                      isEnable: true,
                      label: "More",
                      onTap: () {
                        // TODO: Implement more options logic
                        _showMoreOptions(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _iconButton(IconData icon,
      {required String label,
      required VoidCallback onTap,
      required bool isEnable,
      String? debugingText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        debugingText == null ? const SizedBox() : Text(debugingText),
        CircleAvatar(
          radius: 26,
          backgroundColor: Color(0xff998455),
          child: IconButton(
            icon: Icon(
              icon,
              size: 24,
              color: isEnable ?  Color(0xff1E2034) : Colors.white54
            ),
            onPressed: () {
              if (isEnable) {
                onTap();
              }
            },
          ),
        ),
        // SizedBox(height: 4),
        // Text(label),
      ],
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0), // Space at the top
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: _iconButton(Icons.camera_alt_outlined,
                        isEnable: true, label: "Camera", onTap: () {}),
                    title: const Text('Camera',
                    style: TextStyle(
                        color: Color(0xff1E2034),
                      ),),
                    onTap: () {
                      _handleCameraTap(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: _iconButton(Icons.image_outlined,
                        isEnable: true, label: "Photo", onTap: () {}),
                    title: const Text('Photo',
                    style: TextStyle(
                        color: Color(0xff1E2034),
                      ),),
                    onTap: () {
                      _handleImageTap(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: _iconButton(Icons.attach_file_rounded,
                        isEnable: true, label: "Attachment", onTap: () {}),
                    title: const Text('Attachment',
                    style: TextStyle(
                        color: Color(0xff1E2034),
                      ),),
                    onTap: () {
                      _handleFileTap(context);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: _iconButton(Icons.play_circle_outline_outlined,
                        isEnable: true, label: "Video", onTap: () {}),
                    title: const Text('Video',
                      style: TextStyle(
                        color: Color(0xff1E2034),
                      ),
                    ),
                    onTap: () {
                      _handleVideoTap(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Post?'),
        content: const Text('Do you want to discard your post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop();
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCameraTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.cameraImage);
  }

  Future<void> _handleImageTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryImage);
  }

  Future<void> _handleVideoTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.galleryVideo);
  }

  Future<void> _handleFileTap(BuildContext context) async {
    await _pickMedia(context, PickerAction.filePicker);
  }

  Future<void> _pickMedia(BuildContext context, PickerAction action) async {
    var createPostVM = Provider.of<CreatePostVMV2>(context, listen: false);
    await createPostVM.pickFile(action);
  }
}
