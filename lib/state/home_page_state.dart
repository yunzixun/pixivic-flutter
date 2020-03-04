import 'package:flutter/foundation.dart';

class HomePageState with ChangeNotifier {
    bool menuButtonActive = false;
    bool menuListActive = false;

    void onMenuButtonTap() {
      menuButtonActive = !menuButtonActive;
      menuListActive = !menuListActive;
    }
}