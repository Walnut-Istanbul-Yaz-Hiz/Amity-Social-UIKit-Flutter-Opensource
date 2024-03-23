import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/my_community_feed.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/post_target_page.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/search_communities.dart';
import 'package:amity_uikit_beta_service/view/chat/chats_page.dart';
import 'package:amity_uikit_beta_service/view/social/community_feed.dart';
import 'package:amity_uikit_beta_service/view/social/global_feed.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile.dart';
import 'package:amity_uikit_beta_service/viewmodel/community_feed_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/explore_page_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_feed_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommunityPage extends StatefulWidget {
  final bool isShowMyCommunity;
  const CommunityPage({super.key, this.isShowMyCommunity = true});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    var explorePageVM = Provider.of<ExplorePageVM>(context, listen: false);
    explorePageVM.getRecommendedCommunities();
    explorePageVM.getTrendingCommunities();
    explorePageVM
        .queryCommunityCategories(AmityCommunityCategorySortOption.NAME);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
    
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            "Community",
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
                48.0), // Provide a height for the AppBar's bottom
            child: Container(
              color: Color(0xff756548),
              child: Row(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicatorColor: Color(0xff3DDAB4),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 6,
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xff998455),
                    labelStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800  
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Newsfeed',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800  
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
             ExplorePage(),
             NewsfeedPage(),
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(),
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
                text: 'CHAT',
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
      width: MediaQuery.of(context).size.width * 0.18,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        splashColor: Colors.transparent,
        highlightColor: Color(0xff3DDAB4),
        onPressed: () {
          goPage(route, context);
          _tabController.index = index ?? 0;
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

class NewsfeedPage extends StatelessWidget {
  final isShowMyCommunity;
  const NewsfeedPage({super.key, this.isShowMyCommunity=true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // Navigate or perform action based on 'Newsfeed' tap
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const Scaffold(body: PostToPage()),
          ));
        },
        backgroundColor: Color(0xff998455),
        child: Provider.of<AmityUIConfiguration>(context)
            .iconConfig
            .postIcon(iconSize: 28, color: Color(0xFF292C45)),
      ),
      body: GlobalFeedScreen(
        isShowMyCommunity: isShowMyCommunity,
      ),
    );
  }
}
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        RecommendationSection(),
        TrendingSection(),
        CategorySection(),
      ],
    );
  }
}

class RecommendationSection extends StatelessWidget {
  const RecommendationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsets.only(bottom: 24),
          color: Color(0xff1E2034), // Set background color
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 20),
                child: Text(
                  'Recommendation for you',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff998455),  
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 194,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.recommendedCommunities.length,
                  itemBuilder: (context, index) {
                    final community = vm.recommendedCommunities[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CommunityScreen(community: community))
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(4), // No border radius
                          ),
                          color: Color(0xFF292C45),
                          child: Container(
                            width: 131,
                            height: 194,
                            margin: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                community.avatarImage == null
                                    ? const CircleAvatar(
                                        backgroundColor: Color(0xFFD9E5FC),
                                        child: Icon(Icons.people,
                                            color: Colors.white))
                                    : CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFD9E5FC),
                                        backgroundImage: NetworkImage(
                                            community.avatarImage!.fileUrl!),
                                        radius:
                                            20, // Adjusted the radius to get 40x40 size
                                      ),
                                const SizedBox(height: 8.0),
                                Text(
                                  community.displayName ?? '',
                                  style: const TextStyle(
                                      color: Color(0xff998455),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle text overflow
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                community.categories!.isEmpty
                                    ? const Text(
                                        '',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle text overflow
                                      )
                                    : Text(
                                        '${community.categories?[0]?.name}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 13),
                                        overflow: TextOverflow
                                            .ellipsis, // Handle text overflow
                                      ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '${community.membersCount} Members',
                                  style:
                                      const TextStyle(
                                        color: Color(0xff3DDAB4),
                                        fontSize: 13,
                                      ),
                                  overflow: TextOverflow
                                      .ellipsis, // Handle text overflow
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    community.description ?? '',
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle text overflow
                                    maxLines: 3, // Display up to two lines
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrendingSection extends StatelessWidget {
  const TrendingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        return Container(
          color:  Color(0xFF292C45) ,
          padding: const EdgeInsets.only(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 20),
                child: Text(
                  'Today\'s Trending',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff998455),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.trendingCommunities.length,
                itemExtent: 60.0, // <-- Set this to your desired height
                itemBuilder: (context, index) {
                  final community = vm.trendingCommunities[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => CommuFeedVM(),
                                child: CommunityScreen(
                                  isFromFeed: true,
                                  community: community,
                                ),
                              )));
                    },
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF292C45),
                            shape: BoxShape.circle,
                          ),
                          child: community.avatarImage != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      community.avatarImage?.fileUrl ?? ''),
                                )
                              : const Icon(Icons.people, color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        Text("${index + 1}",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xffFC0069),
                                fontWeight: FontWeight.bold)), // Ranking number
                        // Spacing between rank and avatar
                      ],
                    ),
                    title: Text(
                      community.displayName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: community.categories!.isEmpty
                        ? Text(
                            'no category • ${community.membersCount} members',
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xff3DDAB4)),
                          )
                        : Text(
                            '${community.categories?[0]?.name ?? ""} • ${community.membersCount} members',
                            style: const TextStyle(
                                fontSize: 13, color: Color(0xff3DDAB4)
                              ),
                          ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExplorePageVM>(
      builder: (context, vm, _) {
        return Container(
          padding: const EdgeInsets.only(left: 16, top: 20, bottom: 25),
          color: Color(0xFF292C45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff998455),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryListPage()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 14.0),
                      child: Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Color(0xff998455),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 5,
                  mainAxisSpacing: 16, // Add spacing between rows
                ),
                itemCount: vm.amityCategories.length > 8
                    ? 8
                    : vm.amityCategories
                        .length, // Limit to maximum 8 items (2x4 grid)
                itemBuilder: (context, index) {
                  final category = vm.amityCategories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommunityListPage(
                                  category: category,
                                )),
                      );
                    },
                    child: Container(
                      color: Color(0xFF292C45),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Color(0xFF292C45),
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.category,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff3DDAB4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E2034),
      appBar: AppBar(
        backgroundColor: Color(0xFF292C45),
        elevation: 0.0, // Remove shadow
        title: Text(
          "Category",
          style: Provider.of<AmityUIConfiguration>(context)
              .titleTextStyle
              .copyWith(
                  color: Color(0xff998455),
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Color(0xff998455)
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ),
      body: Consumer<ExplorePageVM>(
        builder: (context, vm, _) {
          return ListView.builder(
            itemCount: vm.amityCategories.length,
            itemBuilder: (context, index) {
              final category = vm.amityCategories[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunityListPage(
                              category: category,
                            )),
                  );
                },
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF292C45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                ),
                title: Text(category.name ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff3DDAB4),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CommunityListPage extends StatefulWidget {
  final AmityCommunityCategory category;

  const CommunityListPage({required this.category, Key? key}) : super(key: key);

  @override
  _CommunityListPageState createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  late final ExplorePageVM _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ExplorePageVM>(context, listen: false);
    _viewModel.getCommunitiesInCategory(widget.category.categoryId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E2034),
      appBar: AppBar(
        backgroundColor: Color(0xFF292C45),
        elevation: 0.0, // Remove shadow

        title: Text(
          widget.category.name ?? "Community",
          style: Provider.of<AmityUIConfiguration>(context)
              .titleTextStyle
              .copyWith(
                  color: Color(0xff998455),
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
        ),
        iconTheme: const IconThemeData(color: Color(0xff998455), weight: 800.0),
      ),
      body: Consumer<ExplorePageVM>(
        builder: (context, vm, _) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: vm.communities.length,
            itemBuilder: (context, index) {
              final community = vm.communities[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CommunityScreen(community: community)));
                },
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFF292C45),
                    shape: BoxShape.circle,
                  ),
                  child: community.avatarImage != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              community.avatarImage?.fileUrl ?? ''),
                        )
                      : const Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                ),
                title: Text(community.displayName ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
