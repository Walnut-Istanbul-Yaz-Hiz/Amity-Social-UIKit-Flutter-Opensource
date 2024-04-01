import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amity_sdk/amity_sdk.dart';

import '../../viewmodel/configuration_viewmodel.dart';
import 'chat_friend_tab.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/search_communities.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_feed_viewmodel.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile.dart';
import 'package:amity_uikit_beta_service/view/social/global_feed.dart';
import 'package:amity_uikit_beta_service/viewmodel/community_feed_viewmodel.dart';
import 'package:amity_uikit_beta_service/view/social/community_feed.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/my_community_feed.dart';
import 'package:amity_uikit_beta_service/viewmodel/explore_page_viewmodel.dart';



class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Color(0xff1E2034),

        appBar: AppBar(
          elevation: 0.05, // Add this line to remove the shadow
          backgroundColor: Color(0xFF292C45),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Color(0xff998455)
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // centerTitle: false,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Chat",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Color(0xff998455),
              ),
              onPressed: () {
                // Implement search functionality
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchCommunitiesScreen()));
              },
            )
          ],
          bottom:  PreferredSize(
              preferredSize: Size.fromHeight(
                  52.0), // Provide a height for the AppBar's bottom
              child: Container(
                color: Color(0xff756548),
                child: Row(
                  children: [ 
                    TabBar(
                      physics: const BouncingScrollPhysics(),
                      isScrollable: true,
                      indicatorColor:
                          Provider.of<AmityUIConfiguration>(context).primaryColor,
                      labelColor: Provider.of<AmityUIConfiguration>(context).primaryColor,
                      unselectedLabelColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const [
                        Tab(text: "Single Chats"),
                        // Tab(text: "Groups"),
                      ],
                    ),
                  ]
                ),
              ),
            ),
          ),     
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              AmitySLEChannelScreen(),
              // ChatGroupTabScreen(),
            ],
          ),
          // bottomNavigationBar: _bottomNavigationBar(),
        ),
      );
    }

  Widget _bottomNavigationBar(){
    return Container(
      height: 80,
        decoration: BoxDecoration(
          color: Color(0xFF292C45),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navigationButton(
                route: 'Feed',
                icon: 'assets/images/weserved/newsfeed_icon.png',
                text: 'NEWS',
                index: 1,
              ),
              _navigationButton(
                route: 'Groups',
                icon: 'assets/images/weserved/groups_icon.png',
                text: 'GROUPS',
              ),
              _navigationButton(
                route: 'Explore',
                icon: 'assets/images/weserved/explore_icon.png',
                text: 'EXPLORE',
                index: 0,
              ),
              _navigationButton(
                route: 'Chat',
                icon: 'assets/images/weserved/chat_icon.png',
                text: 'CHAT',
              ),
              _navigationButton(
                route: 'Profile',
                icon: 'assets/images/weserved/navbar_profile_icon.png',
                text: 'PROFILE',
              ),
            ],
          ),
        ),
      );
    }

  Widget _navigationButton({
    required String icon,
    required String route,
    required String text,
    int? index,
  }) {
    return Container(
      color: Color(0xFF292C45),
      // width: MediaQuery.of(context).size.width * 0.18,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Color(0xff3DDAB4),
        onPressed: () {
          // goPage(route, context);
          // _tabController.index = index ?? 0;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              icon,
              package: "amity_uikit_beta_service",
              height: 40,
              width: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top:5,bottom: 5),
              child: Text(
                text,
                style: TextStyle(
                  color: Color(0xff756548),
                  fontSize: 14,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> goPage(String route, BuildContext context) async {
    switch (route) {
      case 'Groups':
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: MyCommunityPage()),
        ));
        break;
      case 'Profile':
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) =>
                  UserProfileScreen(
                    amityUser:
                        AmityCoreClient
                            .getCurrentUser(),
                    amityUserId:
                        AmityCoreClient
                            .getUserId(),
                  ))
          );
        break;
      // case 'Chat':
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) =>ChatsPage()
      //     )
      //   );
      //   break;
      // case 'More':
      default:
    }
  }

