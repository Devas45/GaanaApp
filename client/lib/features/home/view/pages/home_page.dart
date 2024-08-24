import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedInd = 0;
  final pages = const [
    SongsPage(),
    LibraryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    // print(user);
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedInd],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedInd,
        onTap: (value) {
          setState(() {
            selectedInd = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                selectedInd == 0
                    ? 'assets/images/home_filled.png'
                    : 'assets/images/home_unfilled.png',
                color: selectedInd == 0
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                'assets/images/music-album_1013033.png',
                color: selectedInd == 1
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
