import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/create_community_page.dart';
import 'package:amity_uikit_beta_service/view/social/community_feed.dart';
import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/my_community_viewmodel.dart';
import 'package:amity_uikit_beta_service/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCommunityPage extends StatefulWidget {
  const MyCommunityPage({super.key});

  @override
  _MyCommunityPageState createState() => _MyCommunityPageState();
}

class _MyCommunityPageState extends State<MyCommunityPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<MyCommunityVM>(context, listen: false).initMyCommunity();
      Provider.of<UserVM>(context, listen: false).clearselectedCommunityUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCommunityVM>(builder: (context, vm, _) {
      return Scaffold(
        backgroundColor: Color(0xff1E2034),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF292C45),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color:  Color(0xff998455),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'My Community',
            style: Provider.of<AmityUIConfiguration>(context)
                .titleTextStyle
                .copyWith(
            color: Color(0xff998455),
            fontWeight: FontWeight.w800,
            fontSize: 20
          ), // Adjust as needed
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.add, color:  Color(0xff998455)),
          //     onPressed: () async {
          //       await Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) =>
          //               const CreateCommunityPage())); // Replace with your CreateCommunityPage
          //       await Provider.of<MyCommunityVM>(context, listen: false)
          //           .initMyCommunity();
          //     },
          //   ),
          // ],
        ),
        body: ListView.builder(
          controller: vm.scrollcontroller,
          itemCount: vm.amityCommunities.length + 1,
          itemBuilder: (context, index) {
            // If it's the first item in the list, return the search bar
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: vm.textEditingController,
                  style: TextStyle(color: Color(0xFF292C45)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xff998455),
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Color(0xff3DDAB4),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    Provider.of<MyCommunityVM>(context, listen: false)
                        .initMyCommunity(value);
                  },
                ),
              );
            }
            // Otherwise, return the community widget
            return CommunityWidget(
              community: vm.amityCommunities[index - 1],
            );
          },
        ),
      );
    });
  }
}

class CommunityWidget extends StatelessWidget {
  final AmityCommunity community;

  const CommunityWidget({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AmityCommunity>(
        stream: community.listen.stream,
        builder: (context, snapshot) {
          var communityStream = snapshot.data ?? community;
          return Card(
            color: Color(0xFF292C45),
            elevation: 0,
            child: ListTile(
              leading: (communityStream.avatarFileId != null)
                  ? CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(communityStream.avatarImage!.fileUrl!),
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                          color: Color(0xff998455), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.group,
                        color:  Color(0xFF292C45),
                      ),
                    ),
              title: Row(
                children: [
                  if (!community.isPublic!) const Icon(Icons.lock, size: 16.0),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      communityStream.displayName ?? "Community",
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CommunityScreen(community: communityStream)));
              },
            ),
          );
        });
  }
}

class CommunityIconList extends StatelessWidget {
  final List<AmityCommunity> amityCommunites;

  const CommunityIconList({super.key, required this.amityCommunites});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF292C45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            color: Color(0xFF292C45),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Community',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff998455),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const Scaffold(body: MyCommunityPage()),
                    ));
                  },
                  child: Container(
                    child: Icon(
                      Icons.chevron_right,
                      color: Color(0xff998455),
                    )
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 90.0,
            color: Color(0xFF292C45),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: amityCommunites.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Color(0xFF292C45),
                  padding: EdgeInsets.only(left: index != 0 ? 0 : 16),
                  child: CommunityIconWidget(
                    amityCommunity: amityCommunites[index]
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Color(0xff998455),
          )
        ],
      ),
    );
  }
}

class CommunityIconWidget extends StatelessWidget {
  final AmityCommunity amityCommunity;

  const CommunityIconWidget({super.key, required this.amityCommunity});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AmityCommunity>(
        stream: amityCommunity.listen.stream,
        builder: (context, snapshot) {
          var communityStream = snapshot.data ?? amityCommunity;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CommunityScreen(community: communityStream)));
            },
            child: Container(
              color: Color(0xFF292C45),
              width: 62,
              margin: const EdgeInsets.only(right: 4, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: 62,
                      child: Center(
                        child: (amityCommunity.avatarImage != null)
                        ? Container(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(amityCommunity
                                    .avatarImage!
                                    .getUrl(AmityImageSize.SMALL)),
                              ),
                          ),
                        )
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.white38,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                          ),
                      ),
                    )
                    
                  ),
                  Row(
                    children: [
                      !amityCommunity.isPublic!
                          ? const Icon(
                              Icons.lock,
                              size: 12,
                              color: Colors.white,
                            )
                          : const SizedBox(),
                      Expanded(
                        child: Container(
                          width: 62,
                          child: Text(amityCommunity.displayName ?? "",
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13,
                                  color: Color(0xff3DDAB4),
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
