
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
  range_calendar: ^0.0.1-dev.1
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

![Image](https://firebasestorage.googleapis.com/v0/b/range-calendar-ac38a.appspot.com/o/Screenshot_1633355046.png?alt=media&token=ae19abf4-b4a0-41be-88e8-d470213d3330)

![Image](https://firebasestorage.googleapis.com/v0/b/range-calendar-ac38a.appspot.com/o/Screenshot_1633355050.png?alt=media&token=a0f7540a-3560-43ae-b884-9c2455f2ac03)

![Image](https://firebasestorage.googleapis.com/v0/b/range-calendar-ac38a.appspot.com/o/Screenshot_1633355052.png?alt=media&token=184dbc79-5a3a-42ed-b11c-7f8b27d093d2)