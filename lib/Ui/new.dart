// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:newtask/Ui/new.dart';
//
// import 'home_screen.dart';
//
// class MobileNumberScreen extends StatefulWidget {
//   const MobileNumberScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MobileNumberScreen> createState() => _MobileNumberScreenState();
// }
//
// class _MobileNumberScreenState extends State<MobileNumberScreen> {
//
//   Country? _selectedCountry = CountryService().findByCode(
//       'IN'); // default India (+91)
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery
//         .of(context)
//         .size;
//     final isSmallDevice = size.height < 700;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: size.width * 0.06,
//                     vertical: isSmallDevice ? 24 : 15,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     //  mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 50,
//                       ),
//                       Text(
//                         'Enter Your\nMobile Number',
//                         style: GoogleFonts.montserrat(textStyle: TextStyle(
//                           color: Colors.white,
//                           fontSize: size.width * 0.085,
//                           fontWeight: FontWeight.w500,
//                           height: 1.5,)
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.02),
//                       Text(
//                         'Lorem ipsum dolor sit amet consectetur. Porta at id hac vitae. Et tortor at vehicula euismod mi viverra.',
//                         style: GoogleFonts.montserrat(textStyle: TextStyle(
//                           color: const Color(0xFFE2E2E2),
//                           fontSize: size.width * 0.035,
//                           height: 1.5,)
//                         ),
//                       ),
//                       SizedBox(height: size.height * 0.09),
//                       Row(
//                         children: [
//                           Flexible(
//                             flex: 2,
//                             child: Container(
//                               height: size.height * 0.07,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade700),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: PopupMenuButton<Country>(
//                                 onSelected: (Country country) {
//                                   setState(() {
//                                     _selectedCountry = country;
//                                   });
//                                 },
//                                 itemBuilder: (context) {
//                                   return [
//                                     PopupMenuItem(
//                                       enabled: false, // Prevents selection
//                                       child: ConstrainedBox(
//                                         constraints: const BoxConstraints(
//                                             maxHeight: 200), // set your limit
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: CountryService()
//                                                 .getAll()
//                                                 .map((country) =>
//                                                 ListTile(
//                                                   dense: true,
//                                                   // smaller height per item
//                                                   title: Text(
//                                                     '${country
//                                                         .flagEmoji} ${country
//                                                         .countryCode} (+${country
//                                                         .phoneCode})',
//                                                     //${country.flagEmoji}
//                                                     style:GoogleFonts.montserrat(textStyle:TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 16,
//                                                       fontWeight: FontWeight.w600,
//                                                       letterSpacing: 0.48,)
//                                                     ),
//                                                   ),
//                                                   onTap: () {
//                                                     Navigator.pop(context);
//                                                     setState(() =>
//                                                     _selectedCountry = country);
//                                                   },
//                                                 ))
//                                                 .toList(),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ];
//                                 },
//
//                                 color: Colors.grey[900],
//                                 offset: const Offset(0, 50),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 10.0,),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment
//                                         .spaceBetween,
//                                     children: [
//                                       Text(
//                                         '+${_selectedCountry?.phoneCode}',
//                                         textAlign: TextAlign.center,
//                                         style: GoogleFonts.montserrat(
//                                             textStyle: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                               letterSpacing: 0.48,)
//                                         ),
//                                       ),
//                                       const Icon(Icons.arrow_drop_down,
//                                         color: Colors.white, size: 20,),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: size.width * 0.03),
//                           Flexible(
//                             flex: 6,
//                             child: Container(
//                               height: size.height * 0.07,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade700),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16.0),
//                                 child: Center(
//                                   child: TextField(
//                                     cursorColor: Colors.white,
//                                     style: GoogleFonts.montserrat(
//                                         textStyle: TextStyle(
//                                             color: Colors.white, fontSize: 16)),
//                                     keyboardType: TextInputType.phone,
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(10),
//                                       // 🔹 Limits input to 10 digits
//                                       FilteringTextInputFormatter.digitsOnly,
//                                       // 🔹 Allows only numbers
//                                     ],
//                                     decoration:  InputDecoration(
//                                       hintText: 'Enter Mobile Number',
//                                       hintStyle: GoogleFonts.montserrat(
//                                           textStyle:TextStyle(
//                                             color:  Color(0xFFBDBDBD),
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w400,
//                                             letterSpacing: 0.26,)
//                                       ),
//                                       border: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//
//                       SizedBox(height: size.height * 0.25),
//                       Center(
//                         child: InkWell(onTap: (){
//                           Navigator.of(context).push(PageRouteBuilder(
//                             pageBuilder: (_, __, ___) => const HomeScreen(),
//                             transitionDuration: Duration.zero,
//                           ));
//                           // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>HomeScreen()));
//                         },
//                           child: Container(
//                             width: size.width * 0.39,
//                             height: size.height * 0.067,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.white.withOpacity(0.22)),
//                               borderRadius: BorderRadius.circular(50),
//                               color: Colors.transparent,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 9.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Continue',
//                                     style: GoogleFonts.montserrat(
//                                         textStyle: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,)
//                                     ),
//                                   ),
//                                   Container(
//                                     width: size.height * 0.049,
//                                     height: size.height * 0.049,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFC60000),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(
//                                       Icons.arrow_forward_ios_rounded,
//                                       color: Colors.white,
//                                       size: 18,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//
//                       // Center(
//                       //   child: Container(
//                       //     width: size.width * 0.35,
//                       //     height: size.height * 0.065,
//                       //     decoration: BoxDecoration(
//                       //       border: Border.all(color: Colors.grey.shade700),
//                       //       borderRadius: BorderRadius.circular(50),
//                       //       color: Colors.transparent,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// login