import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'common_snackbar.dart';
import './dialog/edit_text_dialog.dart';
import './dialog/positive_dialog.dart';
import './dialog/progress_dialog_widget.dart';
import './dialog/dynamic_text_highlighting.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile.dart';
import 'package:amity_uikit_beta_service/components/message_edit.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key, required this.message, required this.onReplyTap})
      : super(key: key);
  final AmityMessage message;
  final ValueChanged<AmityMessage> onReplyTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1E2034),
      child: _getBody(context, message),
    );
  }

  Widget _getBody(BuildContext context, AmityMessage value) {
    final themeData = Theme.of(context);
    AmityUser user = value.user!;
    // String text = '';
    // bool notSupportedDataType = false;

    // bool isLikedByMe = value.myReactions?.isNotEmpty ?? false;

    // if (value.messageId == '631882bd09045c4fc8281a57') print(value.toString());

    if (value.reactions!.reactions != null &&
        value.reactions!.reactions!.isNotEmpty) {
      value.reactions!.reactions!.removeWhere((key, value) => value == 0);
    }

    // AmityMessageData? data = value.data;
    // if (data != null) {
    //   if (data is MessageTextData) text = data.text!;
    // } else {
    //   notSupportedDataType = true;
    // }

    if (value.isDeleted ?? false) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_rounded),
            const SizedBox(width: 12),
            Text(
              'Message has been deleted',
              style: themeData.textTheme.bodySmall,
            )
          ],
        ),
      );
    }

    return InkWell(
      onTap: () {
        // final Completer completer = Completer();
        // ProgressDialog.showCompleter(context, completer);

        // AmityChatClient.newMessageRepository()
        //     .getMessage(message.messageId!)
        //     .then((value) {
        //   completer.complete();
        //   PositiveDialog.show(context,
        //       title: 'Message View',
        //       message: value.toString().replaceAll(',', ', \n\n'));
        // }).onError((error, stackTrace) {
        //   completer.completeError(error!);
        //   CommonSnackbar.showNagativeSnackbar(
        //       context, 'Error', error.toString());
        // });
      },
      onLongPress: () {
        _reactionDialog(context, message);
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: message!.user!.userId! ==
                      AmityCoreClient.getCurrentUser().userId
                  ? Color(0xFF292C45)
                  : Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2)
              ],
            ),
            // color: Colors.red,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                              amityUser: AmityCoreClient.getCurrentUser(),
                              amityUserId: AmityCoreClient.getUserId(),
                            )));
                  },
                  child: AmityCoreClient.getUserId() != user.userId
                      ? Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(.3),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: user.avatarUrl != null
                              ? Image.network(
                                  user.avatarUrl!,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/images/user_placeholder.png',
                                  package: "amity_uikit_beta_service",
                                ),
                        )
                      : SizedBox(width: 0, height: 0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName!,
                        style: themeData.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff998455),
                        ),
                      ),
                      AmityMessageContentWidget(
                        amityMessage: message,
                      ),
                      // const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            DateFormat('dd-MM-yyyy HH:mm').format(
                                value.createdAt?.toLocal() ?? DateTime.now()),
                            style: themeData.textTheme.caption!.copyWith(
                              color: Color(0xff998455),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            value.syncState!.value.toUpperCase(),
                            style: themeData.textTheme.bodySmall!.copyWith(
                              color: Color(0xffF78F4C6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                      // Text(
                      //   'Message Id - ${value.messageId}',
                      //   style: themeData.textTheme.bodySmall!.copyWith(),
                      // ),
                      // if (value.myReactions != null &&
                      //     value.myReactions!.isNotEmpty)
                      // Text(
                      //   'My Reaction - ${value.myReactions?.join(',') ?? ' Null'}',
                      //   style: themeData.textTheme.bodySmall!.copyWith(),
                      // ),
                      // if (value.amityTags != null &&
                      //     value.amityTags!.tags!.isNotEmpty)
                      //   Text(
                      //     'Tags - ${value.amityTags?.tags?.join(',') ?? ' Null'}',
                      //     style: themeData.textTheme.bodySmall!.copyWith(),
                      //   ),
                      // if (value.metadata != null)
                      //   Text(
                      //     'Metadata - ${value.metadata?.toString() ?? ' Null'}',
                      //     style: themeData.textTheme.bodySmall!.copyWith(),
                      //   ),

                      // if (value.parentId != null)
                      //   Text(
                      //     'PreantID - ${value.parentId?.toString() ?? ' Null'}',
                      //     style: themeData.textTheme.bodySmall!.copyWith(),
                      //   ),
                      // if (value.childrenNumber != null &&
                      //     value.childrenNumber! > 0)
                      //   Text(
                      //     'Child Count - ${value.childrenNumber?.toString() ?? ' Null'}',
                      //     style: themeData.textTheme.bodySmall!.copyWith(),
                      //   ),

                      // if (value.user!.flagCount != null &&
                      //     value.user!.flagCount! > 0)
                      //   Text(
                      //     'User Flag Count - ${value.user?.flagCount?.toString() ?? ' Null'}',
                      //     style: themeData.textTheme.bodySmall!.copyWith(),
                      //   ),
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     final completer = Completer();
                //     ProgressDialog.showCompleter(context, completer);
                //     if (message.isFlaggedByMe) {
                //       message.unflag().then((value) {
                //         completer.complete();
                //         CommonSnackbar.showPositiveSnackbar(
                //             context, 'Message', 'Unflagged');
                //       }).onError((error, stackTrace) {
                //         completer.completeError(error!, stackTrace);

                //         CommonSnackbar.showPositiveSnackbar(
                //             context, 'Message', 'Unflag Error - ${error}');
                //       });
                //     } else {
                //       message.flag().then((value) {
                //         completer.complete();
                //         CommonSnackbar.showPositiveSnackbar(
                //             context, 'Message', 'Flagged');
                //       }).onError((error, stackTrace) {
                //         completer.completeError(error!, stackTrace);

                //         CommonSnackbar.showPositiveSnackbar(
                //             context, 'Message', 'Flag Error - ${error}');
                //       });
                //     }
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 6),
                //     padding: const EdgeInsets.symmetric(horizontal: 6),
                //     decoration: BoxDecoration(
                //         border: Border.all(color: Colors.grey, width: 1)),
                //     child: Row(
                //       children: [
                //         Icon(value.isFlaggedByMe
                //             ? Icons.flag_rounded
                //             : Icons.flag_outlined),
                //         if ((value.flagCount ?? 0) > 0)
                //           Text('${value.flagCount}')
                //       ],
                //     ),
                //   ),
                // ),
                PopupMenuButton(
                  child: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: message!.user!.userId! ==
                            AmityCoreClient.getCurrentUser()!.userId
                        ? Color(0xFFD9D9D9)
                        : Color(0xFF292C45),
                  ),
                  itemBuilder: (context) {
                    return [
                      // const PopupMenuItem(
                      //   value: 0,
                      //   child: Text('Reply'),
                      // ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Edit Message'),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Delete Message'),
                      ),
                      // PopupMenuItem(
                      //   value: 3,
                      //   child: Text(
                      //       '${message.isFlaggedByMe ? 'Unflag' : 'flag'} Message'),
                      // ),
                      // const PopupMenuItem(
                      //   value: 4,
                      //   child: Text('Flag User'),
                      // ),
                      // const PopupMenuItem(
                      //   value: 5,
                      //   child: Text('UnFlag User'),
                      // ),
                      // const PopupMenuItem(
                      //   value: 6,
                      //   child: Text('Tags'),
                      // ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      // case 0:
                      //   onReplyTap(message);
                      //   break;
                      case 1:
                        var currentUserId = AmityCoreClient.getUserId();
                        if (message.data is MessageTextData) {
                          // Update Message
                          if (message.userId != currentUserId) {
                            CommonSnackbar.showPositiveSnackbar(
                                context,
                                'Message',
                                'Error - You are not allowed to do this.');
                            return;
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MessageUpdateScreen(
                              messageId: message.messageId!,
                            ),
                          ));
                        }
                        break;
                      case 2:
                        var currentUserId = AmityCoreClient.getUserId();
                        if (message.userId != currentUserId) {
                          CommonSnackbar.showPositiveSnackbar(
                              context,
                              'Message',
                              'Delete Error - You are not allowed to do this.');
                          return;
                        }

                        message.delete().then((value) {
                          CommonSnackbar.showPositiveSnackbar(
                              context, 'Message', 'Deleted');
                        }).onError((error, stackTrace) {
                          CommonSnackbar.showPositiveSnackbar(
                              context, 'Message', 'Delete Error - ${error}');
                        });

                        /// Delete Message
                        break;
                      // case 3:
                      //   if (message.isFlaggedByMe) {
                      //     message.unflag().then((value) {
                      //       CommonSnackbar.showPositiveSnackbar(
                      //           context, 'Message', 'Unflagged');
                      //     }).onError((error, stackTrace) {
                      //       CommonSnackbar.showPositiveSnackbar(
                      //           context, 'Message', 'Unflag Error - ${error}');
                      //     });
                      //   } else {
                      //     message.flag().then((value) {
                      //       CommonSnackbar.showPositiveSnackbar(
                      //           context, 'Message', 'Flagged');
                      //     }).onError((error, stackTrace) {
                      //       CommonSnackbar.showPositiveSnackbar(
                      //           context, 'Message', 'Flag Error - ${error}');
                      //     });
                      //   }
                      //   break;
                      // case 4:
                      //   UserRepository()
                      //       .report(message.userId!)
                      //       .flag()
                      //       .then((value) {
                      //     CommonSnackbar.showPositiveSnackbar(
                      //         context, 'Message', 'Flagged User');
                      //   }).onError((error, stackTrace) {
                      //     CommonSnackbar.showPositiveSnackbar(
                      //         context, 'Message', 'flagged Error - ${error}');
                      //   });

                      //   /// Delete Message
                      //   break;
                      // case 5:
                      //   UserRepository()
                      //       .report(message.userId!)
                      //       .unflag()
                      //       .then((value) {
                      //     CommonSnackbar.showPositiveSnackbar(
                      //         context, 'Message', 'Unflagged User');
                      //   }).onError((error, stackTrace) {
                      //     CommonSnackbar.showPositiveSnackbar(
                      //         context, 'Message', 'Unflagged Error - ${error}');
                      //   });

                      //   /// Delete Message
                      //   break;
                      // case 6:
                      //   EditTextDialog.show(
                      //     context,
                      //     title: 'Tags',
                      //     hintText: 'Enter Tags',
                      //     defString: message.amityTags?.tags?.join(','),
                      //     onPress: (value) {
                      //       if (value.isNotEmpty) {
                      //         message
                      //             .upate()
                      //             .tags(value.split(','))
                      //             .update()
                      //             .then((value) {
                      //           CommonSnackbar.showPositiveSnackbar(
                      //               context, 'Message', 'Tag Updated');
                      //         }).onError((error, stackTrace) {
                      //           CommonSnackbar.showPositiveSnackbar(context,
                      //               'Message', 'Tag message Error - $error');
                      //         });
                      //       } else {
                      //         CommonSnackbar.showNagativeSnackbar(
                      //             context, 'Tags', 'Please enter tags');
                      //       }
                      //     },
                      //   );

                      //   /// Tag Message
                      //   break;
                      default:
                    }
                  },
                ),
              ],
            ),
          ),
          if (value.reactions!.reactions != null &&
              value.reactions!.reactions!.isNotEmpty)
            Positioned.fill(
              right: 10,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  // color: Colors.red,
                  child: InkWell(
                    onLongPress: () {
                      // GoRouter.of(context).pushNamed(AppRoute.messageReaction,
                      //     params: {'messageId': message.messageId!});
                    },
                    child: Stack(
                      // mainAxisSize: MainAxisSize.min,
                      clipBehavior: Clip.hardEdge,
                      children: [
                        if (value.reactions!.getCount('like') > 0)
                          Container(
                            alignment: Alignment.center,
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('like')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      value.reactions!
                                          .getCount('like')
                                          .toString(),
                                      style: themeData.textTheme.caption!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/ic_liked.png',
                                    height: 20,
                                    width: 20,
                                    package: "amity_uikit_beta_service",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('Like') > 0)
                          Container(
                            alignment: Alignment.center,
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('like')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      value.reactions!
                                          .getCount('like')
                                          .toString(),
                                      style: themeData.textTheme.caption!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/ic_liked.png',
                                    height: 20,
                                    width: 20,
                                    package: "amity_uikit_beta_service",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('love') > 0)
                          Container(
                            alignment: Alignment.center,
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('love')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Text(
                                    value.reactions!
                                        .getCount('love')
                                        .toString(),
                                    style: themeData.textTheme.caption!
                                        .copyWith(fontSize: 14),
                                  ),
                                  Image.asset(
                                    'assets/images/ic_heart.png',
                                    height: 20,
                                    width: 20,
                                    package: "amity_uikit_beta_service",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (value.reactions!.getCount('Love') > 0)
                          Container(
                            alignment: Alignment.center,
                            width: 36,
                            height: 36,
                            margin: const EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade100,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                message
                                    .react()
                                    .removeReaction('love')
                                    .then((value) {
                                  CommonSnackbar.showPositiveSnackbar(
                                      context,
                                      'Success',
                                      'Reaction Removed Successfully');
                                }).onError(
                                  (error, stackTrace) {
                                    CommonSnackbar.showNagativeSnackbar(
                                        context,
                                        'Fail',
                                        'Reaction Removed Failed ${error.toString()}');
                                  },
                                );
                              },
                              icon: Row(
                                children: [
                                  Text(
                                    value.reactions!
                                        .getCount('love')
                                        .toString(),
                                    style: themeData.textTheme.caption!
                                        .copyWith(fontSize: 14),
                                  ),
                                  Image.asset(
                                    'assets/images/ic_heart.png',
                                    height: 20,
                                    width: 20,
                                    package: "amity_uikit_beta_service",
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _reactionDialog(BuildContext context, AmityMessage message) {
    final myReaction = message.myReactions ?? [];
    showDialog(
      context: context,
      builder: (innercontext) {
        return AlertDialog(
          title: const Text('Reaction'),
          content: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (myReaction.contains('like')) {
                        CommonSnackbar.showNagativeSnackbar(
                            innercontext,
                            'Error',
                            'You already have like reaction on this message');
                      } else {
                        Navigator.of(innercontext).pop();
                        message.react().addReaction('like').then((value) {
                          CommonSnackbar.showPositiveSnackbar(innercontext,
                              'Success', 'Reaction Added Successfully - like');
                        }).onError(
                          (error, stackTrace) {
                            CommonSnackbar.showNagativeSnackbar(
                                innercontext,
                                'Fail',
                                'Reaction Added Failed ${error.toString()} - like');
                          },
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/images/ic_liked.png',
                      height: 18,
                      width: 18,
                      package: "amity_uikit_beta_service",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (myReaction.contains('love')) {
                        CommonSnackbar.showNagativeSnackbar(
                            innercontext,
                            'Error',
                            'You already have love reaction on this message');
                      } else {
                        Navigator.of(innercontext).pop();
                        message.react().addReaction('love').then((value) {
                          CommonSnackbar.showPositiveSnackbar(innercontext,
                              'Success', 'Reaction Added Successfully - love');
                        }).onError(
                          (error, stackTrace) {
                            CommonSnackbar.showNagativeSnackbar(
                                innercontext,
                                'Fail',
                                'Reaction Added Failed ${error.toString()} - love');
                          },
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/images/ic_heart.png',
                      height: 18,
                      width: 18,
                      package: "amity_uikit_beta_service",
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(innercontext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class AmityMessageContentWidget extends StatelessWidget {
  const AmityMessageContentWidget({Key? key, required this.amityMessage})
      : super(key: key);
  final AmityMessage amityMessage;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final data = amityMessage.data;
    if (data is MessageTextData) {
      return DynamicTextHighlighting(
        text: data.text!,
        highlights: amityMessage.metadata == null
            ? []
            : [
                ...AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                    .getMentionedUsers()
                    .map<String>((e) =>
                        data.text!.substring(e.index, e.index + e.length + 1))
                    .toList(),
                ...AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                    .getMentionedChannels()
                    .map<String>((e) =>
                        data.text!.substring(e.index, e.index + e.length + 1))
                    .toList()
              ],
        style: themeData.textTheme.bodyMedium!.copyWith(
          color: amityMessage!.user!.userId! ==
                  AmityCoreClient.getCurrentUser().userId
              ? Color(0xFFD9D9D9)
              : Color(0xFF292C45),
          fontWeight: FontWeight.w600,
        ),
        onHighlightClick: (value) {
          if (value.toLowerCase().contains('all')) {
            final temp =
                AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                    .getMentionedUsers();
            log(AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                .getMentionedUsers()
                .map<String>((e) =>
                    data.text!.substring(e.index, e.index + e.length + 1))
                .toList()
                .toString());
            log(AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                .getMentionedChannels()
                .map<String>((e) =>
                    data.text!.substring(e.index, e.index + e.length + 1))
                .toList()
                .toString());
            CommonSnackbar.showPositiveSnackbar(
                context, 'Click', 'Click on @all show channel profile');
          } else {
            print(AmityMentionMetadataGetter(metadata: amityMessage.metadata!)
                .getMentionedUsers()
                .map<String>((e) =>
                    data.text!.substring(e.index, e.index + e.length + 1))
                .toList());
            final amityUser = amityMessage.mentionees!.firstWhereOrNull(
                (element) =>
                    element.user!.displayName == value.replaceAll('@', ''));
            if (amityUser != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UserProfileScreen(
                        amityUser: AmityCoreClient.getCurrentUser(),
                        amityUserId: AmityCoreClient.getUserId(),
                      )));
            }
          }
        },
      );
    }

    if (data is MessageImageData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (data.image!.hasLocalPreview != null)
              ? Container(
                  // color: Colors.red,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: data.image!.hasLocalPreview!
                        ? Image.file(
                            File(data.image!.getFilePath!),
                            fit: BoxFit.cover,
                          )
                        : Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  data.image!.getUrl(AmityImageSize.MEDIUM),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(.3)),
                                  child: InkWell(
                                    child: const Icon(
                                      Icons.download,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      // String fileName = await MobileDownloadService()
                                      //     .download(url: data.image!.getUrl(AmityImageSize.MEDIUM));

                                      // print(fileName);

                                      // CommonSnackbar.showPositiveSnackbar(context, 'Success', 'Image Save $fileName');
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                )
              : Container(
                  width: 30,
                  height: 30,
                  color: Colors.amber,
                ),
          if (data.caption != null && data.caption!.isNotEmpty)
            Text(
              '${data.caption}',
              style: themeData.textTheme.bodyMedium,
            ),
        ],
      );
    }

    if (data is MessageFileData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (data.file?.hasLocalPreview != null)
              ? TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file_rounded),
                  label: Text(
                    data.file!.getFilePath!.split('/').last,
                  ),
                )
              : Container(
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: const Icon(Icons.attach_file_rounded),
                    title: Text(
                      data.file!.fileName!,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.3)),
                      child: InkWell(
                        child: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          // String fileName = await MobileDownloadService()
                          //     .download(url: data.file!.getUrl!);

                          // print(fileName);
                        },
                      ),
                    ),
                    // tileColor: Colors.red,
                    // focusColor: Colors.red,
                    // selectedColor: Colors.red,
                  ),
                ),
          // TextButton.icon(
          //     onPressed: () {},
          //     icon: const Icon(Icons.attach_file_rounded),
          //     label: Text(
          //       data.file.getUrl.split('/').last,
          //     ),
          //     style: TextButton.styleFrom(
          //       padding: const EdgeInsets.all(12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       primary: Colors.black,
          //       backgroundColor: Colors.grey.shade300,
          //     ),
          //   ),
          if (data.caption != null && data.caption!.isNotEmpty)
            Text(
              '${data.caption}',
              style: themeData.textTheme.bodyMedium,
            ),
        ],
      );
    }

    return Text(
      'Still not supported',
      style: themeData.textTheme.bodyMedium!.copyWith(),
    );
  }
}
