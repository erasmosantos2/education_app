import 'package:education_app/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDatasource {
  Future<void> cacheFirstTimer();
  Future<bool> checkIfUseridFirstTimer();
}

const kFirstTimerKey = 'first_timer';

class OnBoardingLocalDatasourceImpl extends OnBoardingLocalDatasource {
  OnBoardingLocalDatasourceImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _prefs.setBool(kFirstTimerKey, false);
    } on Exception catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUseridFirstTimer() async {
    try {
      return _prefs.getBool(kFirstTimerKey) ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
