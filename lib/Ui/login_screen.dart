import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // ✅ add this // ✅ your provider
import '../features/auth/presentation/providers/auth_provider.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  Country? _selectedCountry = CountryService().findByCode('IN');
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 700;
    final auth = context.watch<AuthProvider>(); // ✅ provider access

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: isSmallDevice ? 24 : 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Enter Your\nMobile Number',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.085,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur...',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: const Color(0xFFE2E2E2),
                            fontSize: size.width * 0.035,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.09),
                      Row(
                        children: [
                          // Country picker
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: PopupMenuButton<Country>(
                                onSelected: (Country country) {
                                  setState(() => _selectedCountry = country);
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      enabled: false,
                                      child: ConstrainedBox(
                                        constraints:
                                        const BoxConstraints(maxHeight: 200),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: CountryService()
                                                .getAll()
                                                .map((country) => ListTile(
                                              dense: true,
                                              title: Text(
                                                '${country.flagEmoji} ${country.countryCode} (+${country.phoneCode})',
                                                style:
                                                GoogleFonts.montserrat(
                                                  textStyle:
                                                  const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    letterSpacing: 0.48,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() =>
                                                _selectedCountry =
                                                    country);
                                              },
                                            ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                                color: Colors.grey[900],
                                offset: const Offset(0, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '+${_selectedCountry?.phoneCode}',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.48,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down,
                                          color: Colors.white, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          // Phone number input
                          Flexible(
                            flex: 6,
                            child: Container(
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Center(
                                  child: TextField(
                                    controller: phoneController,
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Enter Mobile Number',
                                      hintStyle: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                          color: Color(0xFFBDBDBD),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.26,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.25),

                      // ✅ Continue Button (uses provider)
                      Center(
                        child: InkWell(borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            final code = '+${_selectedCountry?.phoneCode ?? "91"}';
                            final phone = phoneController.text.trim();

                            if (phone.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter phone number'),
                                ),
                              );
                              return;
                            }

                            await auth.signIn(code, phone);

                            if (auth.status == AuthStatus.success) {
                              final token = auth.token;
                              if (token != null) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('access_token', token); // ✅ save token
                              }
                              if (context.mounted) {


                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) =>  HomeScreen(token:token ,)),
                                );
                              }
                            } else if (auth.status == AuthStatus.failure) {
                              print(auth.failure?.message);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text(auth.failure?.message ?? 'Failed')),
                              );
                            }
                          },
                          child: Container(
                            width: size.width * 0.39,
                            height: size.height * 0.067,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.22)),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.transparent,
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 9.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    auth.status == AuthStatus.loading
                                        ? 'Loading...'
                                        : 'Continue',
                                    style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: size.height * 0.049,
                                    height: size.height * 0.049,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFC60000),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
