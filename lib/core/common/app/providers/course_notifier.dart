import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter/widgets.dart';

class CourseOfTheDayNotifier extends ChangeNotifier {
  Course? _courseOfTheDay;

  Course? courseOfTheDay() => _courseOfTheDay;

  void setCourseOfTheDay(Course course) {
    _courseOfTheDay ??= course;
    notifyListeners();
  }
}
