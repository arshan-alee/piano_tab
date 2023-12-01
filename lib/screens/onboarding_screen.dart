import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                          image: onboard_data[index].image,
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
  final String title, image, description;
  const OnboardContent({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height, // Set a fixed height
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
            Image.asset(
              image,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Color.fromARGB(255, 3, 67, 119)),
            ),
          ],
        ),
      ),
    );
  }
}

class Onboard {
  final String title, image, description;

  Onboard(
      {required this.title, required this.image, required this.description});
}

final List<Onboard> onboard_data = [
  Onboard(
      title: "Welcome to \n Piano Tab",
      image: 'assets/images/library.png',
      description:
          "Lorem ipsum dolor sit amet. Aut ipsam tenetur sit quia sapiente in placeat tempore. Sed fuga fugit ut dolorem beatae qui omnis facilis sed illo voluptates est"),
  Onboard(
      title: "Lorem ipsum dolor sit",
      image: 'assets/images/library.png',
      description:
          "Lorem ipsum dolor sit amet. Aut ipsam tenetur sit quia sapiente in placeat tempore. Sed fuga fugit ut dolorem beatae qui omnis facilis sed illo voluptates est"),
  Onboard(
      title: "Lorem ipsum dolor sit",
      image: 'assets/images/library.png',
      description:
          "Lorem ipsum dolor sit amet. Aut ipsam tenetur sit quia sapiente in placeat tempore. Sed fuga fugit ut dolorem beatae qui omnis facilis sed illo voluptates est"),
  Onboard(
      title: "Lorem ipsum dolor sit",
      image: 'assets/images/library.png',
      description:
          "Lorem ipsum dolor sit amet. Aut ipsam tenetur sit quia sapiente in placeat tempore. Sed fuga fugit ut dolorem beatae qui omnis facilis sed illo voluptates est"),
];
