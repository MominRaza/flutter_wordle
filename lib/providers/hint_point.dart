import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifierProvider, StateNotifier;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

final hintPointProvider =
    StateNotifierProvider<HintPoint, int>((ref) => HintPoint());

class HintPoint extends StateNotifier<int> {
  HintPoint() : super(0);

  late SharedPreferences pref;

  void win(int hintPoint) {
    state += hintPoint;
    pref.setInt('hintPoint', state);
  }

  void showHint() {
    state -= 1;
    pref.setInt('hintPoint', state);
  }

  Future<void> load() async {
    pref = await SharedPreferences.getInstance();
    state = pref.getInt('hintPoint') ?? 2;
  }
}
