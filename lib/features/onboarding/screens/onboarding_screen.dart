import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/onboarding_data.dart';
import '../../auth/screens/preview_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void _goToPreview(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const PreviewScreen(),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 24),
                _carousel(),
                const SizedBox(height: 20),
                _indicator(),
                const SizedBox(height: 24),
                _nextButton(context),
                const SizedBox(height: 20),
              ],
            ),
        ),
      ),
    );
  }

  // ================== WIDGETS ==================

  // Widget _topBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: const [
  //       Row(
  //         children: [
  //           Icon(Icons.wallpaper, color: primaryPurple),
  //           SizedBox(width: 6),
  //           Text(
  //             'Wallpapers',
  //             style: TextStyle(
  //               color: textPrimary,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Text(
  //         'Skip',
  //         style: TextStyle(color: textSecondary),
  //       ),
  //     ],
  //   );
  // }

  Widget _topBar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: const [
          Icon(Icons.wallpaper, color: primaryPurple),
          SizedBox(width: 6),
          Text(
            'Wallpapers',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      GestureDetector(
        onTap: () => _goToPreview(context),
        child: const Text(
          'Skip',
          style: TextStyle(color: textSecondary),
        ),
      ),
    ],
  );
}




  Widget _carousel() {
    return Expanded(
      child: PageView.builder(
        controller: _controller,
        itemCount: onboardingItems.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
        },
        itemBuilder: (context, index) {
          final item = onboardingItems[index];
          return Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      item.image,
                      height: 360,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryPurple,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _indicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: currentIndex == index ? 18 : 6,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? primaryPurple
                : textSecondary.withOpacity(0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  // Widget _nextButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 52,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         if (currentIndex < onboardingItems.length - 1) {
  //           _controller.nextPage(
  //             duration: const Duration(milliseconds: 400),
  //             curve: Curves.ease,
  //           );
  //         }
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: primaryPurple,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //       ),
  //       child: const Text(
  //         'Next',
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget _nextButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: () {
        if (currentIndex < onboardingItems.length - 1) {
          // Move to next carousel page
          _controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        } else {
          // LAST PAGE → GO TO PREVIEW
          _goToPreview(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        currentIndex == onboardingItems.length - 1
            ? 'Get Started'
            : 'Next',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}
}
