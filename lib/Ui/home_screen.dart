import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:readmore/readmore.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../features/home_main/presentation/providers/home_provider.dart';
import 'feed_create.dart';
import 'myfeeds.dart';

class HomeScreen extends StatefulWidget {
  final String? token;

  const HomeScreen({super.key, this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _playingIndex;
  final List<VideoPlayerController> _videoControllers = [];
  final List<ChewieController?> _chewieControllers = [];
  String selectedCategory = "Explore";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeProvider = context.read<HomeProvider>();
      homeProvider.loadHome(widget.token!);
    });
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    for (var chewie in _chewieControllers) {
      chewie?.dispose();
    }
    super.dispose();
  }

  Future<void> _playVideo(int index, String videoUrl) async {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i != index) {
        await _videoControllers[i].pause();
        _chewieControllers[i]?.pause();
      }
    }

    setState(() {
      _playingIndex = index;
    });

    if (index >= _videoControllers.length) {
      final controller = VideoPlayerController.network(videoUrl);
      await controller.initialize();
      _videoControllers.add(controller);
      _chewieControllers.add(
        ChewieController(
          videoPlayerController: controller,
          autoPlay: true,
          looping: false,
          showControls: true,
          aspectRatio: controller.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.red,
            handleColor: Colors.white,
            backgroundColor: Colors.grey.shade700,
            bufferedColor: Colors.white24,
          ),
        ),
      );
    } else {
      final controller = _videoControllers[index];
      await controller.initialize();
      _chewieControllers[index]?.dispose();
      _chewieControllers[index] = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        showControls: true,
        aspectRatio: controller.value.aspectRatio,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: Color(0xFF131313),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.051,
          right: size.width * 0.04,
        ),
        child: InkWell(
          onTap: () {
            final homeProvider = context.read<HomeProvider>();
            final categoryList = homeProvider.entity?.categoryDict
                ?.map((c) => {"id": c.id, "name": c.title})
                .toList() ??
                [];
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>  AddFeedsScreen(token: widget.token!,categories: categoryList,),
                transitionDuration: Duration.zero,
              ),
            );
          },
          child: Container(
            width: 75.89,
            height: 75.89,
            decoration: const BoxDecoration(
              color: Color(0xFFC60000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 45),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Builder(
          builder: (_) {
            // ✅ Skeleton while loading
            if (homeProvider.status == HomeStatus.loading) {
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  itemCount: 3, // number of placeholder cards
                  itemBuilder: (context, index) {
                    return Container(
                      color: const Color(0xFF161616),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ListTile(
                            leading: CircleAvatar(radius: 18, backgroundColor: Colors.white24),
                            title: SizedBox(height: 10, width: 80, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white24))),
                            subtitle: SizedBox(height: 8, width: 50, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white24))),
                          ),
                          const SizedBox(height: 10),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10, width: double.infinity, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white24))),
                                SizedBox(height: 6),
                                SizedBox(height: 10, width: 150, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white24))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            // ✅ Error
            if (homeProvider.status == HomeStatus.failure) {
              return Center(
                child: Text(
                  homeProvider.failure?.message ?? "Failed to load data",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            // ✅ Empty data
            if (homeProvider.entity == null ||
                homeProvider.entity!.results.isEmpty) {
              return const Center(
                child: Text(
                  "No posts available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // ✅ Success → Show posts
            final posts = homeProvider.entity!.results;
            final categories = homeProvider.entity!.categoryDict;
            final sortedCategories = [
              ...categories.where((c) => c.title == "Explore"),
              ...categories.where((c) => c.title != "Explore"),
            ];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        /// Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello ${homeProvider.entity!.userName ??
                                      'User'}",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Welcome back to Section",
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFFD5D5D5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.24,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>  Myfeeds(token: widget.token!,),
                                    transitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: CircleAvatar(radius: 22,
                                backgroundImage: homeProvider.entity?.user?.image !=
                                    null
                                    ? NetworkImage(
                                    homeProvider.entity!.user!.image!)
                                    : const AssetImage(
                                    'assets/user_placeholder.png') as ImageProvider,
                                backgroundColor: Colors.grey.shade800,
                                child: homeProvider.entity?.user?.image == null
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                                // login person image show: icon show
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                  // ✅ Always show "Explore" first


                        if (sortedCategories.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < sortedCategories.length; i++) ...[
                                  _categoryButton(sortedCategories[i].title ?? ''),
                                  if (sortedCategories[i].title == "Explore")
                                    Container(
                                      //margin: const EdgeInsets.symmetric(horizontal: 5),
                                      width: 1.2,
                                      height: 22,
                                      color: Colors.grey.shade700, // Divider color
                                    ),
                                  SizedBox(width: i == sortedCategories.length - 1 ? 0 : 10)
                                ],
                              ],
                            ),
                          ),

                        /// ✅ Category bar from API
                        // if (categories.isNotEmpty)
                        //   SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       children: categories.map((category) {
                        //         return _categoryButton(category.title ?? '');
                        //       }).toList(),
                        //     ),
                        //   ),

                        const SizedBox(height: 20),

                        /// ✅ Dynamic posts


                        // for (int i = 0; i < posts.length; i++)
                        //   _postCard(
                        //     index: i,
                        //     name: posts[i].user?.name ?? 'Unknown',
                        //     time: posts[i].createdAt ?? '',
                        //     description: posts[i].description ?? '',
                        //     thumbnail: posts[i].image ?? '',
                        //     videoUrl: posts[i].video ?? '',
                        //     userImage: posts[i].user?.image,
                        //   ),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: size.height,
                    width: double.infinity,// ✅ ensures proper scroll space
                    child: ListView.separated(
                      //physics: const BouncingScrollPhysics(),
                      // padding: const EdgeInsets.only(bottom: 100), // space for FAB
                      separatorBuilder: (_, __) => const SizedBox(height: 5),
                      itemCount: posts.length,
                      itemBuilder: (context, i) {
                        return Container(
                          color: const Color(0xFF161616),
                          child: _postCard(
                            index: i,
                            name: posts[i].user?.name ?? 'Unknown User',
                            time: posts[i].createdAt ?? '',
                            description: posts[i].description ?? '',
                            thumbnail: posts[i].image ?? '',
                            videoUrl: posts[i].video ?? '', // ✅ don’t forget videoUrl
                            userImage: posts[i].user?.image,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Category Button Widget
  Widget _categoryButton(String title) {
    final bool isSelected = title == selectedCategory;
    final bool isExplore = title == "Explore";

    final Color borderColor =
    isSelected ? Colors.white.withOpacity(0.5) : Colors.grey.shade800;
    final Color backgroundColor =
    isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isExplore ? const Color(0x33C60000) : backgroundColor,
            border: Border.all(
              color: isExplore ? const Color(0x66C60000) : borderColor,
              width: 0.84,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              if (isExplore)
                Image.asset("assets/expolericon.png",
                    width: 14.67, height: 14.67),
              if (isExplore) const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Post Card Widget
  Widget _postCard({
    required int index,
    required String name,
    required String time,
    required String description,
    required String thumbnail,
    required String videoUrl,
    String? userImage,
  }) {
    final size = MediaQuery
        .of(context)
        .size;
    final bool isPlaying = _playingIndex == index &&
        _chewieControllers.length > index &&
        _chewieControllers[index] != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Profile Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              children: [
                CircleAvatar(radius: 18,
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: (userImage != null && userImage.isNotEmpty)
                      ? NetworkImage(userImage)
                      : null, // no image → show icon
                  child: (userImage == null || userImage.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white, size: 18)
                      : null,
                  //user image show
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFD7D7D7),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          /// Video or Image
          GestureDetector(
            onTap: () {
              if (videoUrl.isNotEmpty) _playVideo(index, videoUrl);
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isPlaying
                    ? Chewie(controller: _chewieControllers[index]!)
                    : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(thumbnail, fit: BoxFit.cover),
                    if (videoUrl.isNotEmpty) Container(color: Colors.black45),
                    if (videoUrl.isNotEmpty)
                      Center(
                        child: Image.asset(
                          "assets/playicon.png",
                          width: 37.73,
                          height: 37.73,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: ReadMoreText(
              description,
              trimLines: 2,
              colorClickableText: Colors.red,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' See more',
              trimExpandedText: ' Read less',
              style: GoogleFonts.montserrat(
                color: const Color(0xFFD5D5D5),
                fontSize: 12.5,
                fontWeight: FontWeight.w300,
                height: 1.84,
                letterSpacing: 0.25,
              ),
              moreStyle: const TextStyle(
                color: Color(0xFFCCCCCC),
                fontWeight: FontWeight.w700,
              ),
              lessStyle: const TextStyle(
                color: Color(0xFFCCCCCC),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton Placeholder UI
  Widget _skeletonHomeUI(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
              (i) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 18),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 12, width: 100, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(
                                height: 10, width: 60, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: size.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(height: 10,
                        width: double.infinity,
                        color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 10,
                        width: size.width * 0.6,
                        color: Colors.white),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
