import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/utils/dynamicSilverAppBar.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/create_post_screenV2.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/post_target_page.dart';
import 'package:amity_uikit_beta_service/view/social/user_follow_screen.dart';
import 'package:amity_uikit_beta_service/view/user/medie_component.dart';
import 'package:amity_uikit_beta_service/view/user/user_setting.dart';
import 'package:amity_uikit_beta_service/viewmodel/follower_following_viewmodel.dart';
import 'package:amity_uikit_beta_service/view/chat/chat_screen.dart';
import 'package:amity_uikit_beta_service/viewmodel/channel_list_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/channel_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_viewmodel.dart';
import 'package:amity_uikit_beta_service/repository/chat_repo_imp.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_user_avatar.dart';
import '../../viewmodel/amity_viewmodel.dart';
import '../../viewmodel/configuration_viewmodel.dart';
import '../../viewmodel/user_feed_viewmodel.dart';
import '../social/global_feed.dart';
import 'edit_profile.dart';

class UserProfileScreen extends StatefulWidget {
  final AmityUser? amityUser;
  final String amityUserId;
  bool? isEnableAppbar = true;
  UserProfileScreen(
      {Key? key,
      this.amityUser,
      this.isEnableAppbar,
      required this.amityUserId})
      : super(key: key);
  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    if (widget.amityUser != null) {
      Provider.of<UserFeedVM>(context, listen: false).initUserFeed(
          amityUser: widget.amityUser, userId: widget.amityUser!.userId!);
    } else {
      Provider.of<UserFeedVM>(context, listen: false)
          .initUserFeed(userId: widget.amityUserId);
    }
  }

  String getFollowingStatusString(AmityFollowStatus amityFollowStatus) {
    if (amityFollowStatus == AmityFollowStatus.NONE) {
      return "Follow";
    } else if (amityFollowStatus == AmityFollowStatus.PENDING) {
      return "Pending";
    } else if (amityFollowStatus == AmityFollowStatus.ACCEPTED) {
      return "Following";
    } else if (amityFollowStatus == AmityFollowStatus.BLOCKED) {
      return "Blocked";
    } else {
      return "Miss Type";
    }
  }

  Color getFollowingStatusColor(AmityFollowStatus amityFollowStatus) {
    if (amityFollowStatus == AmityFollowStatus.NONE) {
      return Color(0xff3DDAB4);
    } else if (amityFollowStatus == AmityFollowStatus.PENDING) {
      return Colors.white38;
    } else if (amityFollowStatus == AmityFollowStatus.ACCEPTED) {
      return Color(0xffFC0069);
    } else {
      return Colors.white;
    }
  }

  Color getFollowingStatusTextColor(AmityFollowStatus amityFollowStatus) {
    if (amityFollowStatus == AmityFollowStatus.NONE) {
      return Colors.white;
    } else if (amityFollowStatus == AmityFollowStatus.PENDING) {
      return Colors.white;
    } else if (amityFollowStatus == AmityFollowStatus.ACCEPTED) {
      return Colors.white;
    } else {
      return Colors.red;
    }
  }

  AmityUser getAmityUser() {
    if (Provider.of<UserFeedVM>(context).amityUser!.userId ==
        AmityCoreClient.getCurrentUser().userId) {
      return Provider.of<AmityVM>(context).currentamityUser!;
    } else {
      return Provider.of<UserFeedVM>(context).amityUser!;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isCurrentUser =
        AmityCoreClient.getCurrentUser().userId == widget.amityUserId;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: Color(0xFF292C45),
      leading: IconButton(
        color: Provider.of<AmityUIConfiguration>(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.chevron_left,
          color: Color(0xff998455),
          size: 24,
        ),
      ),
      elevation: 0,
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;

    return Consumer<UserFeedVM>(builder: (context, vm, _) {
      if (vm.amityUser != null) {
        Widget buildPrivateAccountWidget(double bheight) {
          return Container(
            color: Color(0xff1E2034),
            width: MediaQuery.of(context).size.width,
            height: bheight - 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/privateIcon.png",
                  package: "amity_uikit_beta_service",
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  "This account is private",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const Text(
                  "Follow this user to see all posts",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white54),
                ),
              ],
            ),
          );
        }

        Widget buildNoPostsWidget(double bheight, BuildContext context) {
          return Container(
            color: Color(0xff1E2034),
            width: MediaQuery.of(context).size.width,
            height: bheight - 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/noPostYet.png",
                  package: "amity_uikit_beta_service",
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  "No post yet",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ],
            ),
          );
        }

        Widget buildPostsList(BuildContext context) {
          return Container(
            color: Color(0xff1E2034),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: vm.amityPosts.length,
              itemBuilder: (context, index) {
                return StreamBuilder<AmityPost>(
                  stream: vm.amityPosts[index].listen.stream,
                  initialData: vm.amityPosts[index],
                  builder: (context, snapshot) {
                    return PostWidget(
                      feedType: FeedType.user,
                      showCommunity: false,
                      showlatestComment: true,
                      isFromFeed: true,
                      post: snapshot.data!,
                      theme: theme,
                      postIndex: index,
                    );
                  },
                );
              },
            ),
          );
        }

        Widget buildContent(BuildContext context, double bheight) {
          if (vm.amityMyFollowInfo.status != AmityFollowStatus.ACCEPTED &&
              vm.amityUser!.userId != AmityCoreClient.getUserId()) {
            return buildPrivateAccountWidget(bheight);
          } else if (vm.amityPosts.isEmpty) {
            return buildNoPostsWidget(bheight, context);
          } else {
            return buildPostsList(
                context); // Placeholder for tab bar can be integrated here
          }
        }

        var tablist = [
          buildContent(context, bheight),
          const MediaGalleryPage(
            galleryFeed: GalleryFeed.user,
          )
        ];
        return Scaffold(
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: Colors.white,
          //   leading: IconButton(
          //     icon: Icon(Icons.chevron_left, color: Colors.black),
          //     onPressed: () => Navigator.of(context).pop(),
          //   ),
          // ),
          floatingActionButton: widget.amityUserId !=
                  AmityCoreClient.getCurrentUser().userId
              ? null
              : FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: () async {
                    // Navigate or perform action based on 'Newsfeed' tap
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Scaffold(body: PostToPage()),
                    ));
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AmityCreatePostV2Screen(),
                    ));
                    Provider.of<UserFeedVM>(context, listen: false)
                        .initUserFeed(userId: widget.amityUserId);
                  },
                  backgroundColor: Color(0xff998455),
                  child: Provider.of<AmityUIConfiguration>(context)
                      .iconConfig
                      .postIcon(iconSize: 28, color: Color(0xFF292C45)),
                ),
          backgroundColor: Color(0xff1E2034),
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                var followWidget = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Provider.of<ChannelVM>(context, listen: false).initVM();
                        var userToChatDisplayName =
                            widget.amityUser!.displayName;
                        var currentUserDisplayName =
                            AmityCoreClient.getCurrentUser().displayName;

                        // Check if both display names are available before concatenating
                        var chatName = userToChatDisplayName != null &&
                                currentUserDisplayName != null
                            ? userToChatDisplayName + " : " + currentUserDisplayName
                            : "Display name";

                        Provider.of<ChannelVM>(context, listen: false)
                            .createConversationChannel([
                          AmityCoreClient.getUserId(),
                          widget.amityUserId
                        ], (channel, error) {
                          if (channel != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => MessageVM(),
                                  child: ChatSingleScreen(
                                    key: UniqueKey(),
                                    channel: channel.channels![0],
                                  ),
                                ),
                              ),
                            );
                          }
                        }, chatName);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.pink,
                                style: BorderStyle.solid,
                                width: 1),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.pink),
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                              weight: 4,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Chat",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(),
                        child: vm.amityMyFollowInfo.id == null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff998455),
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Text(
                                  "",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleSmall!.copyWith(
                                      fontSize: 12, color: Colors.white),
                                ),
                              )
                            : StreamBuilder<AmityUserFollowInfo>(
                                stream: vm.amityMyFollowInfo.listen.stream,
                                initialData: vm.amityMyFollowInfo,
                                builder: (context, snapshot) {
                                  return FadeAnimation(
                                      child: GestureDetector(
                                    onTap: () {
                                      vm.followButtonAction(
                                          vm.amityUser!, snapshot.data!.status);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: getFollowingStatusColor(
                                                  snapshot.data!.status),
                                              style: BorderStyle.solid,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: getFollowingStatusColor(
                                              snapshot.data!.status)),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add,
                                            size: 16,
                                            color: Colors.white,
                                            weight: 4,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            getFollowingStatusString(
                                                snapshot.data!.status),
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.titleSmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  getFollowingStatusTextColor(
                                                      snapshot.data!.status),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                }),
                      ),
                    ),
                  ],
                );
                return <Widget>[
                  DynamicSliverAppBar(
                    shadowColor: Color(0xFF292C45),
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Color(0xFF292C45),
                    floating: false,
                    pinned: true,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Color(0xff998455),
                        size: 30,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    flexibleSpace: Column(
                      children: [
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 64,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FadedScaleAnimation(
                                        child: getAvatarImage(
                                            isCurrentUser
                                                ? Provider.of<AmityVM>(
                                                    context,
                                                  ).currentamityUser?.avatarUrl
                                                : Provider.of<UserFeedVM>(
                                                        context)
                                                    .amityUser!
                                                    .avatarUrl,
                                            radius: 32)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            // Text(vm.amityMyFollowInfo.status
                                            //     .toString()),
                                            Text(
                                              getAmityUser().displayName ?? "",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: -0.4),
                                            ),
                                            Row(
                                              children: [
                                                // Text('${  vm.amityMyFollowInfo.followerCount
                                                //     .toString()} Posts  '),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => ChangeNotifierProvider(
                                                            create: (context) =>
                                                                FollowerVM(),
                                                            child: FollowScreen(
                                                                key:
                                                                    UniqueKey(),
                                                                userId: widget
                                                                    .amityUserId,
                                                                displayName:
                                                                    getAmityUser()
                                                                        .displayName))));
                                                  },
                                                  child: Text(
                                                    '${vm.amityMyFollowInfo.followingCount.toString()} following  ',
                                                    style: TextStyle(
                                                      color: Color(0xff3DDAB4),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => ChangeNotifierProvider(
                                                            create: (context) =>
                                                                FollowerVM(),
                                                            child: FollowScreen(
                                                                key:
                                                                    UniqueKey(),
                                                                userId: widget
                                                                    .amityUserId,
                                                                displayName:
                                                                    getAmityUser()
                                                                        .displayName))));
                                                  },
                                                  child: Text(
                                                    '${vm.amityMyFollowInfo.followerCount.toString()} followers',
                                                    style: TextStyle(
                                                      color: Color(0xff3DDAB4),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      getAmityUser().description ?? "",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              AmityCoreClient.getCurrentUser().userId ==
                                      Provider.of<UserFeedVM>(context)
                                          .amityUser!
                                          .userId
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen(
                                                              user: vm
                                                                  .amityUser!)));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffFC0069),
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Color(0xffFC0069)),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 10, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "Edit Profile",
                                                    style: theme
                                                        .textTheme.titleSmall!
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : followWidget,
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                    actions: [
                      vm.amityMyFollowInfo.id == null
                          ? const SizedBox()
                          : StreamBuilder<AmityUserFollowInfo>(
                              stream: vm.amityMyFollowInfo.listen.stream,
                              initialData: vm.amityMyFollowInfo,
                              builder: (context, snapshot) {
                                return IconButton(
                                  icon: const Icon(Icons.more_horiz,
                                      color: Color(0xff998455)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserSettingPage(
                                                  amityMyFollowInfo:
                                                      snapshot.data!,
                                                  amityUser: vm.amityUser!,
                                                )));
                                  },
                                );
                              }),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              color: Color(0xff756548),
                              child: TabBar(
                                tabAlignment: TabAlignment.start,
                                controller: _tabController,
                                isScrollable: true,
                                indicatorColor: Color(0xff3DDAB4),
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorWeight: 6,
                                labelColor: Colors.white,
                                unselectedLabelColor: Color(0xff998455),
                                labelStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SF Pro Text',
                                ),
                                tabs: const [
                                  Tab(
                                    child: Text(
                                      "Timeline",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Gallery",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(controller: _tabController, children: tablist),
            ),
          ),
        );
      } else {
        log("UserProfileScreen:body: UserFeedVM.amityUser is null. Loading...");
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

    // TabBarView(
    //               controller: _tabController,
    //               children: tablist,
    //             ),