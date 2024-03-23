import 'package:amity_uikit_beta_service/view/social/user_follower_component.dart';
import 'package:amity_uikit_beta_service/view/social/user_following_component.dart';
import 'package:amity_uikit_beta_service/viewmodel/follower_following_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/configuration_viewmodel.dart';

class FollowScreen extends StatefulWidget {
  final String userId;
  final String? displayName;
  const FollowScreen({super.key, required this.userId, this.displayName});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  TabController? _tabController;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar:AppBar(
        elevation: 0.0, // Add this line to remove the shadow
        leading: IconButton(
          icon: const Icon(Icons.close,
          color: Color(0xff998455),),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.displayName ?? "",
          style: Provider.of<AmityUIConfiguration>(context).titleTextStyle
          .copyWith(
            color: Color(0xff998455),
            fontWeight: FontWeight.w800,
            fontSize: 20
          ),
        ),
        backgroundColor: Color(0xFF292C45),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xff1E2034),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Column(
              children: [
                Container(
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
                          "Following",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800  
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Followers",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800  
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<FollowerVM>(builder: (context, vm, _) {
                    return TabBarView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        AmityFollowingScreen(
                          userId: widget.userId,
                        ),
                        AmityFollowerScreen(
                          userId: widget.userId,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
