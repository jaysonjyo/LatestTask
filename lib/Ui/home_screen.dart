import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newtask/Ui/myfeeds.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:readmore/readmore.dart';

import 'feed_create.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _playingIndex;
  final List<Map<String, dynamic>> posts = [
    {
      "name": "Anagha Krishna",
      "time": "5 days ago",
      "video":
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      "thumbnail":
      "https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?auto=format&fit=crop&w=800&q=80",
      "description":
      "Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucibus facilisi tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse...",
    },
    {
      "name": "Gokul Krishna",
      "time": "5 days ago",
      "video": "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
      "thumbnail":
      "https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=800&q=80",
      "description":
      "Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucibus facilisi tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse...",
    },
  ];

  final List<VideoPlayerController> _videoControllers = [];
  final List<ChewieController?> _chewieControllers = [];

  @override
  void initState() {
    super.initState();
    for (var post in posts) {
      final controller = VideoPlayerController.network(post["video"]);
      _videoControllers.add(controller);
      _chewieControllers.add(null);
    }
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

  Future<void> _playVideo(int index) async {
    // stop all other videos
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i != index) {
        await _videoControllers[i].pause();
        _chewieControllers[i]?.pause();
      }
    }

    setState(() {
      _playingIndex = index;
    });

    final controller = _videoControllers[index];
    await controller.initialize();

    _chewieControllers[index]?.dispose();
    _chewieControllers[index] = ChewieController(
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
    );

    setState(() {});
  }

  String selectedCategory = "Explore";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: size.height * 0.051,
          right: size.width * 0.04,
        ),
        child: InkWell(onTap: (){
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddFeedsScreen(),
            transitionDuration: Duration.zero,
          ));

        },
          child: Container(
            width: 75.89,
            height: 75.89,
            decoration: const BoxDecoration(
              color: const Color(0xFFC60000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 45),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Maria",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Welcome back to Section",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: const Color(0xFFD5D5D5),
                                  fontSize: 12,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(onTap: (){
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const Myfeeds(),
                            transitionDuration: Duration.zero,
                          ));

                        },
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage("assets/profile.jpg"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),

                    // Category Buttons
                    Row(
                      children: [
                        _categoryButton("Explore"),
                        Container(
                          height: 24,
                          width: 1,
                          color: Colors.grey.shade800,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),

                        // Scrollable list of other categories
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _categoryButton("Trending"),
                                _categoryButton("All Categories"),
                                _categoryButton("Physics"),
                                _categoryButton("Maths"),
                                _categoryButton("Biology"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // Video Feed Posts
              for (int i = 0; i < posts.length; i++)
                _postCard(
                  index: i,
                  name: posts[i]["name"],
                  time: posts[i]["time"],
                  description: posts[i]["description"],
                  thumbnail: posts[i]["thumbnail"],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryButton(String title) {
    final bool isSelected = title == selectedCategory;
    final bool isExplore = title == "Explore";

    // Decide color based on category type and selection
    final Color borderColor = isSelected
        ?  Colors.white.withValues(alpha: 0.50)
        : Colors.grey.shade800;

    final Color backgroundColor = isSelected
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isExplore ? Color(0x33C60000):backgroundColor,
            border: Border.all(
              color:isExplore ? Color(0x66C60000) : borderColor,
              width: 0.84,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              if (isExplore )
                Image.asset(
                  "assets/expolericon.png",
                  width: 14.67,
                  height: 14.67,
                ),
              if (isExplore ) const SizedBox(width: 6),
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

  Widget _postCard({
    required int index,
    required String name,
    required String time,
    required String description,
    required String thumbnail,
  }) {
    final size = MediaQuery.of(context).size;
    bool isPlaying =
        _playingIndex == index && _chewieControllers[index] != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.13,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: const Color(0xFFD7D7D7),
                          fontSize: 10,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Video or Thumbnail
          GestureDetector(
            onTap: () => _playVideo(index),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                isPlaying
                    ? Chewie(controller: _chewieControllers[index]!)
                    : Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(thumbnail, fit: BoxFit.cover),
                    Container(color: Colors.black45),
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
          ReadMoreText(
            description,
            trimLines: 2,
            // number of lines to show before "Read more"
            colorClickableText: Colors.red,
            trimMode: TrimMode.Line,
            trimCollapsedText: ' See more',
            trimExpandedText: ' Read less',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: const Color(0xFFD5D5D5),
                fontSize: 12.50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w300,
                height: 1.84,
                letterSpacing: 0.25,
              ),
            ),
            moreStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 12.50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.25,
              ),
            ),
            lessStyle: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: const Color(0xFFCCCCCC),
                fontSize: 12.50,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
