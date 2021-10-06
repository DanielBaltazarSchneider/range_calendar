
# range_calendar
![Pub Package](https://img.shields.io/pub/v/range_calendar.svg?style=flat-square)   

This is a flutter calendar package that allows for daily, weekly and monthly calendar selection.

 
## Getting Started
### Depend on it
Run this command:

With Flutter:

```shell
 $ flutter pub add range_calendar
```

This will add a line like this to your package's pubspec.yaml (and run an implicit  `flutter pub get`):

```yaml
dependencies:
  range_calendar: ^0.0.x
```

Alternatively, your editor might support or  `flutter pub get`. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:range_calendar/range_calendar.dart';
```
### Basic setup
_The complete example is available  [here](https://github.com/DanielBaltazarSchneider/range_calendar)._
```dart
RangeCalendar(
	onDateSelected: (DateTime  date) => null,
	onTapRange: (CalendarRangeSelected  range) => null
)
```

![Image](https://firebasestorage.googleapis.com/v0/b/range-calendar-ac38a.appspot.com/o/range_calendar.gif?alt=media&token=317ded7a-b936-4b66-8e59-74e81ab5fc6c)

### Properties:
```dart
final Color backgroundColorCircleDaySelected;
final Color colorTextSelected;
final Color backgroundColorDayNotRanged;
final Color backgroundColorDayIsRanged;
final Color backgroundColorPointerEvent;
final Function onDateSelected;
final Function onTapRange;
final Map<DateTime, List<Widget>> events;
final Widget titleListEvents;
final Color colorIconRangeSelected;
final Color colorIconsRangeNotSelected;
final List<String> listLabelWeekday;
final Color colorLabelWeekday;
final List<String> listOfMonthsOfTheYear;
final bool viewYerOnMonthName;
```
