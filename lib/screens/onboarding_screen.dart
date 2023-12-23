import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:paino_tab/screens/home_screen.dart';

class OnBoarding extends StatefulWidget {
  final bool isLoggedIn;
  const OnBoarding({super.key, required this.isLoggedIn});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      itemCount: onboard_data.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) => OnboardContent(
                          title: onboard_data[index].title,
                          animationAsset: onboard_data[index].animationAsset,
                          description: onboard_data[index].description)),
                ),
                Stack(
                  children: [
                    // Other widgets in the Stack
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                onboard_data.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: DotIndicator(
                                    isActive: index == _pageIndex,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _pageIndex != onboard_data.length - 1
                            ? Container(
                                margin: EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offAll(() => HomeScreen(
                                          isLoggedIn: widget.isLoggedIn,
                                          initialIndex: 0,
                                        ));
                                  },
                                  child: Text(
                                    "SKIP",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: const Color.fromARGB(
                                                255, 1, 31, 56)),
                                  ),
                                ),
                              )
                            : Spacer(),
                        Spacer(),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: ElevatedButton(
                              onPressed: () {
                                _pageIndex == onboard_data.length - 1
                                    ? Get.offAll(() => HomeScreen(
                                          isLoggedIn: widget.isLoggedIn,
                                          initialIndex: 0,
                                        ))
                                    : _pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor:
                                    const Color.fromARGB(255, 1, 31, 56),
                              ),
                              child: Icon(Icons.arrow_forward)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 16 : 8,
      width: 6,
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 1, 31, 56)
            : Color.fromARGB(255, 76, 137, 187),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String title, animationAsset, description;
  const OnboardContent({
    Key? key,
    required this.title,
    required this.animationAsset,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: const Color.fromARGB(255, 1, 31, 56),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            // Replace Image.asset with Lottie.asset
            Lottie.asset(
              animationAsset,
              height: MediaQuery.of(context).size.height * 0.4,
              // You can customize other properties here
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 1, 31, 56),
                )),
          ],
        ),
      ),
    );
  }
}

class Onboard {
  final String title, animationAsset, description;

  Onboard(
      {required this.title,
      required this.animationAsset,
      required this.description});
}

final List<Onboard> onboard_data = [
  Onboard(
      title: "Unleash Your Inner Pianist",
      animationAsset: 'assets/data/Unleash Your Inner Pianist.json',
      description:
          "Thanks for giving PianoTab a try! Experience a revolutionary, fun, and fast way to learn piano - visually! Say goodbye to confusing notes; we use LETTERS. It's easy on the eyes, just like your favorite video game, 'Guitar Hero.' Join us on a musical journey like never before."),
  Onboard(
      title: "Your Musical Playground Awaits!	",
      animationAsset: 'assets/data/Your Musical Playground Awaits.json',
      description:
          "Search, filter, and play your favorite songs effortlessly. Our vast catalog lets you explore by genre, artist, or difficulty. Listen to audio clips and play along. Need a paperback book? Check our Amazon link for more. Your musical adventure begins here!"),
  Onboard(
      title: "Try, Be Amazed, and Download",
      animationAsset: 'assets/data/Try_ Be Amazed_ and Download.json',
      description:
          "Immediate gratification! Preview and download a 1-page sample for free. See exactly what you're getting before diving in. Download and print PDFs to start playing right away. Your musical journey is just a click away."),
  Onboard(
      title: "Play, Earn, Repeat!",
      animationAsset: 'assets/data/Play Earn Repeat.json',
      description:
          "Watch videos, earn tokens with every purchase (only if logged in), and rate us for extra rewards! Your dedication deserves recognition. Play and earn simultaneously, or skip the wait—purchase seamlessly with PayPal for instant access to the joy of playing."),
  Onboard(
      title: "Your Music, Your Way!",
      animationAsset: 'assets/data/Your Music_ Your Way.json',
      description:
          "Create a free and easy account for a personalized experience! Sync hundreds of PianoTabs across platforms, store them on any device, and manage your shopping cart effortlessly. Enjoy secure payments via PayPal - your musical world, tailored just for you."),
];
