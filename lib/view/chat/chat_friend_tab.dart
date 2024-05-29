import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';
import 'package:amity_sdk/amity_sdk.dart';

import '../../components/custom_user_avatar.dart';
import '../../viewmodel/channel_list_viewmodel.dart';
import '../../viewmodel/channel_viewmodel.dart';
import '../../viewmodel/configuration_viewmodel.dart';
import '../../viewmodel/user_viewmodel.dart';
import '../../model/amity_channel_model.dart';
import 'chat_screen.dart';

class ChatItems {
  String image;
  String name;

  ChatItems(this.image, this.name);
}

class AmitySLEChannelScreen extends StatefulWidget {
  const AmitySLEChannelScreen({Key? key}) : super(key: key);

  @override
  AmitySLEChannelScreenState createState() => AmitySLEChannelScreenState();
}

class AmitySLEChannelScreenState extends State<AmitySLEChannelScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (Provider.of<UserVM>(context, listen: false).accessToken == "") {
        await Provider.of<UserVM>(context, listen: false).initAccessToken();
      } else {
        Provider.of<UserVM>(context, listen: false).accessToken;
      }
      // ignore: use_build_context_synchronously
      Provider.of<ChannelVM>(context, listen: false).initVM();
    });
    super.initState();
  }

  int getLength(ChannelVM vm) {
    return vm.getChannelList().length;
  }

  String getDateTime(String dateTime) {
    var convertedTimestamp =
        DateTime.parse(dateTime); // Converting into [DateTime] object
    var result = GetTimeAgo.parse(
      convertedTimestamp,
    );

    if (result == "0 seconds ago") {
      return "just now";
    } else {
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final bHeight = mediaQuery.size.height -
    //     mediaQuery.padding.top -
    //     AppBar().preferredSize.height;

    final theme = Theme.of(context);
    return Consumer<ChannelVM>(builder: (context, vm, _) {
      return RefreshIndicator(
        color: Provider.of<AmityUIConfiguration>(context).primaryColor,
        onRefresh: () async {
          await vm.refreshChannels();
        },
        child: Scaffold(
          body: FadedSlideAnimation(
            beginOffset: const Offset(0, 0.3),
            endOffset: const Offset(0, 0),
            slideCurve: Curves.linearToEaseOut,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // color: Provider.of<AmityUIConfiguration>(context)
                    //     .channelListConfig
                    //     .backgroundColor,
                    color: Color(0xff1E2034),
                    margin: const EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      controller: vm.scrollController,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: getLength(vm),
                      itemBuilder: (context, index) {
                        var messageCount =
                            vm.getChannelList()[index].unreadCount;

                        bool rand = messageCount > 0 ? true : false;
                        // if ((Random().nextInt(10)) % 2 == 0) {
                        //   _rand = true;
                        // } else {
                        //   _rand = false;
                        // }
                        return Stack(
                          children: [
                            Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text(
                                          "Are you sure you want to delete this conversation?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              vm.refreshChannels();
                                            });
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Channels channel =
                                                vm.getChannelList()[index];

                                            Provider.of<ChannelVM>(context,
                                                    listen: false)
                                                .leaveConversationChannel(
                                              channel.channelId!,
                                              (result, error) {
                                                setState(() {
                                                  vm.refreshChannels();
                                                });

                                                // Close the dialog after deletion
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                color: Color(0xFF292C45),
                                elevation: 1.0,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatSingleScreen(
                                          channelId: vm
                                              .getChannelList()[index]
                                              .channelId!,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 5, 0),
                                        child: FadedScaleAnimation(
                                          child: getCommuAvatarImage(
                                            null,
                                            fileId: vm
                                                .getChannelList()[index]
                                                .avatarFileId,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: rand
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Provider.of<
                                                              AmityUIConfiguration>(
                                                          context)
                                                      .primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 0, 4, 2),
                                                child: Center(
                                                  child: Text(
                                                    vm
                                                        .getChannelList()[index]
                                                        .unreadCount
                                                        .toString(),
                                                    style: theme
                                                        .textTheme.bodyLarge!
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    (() {
                                      String displayName = vm
                                              .getChannelList()[index]
                                              .displayName ??
                                          "Display name";
                                      var currentUserDisplayName =
                                          AmityCoreClient.getCurrentUser()
                                              .displayName;
                                      List<String> names =
                                          displayName.split(" : ");
                                      if (names.length == 2 &&
                                          names[0] == currentUserDisplayName) {
                                        displayName = "${names[1]}";
                                      } else {
                                        displayName = "${names[0]}";
                                      }
                                      return displayName;
                                    })(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.3,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    vm.getChannelList()[index].latestMessage,
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .channelListConfig
                                          .latestMessageColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  trailing: Text(
                                    (vm.getChannelList()[index].lastActivity ==
                                            null)
                                        ? ""
                                        : getDateTime(vm
                                            .getChannelList()[index]
                                            .lastActivity!),
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      color: Provider.of<AmityUIConfiguration>(
                                              context)
                                          .channelListConfig
                                          .latestTimeColor,
                                      fontSize: 9.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   heroTag: 'chat',
          //   child: Icon(Icons.person_add),
          //   backgroundColor:  Provider.of<AmityUIConfiguration>(context)
          //              .primaryColor,
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => UserList(
          //         UniqueKey(),
          //       ),
          //     ));
          //   },
          // ),
        ),
      );
    });
  }
}
