import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:paino_tab/screens/login_screen.dart';
import '../utils/colors.dart';
import '../utils/widget.dart';

class LibraryOffline extends StatelessWidget {
  const LibraryOffline({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.06,
          ),
          TextWidget(
            text: 'You have to login\n           first!',
            fontSize: 26,
            color: MyColors.blackColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget(
                text: 'Dont have an account? ',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.greyColor,
              ),
              TextWidget(
                onTap: () {
                  Get.offAll(() => const LoginScreen());
                },
                text: 'Login',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Image.asset('assets/images/library.png')
        ],
      ),
    );
  }
}
