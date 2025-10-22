import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;

class AddFeedsScreen extends StatefulWidget {
  final String? token;
  final List<Map<String, dynamic>> categories;

  const AddFeedsScreen({super.key, this.token, required this.categories});

  @override
  State<AddFeedsScreen> createState() => _AddFeedsScreenState();
}

class _AddFeedsScreenState extends State<AddFeedsScreen> {
  File? _videoFile;
  File? _thumbnailFile;
  final TextEditingController _descController = TextEditingController();
  // List<int> selectedCategoryIds = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  VideoPlayerController? _videoController;

  final picker = ImagePicker();

  List<Map<String, dynamic>> get categories => widget.categories;


  Future<void> _pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Validate MP4 type
      if (!file.path.toLowerCase().endsWith('.mp4')) {
        Fluttertoast.showToast(msg: 'Only MP4 videos allowed');
        return;
      }

      // Validate duration
      final controller = VideoPlayerController.file(file);
      await controller.initialize();
      final duration = controller.value.duration;
      if (duration.inMinutes > 5) {
        Fluttertoast.showToast(msg: 'Video must be ≤ 5 minutes');
        controller.dispose();
        return;
      }

      setState(() {
        _videoFile = file;
        _videoController = controller;
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
      });
    }
  }

  // Future<void> _uploadFeed() async {
  //   if (_videoFile == null ||
  //       _thumbnailFile == null ||
  //       _descController.text.isEmpty ||
  //       selectedCategoryIds.isEmpty) {
  //     Fluttertoast.showToast(msg: 'All fields are required');
  //     return;
  //   }
  //
  //   setState(() {
  //     _isUploading = true;
  //     _uploadProgress = 0;
  //   });
  //
  //   try {
  //     final uri = Uri.parse(
  //       'https://yourapi.com/my_feed',
  //     ); // 🔁 Change endpoint
  //     final request = http.MultipartRequest('POST', uri);
  //
  //     // Access token (replace with your stored token logic)
  //     final accessToken = 'YOUR_ACCESS_TOKEN_HERE';
  //     request.headers['Authorization'] = 'Bearer $accessToken';
  //
  //     request.fields['desc'] = _descController.text;
  //     request.fields['category'] = jsonEncode(selectedCategoryIds);
  //
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'video',
  //         _videoFile!.path,
  //         filename: basename(_videoFile!.path),
  //       ),
  //     );
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'image',
  //         _thumbnailFile!.path,
  //         filename: basename(_thumbnailFile!.path),
  //       ),
  //     );
  //
  //     final streamedResponse = await request.send();
  //
  //     streamedResponse.stream.listen(
  //       (value) {
  //         setState(() {
  //           _uploadProgress +=
  //               value.length / (streamedResponse.contentLength ?? 1);
  //         });
  //       },
  //       onDone: () async {
  //         final response = await http.Response.fromStream(streamedResponse);
  //         setState(() => _isUploading = false);
  //
  //         if (response.statusCode == 200 || response.statusCode == 201) {
  //           Fluttertoast.showToast(msg: 'Feed uploaded successfully!');
  //           // Navigator.pop(context);
  //         } else {
  //           Fluttertoast.showToast(
  //             msg: 'Upload failed: ${response.statusCode}',
  //           );
  //         }
  //       },
  //       onError: (e) {
  //         setState(() => _isUploading = false);
  //         Fluttertoast.showToast(msg: 'Error: $e');
  //       },
  //       cancelOnError: true,
  //     );
  //   } catch (e) {
  //     setState(() => _isUploading = false);
  //     Fluttertoast.showToast(msg: 'Something went wrong');
  //   }
  // }

  bool _isEditing = false;
  String _description = "";

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
  List<String> selectedCategoryIds = [];

  void _startEditing() {
    setState(() {
      _descController.text = _description; // ✅ only set here, not every build
      _isEditing = true;
    });
  }

  void _saveDescription() {
    setState(() {
      _description = _descController.text.trim();
      _isEditing = false;
    });
  }

  bool _showAllCategories = false;

  Future<void> _uploadFeed() async {
    if (_videoFile == null ||
        _thumbnailFile == null ||
        _descController.text.isEmpty ||
        selectedCategoryIds.isEmpty) {
      Fluttertoast.showToast(msg: 'All fields are required');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      final uri = Uri.parse('https://frijo.noviindus.in/api/my_feed');
      final request = http.MultipartRequest('POST', uri);

      final accessToken = widget.token ?? 'YOUR_ACCESS_TOKEN';
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields['desc'] = _descController.text;
      request.fields['category'] = jsonEncode(selectedCategoryIds);

      // 🔹 Initialize progress tracking variables HERE (outside stream)
      int bytesSent = 0;
      final videoLength = await _videoFile!.length();
      final imageLength = await _thumbnailFile!.length();
      final totalBytes = videoLength + imageLength;

      // 🔹 Wrap video file stream
      final videoStream = http.ByteStream(
        _videoFile!.openRead().transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              bytesSent += data.length;
              setState(() {
                _uploadProgress = bytesSent / totalBytes;
              });
              sink.add(data);
            },
          ),
        ),
      );

      // 🔹 Add files to the request
      request.files.add(http.MultipartFile(
        'video',
        videoStream,
        videoLength,
        filename: basename(_videoFile!.path),
      ));

      // Add image normally (not tracked)
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _thumbnailFile!.path,
        filename: basename(_thumbnailFile!.path),
      ));

      // 🔹 Send request
      final response = await request.send();
      setState(() => _isUploading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'Feed uploaded successfully!');
        setState(() {
          _videoFile = null;
          _thumbnailFile = null;
          _descController.clear();
          selectedCategoryIds.clear();
          _uploadProgress = 0;
        });
      } if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        Fluttertoast.showToast(msg: 'Feed uploaded successfully!');
        setState(() {
          _videoFile = null;
          _thumbnailFile = null;
          _descController.clear();
          selectedCategoryIds.clear();
          _uploadProgress = 0;
        });
        // Future.delayed(const Duration(milliseconds: 800), () {
        //   if (mounted) Navigator.pop(context as BuildContext);
        // });
        // ✅ Give a small delay so toast is visible before closing

      } else {
        Fluttertoast.showToast(msg: 'Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isUploading = false);
      Fluttertoast.showToast(msg: 'Something went wrong: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow-circle-right.png",
            width: 25.15,
            height: 25.15,
          ),
          //Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Feeds',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.32,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _isUploading ? null : _uploadFeed,
            child: Container(
              margin: const EdgeInsets.only(right: 20),

              decoration: BoxDecoration(
                color: const Color(0x33C60000),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 0.84, color: const Color(0x66C60000)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _isUploading ? "Uploading..." : "Share Post",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.015),
            GestureDetector(
              onTap: _pickVideo,
              child: DottedBorder(
                options: CustomPathDottedBorderOptions(
                  //  padding: const EdgeInsets.alla(8),
                  color: Colors.white.withValues(alpha: 0.30),
                  strokeWidth: 1,
                  dashPattern: const [10, 6],
                  customPath: (size) {
                    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
                    final rrect = RRect.fromRectAndRadius(
                      rect,
                      const Radius.circular(12),
                    ); // ✅ Rounded rectangle
                    return Path()..addRRect(rrect);
                  },
                ),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.25,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child:
                        _videoFile == null
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/videoupload.png",
                                  width: 52.40,
                                  height: 52.40,
                                ),
                                // Icon(Icons.upload_rounded,
                                //     color: Colors.white70, size: 40),
                                SizedBox(height: 10),
                                Text(
                                  "Select a video from Gallery",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.30,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 40,
                                ),
                                Text(
                                  basename(_videoFile!.path),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            GestureDetector(
              onTap: _pickThumbnail,
              child: DottedBorder(
                options: CustomPathDottedBorderOptions(
                  //  padding: const EdgeInsets.alla(8),
                  color: Colors.white.withValues(alpha: 0.30),
                  strokeWidth: 1,
                  dashPattern: const [10, 6],
                  customPath: (size) {
                    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
                    final rrect = RRect.fromRectAndRadius(
                      rect,
                      const Radius.circular(12),
                    ); // ✅ Rounded rectangle
                    return Path()..addRRect(rrect);
                  },
                ),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    image:
                        _thumbnailFile != null
                            ? DecorationImage(
                              image: FileImage(_thumbnailFile!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      _thumbnailFile == null
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/imageadding.png",
                                width: 32.49,
                                height: 23.06,
                              ),
                              // Icon(Icons.image_outlined,
                              //     color: Colors.white70, size: 30),
                              SizedBox(width: 25),
                              Text(
                                "Add a Thumbnail",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.30,
                                  ),
                                ),
                              ),
                            ],
                          )
                          : null,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.035),
            Text(
              "Add Description",
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                  letterSpacing: 0.28,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _isEditing
                ? TextField(
                  controller: _descController,
                  maxLines: 4,
                  autofocus: true,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.done,
                  // ✅ Save on Done
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.60),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      height: 1.91,
                      letterSpacing: 0.22,
                    ),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF111111),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    hintText: 'Enter description...',
                    hintStyle: GoogleFonts.montserrat(
                      textStyle: const TextStyle(color: Colors.white54),
                    ),
                  ),
                  onSubmitted: (_) => _saveDescription(),
                  // ✅ Save also when editing is completed programmatically
                  onEditingComplete: _saveDescription,
                )
                : GestureDetector(
                  onTap: _startEditing,
                  child: Text(
                    _description.isEmpty
                        ? 'Click here and type your description...'
                        : _description,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color:
                            _description.isEmpty
                                ? Colors.white54
                                : Colors.white.withValues(alpha: 0.60),
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        height: 1.91,
                        letterSpacing: 0.22,
                      ),
                    ),
                  ),
                ),

            SizedBox(height: size.height * 0.035),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories This Project",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAllCategories = !_showAllCategories;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _showAllCategories ? "Hide" : "View All",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      _showAllCategories
                          ? Image.asset(
                            "assets/viewbutton.png",
                            width: 15.48,
                            height: 15.48,
                          )
                          : Image.asset(
                            "assets/viewbutton.png",
                            width: 15.48,
                            height: 15.48,
                          ),
                      // Icon(
                      //   _showAllCategories
                      //       ? Icons.keyboard_arrow_up
                      //       : Icons.keyboard_arrow_right,
                      //   color: Colors.white70,
                      //   size: 18,
                      // ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.02),
            if (categories.isEmpty)
              Center(
                child: Text(
                  'No categories available',
                  style: GoogleFonts.montserrat(color: Colors.white54),
                ),
              ),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...(_showAllCategories ? categories : categories.take(2)).map((cat) {
                final id = cat['id'].toString(); // ✅ Use string IDs for uniqueness
                final selected = selectedCategoryIds.contains(id);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        selectedCategoryIds.remove(id);
                      } else {
                        selectedCategoryIds.add(id);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0x66C60000),
                        width: 0.63,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: selected ? const Color(0x33C60000) : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      cat['name'] ?? '',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: selected ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.89,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ),
                  ),
                );
              }),

            ]

          ),


            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: [
            //     // ✅ show only 3 or all based on toggle
            //     ...(_showAllCategories ? categories : categories.take(3)).map((
            //       cat,
            //     ) {
            //       final selected = selectedCategoryIds.contains(cat['id']);
            //       return GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             if (selected) {
            //               selectedCategoryIds.remove(cat['id']);
            //             } else {
            //               selectedCategoryIds.add(cat['id']);
            //             }
            //           });
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //               color:
            //                   selected
            //                       ? const Color(0x66C60000)
            //                       : const Color(0x66C60000),
            //               width: 0.63,
            //             ),
            //             borderRadius: BorderRadius.circular(20),
            //             color:
            //                 selected ? Color(0x33C60000) : Colors.transparent,
            //           ),
            //           padding: const EdgeInsets.symmetric(
            //             horizontal: 12,
            //             vertical: 6,
            //           ),
            //           child: Text(
            //             cat['name'],
            //             style: GoogleFonts.montserrat(
            //               textStyle: TextStyle(
            //                 color: selected ? Colors.white : Colors.white70,
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.w400,
            //                 height: 1.89,
            //                 letterSpacing: 0.20,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ],
            // ),

            if (_isUploading)
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      height: 10,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _uploadProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC60000), Color(0xFFFF5A5A)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Uploading ${(100 * _uploadProgress).toStringAsFixed(1)}%",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SpinKitThreeBounce(
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ],
                ),
              ),


            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
