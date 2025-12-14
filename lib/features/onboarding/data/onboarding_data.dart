import 'package:flutter/material.dart';
import '../models/onboarding_item.dart';

final onboardingItems = [
  OnboardingItem(
    image: 'assets/images/carousel_1.png',
    title: 'Discover Amazing Wallpapers',
    subtitle:
        'Explore thousands of stunning wallpapers\ncurated just for you',
    icon: Icons.auto_awesome,
  ),
  OnboardingItem(
    image: 'assets/images/carousel_2.png',
    title: 'Download & Customize',
    subtitle:
        'Download high-quality wallpapers and\nmake them yours',
    icon: Icons.download,
  ),
  OnboardingItem(
    image: 'assets/images/carousel_3.png',
    title: 'Save Your Favourites',
    subtitle:
        'Create collections and keep your favorite\nwallpapers organized',
    icon: Icons.favorite,
  ),
];
