// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:readmore/readmore.dart';
// import 'package:provider/provider.dart';
// import '../features/my_feeds/presentation/providers/my_feed_provider.dart';
//
// class Myfeeds extends StatefulWidget {
//   const Myfeeds({Key? key}) : super(key: key);
//
//   @override
//   State<Myfeeds> createState() => _MyfeedsState();
// }
//
// class _MyfeedsState extends State<Myfeeds> {
//   int? _playingIndex;
//   final List<VideoPlayerController> _videoControllers = [];
//   final List<ChewieController?> _chewieControllers = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Load feed data once widget is built
//     Future.microtask(() {
//       final provider = context.read<MyFeedProvider>();
//       provider.loadMyFeeds(
//           "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzYxMjAzNTY3LCJpYXQiOjE3NjExMTcxNjcsImp0aSI6IjU5NmI5NGZlODM5NjRmMzg4Y2M1ZDBjYWNmNjkyYzVlIiwidXNlcl9pZCI6MTY1fQ.qWu5hoOeolq5PdtaiXShREjFCJNqxBbd16Y68rEb_gE"
//       ); // ✅ Use actual token here
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _videoControllers) {
//       controller.dispose();
//     }
//     for (var chewie in _chewieControllers) {
//       chewie?.dispose();
//     }
//     super.dispose();
//   }
//
//   Future<void> _playVideo(int index) async {
//     // Pause all other videos
//     for (int i = 0; i < _videoControllers.length; i++) {
//       if (i != index) {
//         await _videoControllers[i].pause();
//         _chewieControllers[i]?.pause();
//       }
//     }
//
//     setState(() => _playingIndex = index);
//
//     final controller = _videoControllers[index];
//     await controller.initialize();
//
//     _chewieControllers[index]?.dispose();
//     _chewieControllers[index] = ChewieController(
//       videoPlayerController: controller,
//       autoPlay: true,
//       looping: false,
//       showControls: true,
//       aspectRatio: controller.value.aspectRatio,
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.red,
//         handleColor: Colors.white,
//         backgroundColor: Colors.grey.shade700,
//         bufferedColor: Colors.white24,
//       ),
//     );
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final myFeedProvider = context.watch<MyFeedProvider>();
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: Image.asset(
//             "assets/arrow-circle-right.png",
//             width: 25.15,
//             height: 25.15,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'My Feeds',
//           style: GoogleFonts.montserrat(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             letterSpacing: 0.32,
//           ),
//         ),
//       ),
//
//       body: SafeArea(
//         child: Builder(
//           builder: (_) {
//             // ✅ Loading State (no spinner)
//             if (myFeedProvider.status == MyFeedStatus.loading) {
//               return const SizedBox(); // or show shimmer later
//             }
//
//             // ✅ Error State
//             if (myFeedProvider.status == MyFeedStatus.failure) {
//               print( myFeedProvider.error);
//               return Center(
//                 child: Text(
//                   myFeedProvider.error ?? "Failed to load feeds",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               );
//             }
//
//             // ✅ Empty State
//             if (myFeedProvider.entity == null ||
//                 myFeedProvider.entity!.results == null ||
//                 myFeedProvider.entity!.results!.isEmpty) {
//               return const Center(
//                 child: Text(
//                   "No feeds available",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             }
//
//             // ✅ Success State
//             final posts = myFeedProvider.entity!.results!;
//
//             // Initialize video controllers if not done
//             if (_videoControllers.isEmpty) {
//               for (var post in posts) {
//                 final controller = VideoPlayerController.network(post.video ?? "");
//                 _videoControllers.add(controller);
//                 _chewieControllers.add(null);
//               }
//             }
//
//             // ✅ List with spacing between items
//             return ListView.separated(
//               // padding: const EdgeInsets.symmetric(vertical: 20),
//               separatorBuilder: (_, __) => const SizedBox(height: 5),
//               itemCount: posts.length,
//               itemBuilder: (context, i) {
//                 return Container(
//                   color: const Color(0xFF161616),
//                   child: _postCard(
//                     index: i,
//                     name: posts[i].user?.name ?? 'Unknown User',
//                     time: posts[i].createdAt ?? '',
//                     description: posts[i].description ?? '',
//                     thumbnail: posts[i].image ?? '',
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _postCard({
//     required int index,
//     required String name,
//     required String time,
//     required String description,
//     required String thumbnail,
//   }) {
//     final size = MediaQuery.of(context).size;
//     bool isPlaying = _playingIndex == index && _chewieControllers[index] != null;
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 10,),
//           // Profile Section
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//             child: Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 18,
//                   backgroundImage: AssetImage("assets/profile.jpg"),
//                 ),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: GoogleFonts.montserrat(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 0.13,
//                       ),
//                     ),
//                     Text(
//                       time,
//                       style: GoogleFonts.montserrat(
//                         color: const Color(0xFFD7D7D7),
//                         fontSize: 10,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Video or Thumbnail
//           GestureDetector(
//             onTap: () => _playVideo(index),
//             child: AspectRatio(
//               aspectRatio: 16 / 9,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: isPlaying
//                     ? Chewie(controller: _chewieControllers[index]!)
//                     : Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.network(thumbnail, fit: BoxFit.cover),
//                     Container(color: Colors.black45),
//                     Center(
//                       child: Image.asset(
//                         "assets/playicon.png",
//                         width: 37.73,
//                         height: 37.73,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           // Description
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//             child: ReadMoreText(
//               description,
//               trimLines: 2,
//               colorClickableText: Colors.red,
//               trimMode: TrimMode.Line,
//               trimCollapsedText: ' See more',
//               trimExpandedText: ' Read less',
//               style: GoogleFonts.montserrat(
//                 color: const Color(0xFFD5D5D5),
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w300,
//                 height: 1.84,
//                 letterSpacing: 0.25,
//               ),
//               moreStyle: GoogleFonts.montserrat(
//                 color: const Color(0xFFCCCCCC),
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.25,
//               ),
//               lessStyle: GoogleFonts.montserrat(
//                 color: const Color(0xFFCCCCCC),
//                 fontSize: 12.5,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.25,
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
