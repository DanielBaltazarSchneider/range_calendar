library range_calendar;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RangeCalendar extends StatefulWidget {
  const RangeCalendar({
    Key? key,
    required this.onDateSelected,
    required this.onTapRange,
    this.backgroundColorCircleDaySelected = Colors.green,
    this.colorTextSelected = Colors.black,
    this.backgroundColorDayNotRanged = Colors.white,
    this.backgroundColorDayIsRanged = const Color(0xffDCDCDC),
    this.backgroundColorPointerEvent = Colors.red,
    this.colorIconRangeSelected = Colors.green,
    this.colorIconsRangeNotSelected = const Color(0xffDCDCDC),
    this.events = const {},
    this.titleListEvents = const SizedBox(),
    this.colorLabelWeekday = const Color(0xff9E9E9E),
    this.listLabelWeekday = const ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"],
    this.listOfMonthsOfTheYear = const [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ],
    this.viewYerOnMonthName = true,
  }) : super(key: key);
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

  @override
  _RangeCalendarState createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<RangeCalendar> {
  CalendarRangeSelected rangeSelected = CalendarRangeSelected.day;

  List<List<DayCalendar?>> listDayCalendar = [];

  DateTime dateSelected = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime viewMonth = DateTime(DateTime.now().year, DateTime.now().month, 15);

  List<Widget> listWidgetsEvents = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      filterEventsRangeCalendar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    setCalendarFromDate(viewMonth);
    filterEventsRangeCalendar();

    Widget _rowWeek({required Widget child}) => Container(padding: EdgeInsets.only(top: width * 0.01, bottom: width * 0.01), child: child);

    Widget _labelDayWeek({required String label}) => Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "$label",
              style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.bold,
                color: widget.colorLabelWeekday,
              ),
            ),
          ),
        );

    Widget _dayWeek({required bool isSelected, required DayCalendar? date}) => Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(top: 3, bottom: 3),
            decoration: BoxDecoration(
              color: date?.selected ?? false
                  ? rangeSelected == CalendarRangeSelected.day
                      ? widget.backgroundColorDayNotRanged
                      : widget.backgroundColorDayIsRanged
                  : widget.backgroundColorDayNotRanged,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(date!.isEndRange ? 50 : 0),
                bottomRight: Radius.circular(date.isEndRange ? 50 : 0),
                topLeft: Radius.circular(date.isInitRange ? 50 : 0),
                bottomLeft: Radius.circular(date.isInitRange ? 50 : 0),
              ),
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  widget.onDateSelected(date.day);
                  setDate(date.day);
                },
                child: isSelected
                    ? CircleAvatar(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.day.day}",
                              style: TextStyle(
                                color: date.isDaySelected ? Colors.white : widget.colorTextSelected,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (numEventsOnDay(date.day) > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int p = 0; p < numEventsOnDay(date.day); p++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.7, right: 0.7),
                                      child: Icon(
                                        Icons.circle,
                                        size: 4.2,
                                        color: widget.backgroundColorPointerEvent,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                        maxRadius: width * 0.04,
                        backgroundColor: date.isDaySelected ? widget.backgroundColorCircleDaySelected : widget.backgroundColorDayIsRanged,
                      )
                    : CircleAvatar(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${date.day.day}",
                              style: TextStyle(
                                color: date.isOldMonth ? Color(0xff9E9E9E) : Colors.black,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (numEventsOnDay(date.day) > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int p = 0; p < numEventsOnDay(date.day); p++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.7, right: 0.7),
                                      child: Icon(
                                        Icons.circle,
                                        size: 4.2,
                                        color: date.isOldMonth ? Color(0xff9E9E9E) : widget.backgroundColorPointerEvent,
                                      ),
                                    ),
                                ],
                              )
                          ],
                        ),
                        maxRadius: width * 0.04,
                        backgroundColor: widget.backgroundColorDayNotRanged,
                      ),
              ),
            ),
          ),
        );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => subtMonth(),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.02),
                        child: Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: Color(0xff9E9E9E),
                        ),
                      ),
                    ),
                    Text(
                      listDayCalendar.length > 0
                          ? "${setNameMonth(listDayCalendar[1][0]?.day.month ?? 0)} " + " ${widget.viewYerOnMonthName ? listDayCalendar[1][0]?.day.year : ""}"
                          : "",
                      style: TextStyle(fontSize: width * 0.045, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => addMonth(),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.02),
                        child: Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Color(0xff9E9E9E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Dismissible(
                resizeDuration: null,
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    addMonth();
                  } else {
                    subtMonth();
                  }
                },
                key: new ValueKey(Random()),
                child: Column(
                  children: [
                    SizedBox(height: width * 0.02),
                    _rowWeek(
                      child: Row(
                        children: [
                          for (int i = 0; i < 7; i++) ...[
                            _labelDayWeek(label: "${widget.listLabelWeekday[i]}"),
                          ]
                        ],
                      ),
                    ),
                    for (int i = 0; i < listDayCalendar.length; i++) ...[
                      Container(
                        child: Row(
                          children: [
                            for (DayCalendar? day in listDayCalendar[i]) ...[
                              _dayWeek(date: day, isSelected: day?.selected ?? false),
                            ]
                          ],
                        ),
                      )
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => setState(() {
                            rangeSelected = CalendarRangeSelected.day;
                            widget.onTapRange(CalendarRangeSelected.day);
                          }),
                          child: Container(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Icon(
                              MdiIcons.calendar,
                              color: rangeSelected == CalendarRangeSelected.day ? widget.colorIconRangeSelected : widget.colorIconsRangeNotSelected,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            rangeSelected = CalendarRangeSelected.week;
                            widget.onTapRange(CalendarRangeSelected.week);
                          }),
                          child: Container(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Icon(
                              MdiIcons.calendarWeek,
                              color: rangeSelected == CalendarRangeSelected.week ? widget.colorIconRangeSelected : widget.colorIconsRangeNotSelected,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() {
                            rangeSelected = CalendarRangeSelected.month;
                            widget.onTapRange(CalendarRangeSelected.month);
                          }),
                          child: Container(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Icon(
                              MdiIcons.calendarMonth,
                              color: rangeSelected == CalendarRangeSelected.month ? widget.colorIconRangeSelected : widget.colorIconsRangeNotSelected,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            widget.titleListEvents,
          ],
        ),
        for (int i = 0; i < listWidgetsEvents.length; i++) ...[
          listWidgetsEvents[i],
        ],
      ],
    );
  }

  /// returns the name of the month displayed
  String setNameMonth(int month) {
    switch (month) {
      case 1:
        return widget.listOfMonthsOfTheYear[0];
      case 2:
        return widget.listOfMonthsOfTheYear[1];
      case 3:
        return widget.listOfMonthsOfTheYear[2];
      case 4:
        return widget.listOfMonthsOfTheYear[3];
      case 5:
        return widget.listOfMonthsOfTheYear[4];
      case 6:
        return widget.listOfMonthsOfTheYear[5];
      case 7:
        return widget.listOfMonthsOfTheYear[6];
      case 8:
        return widget.listOfMonthsOfTheYear[7];
      case 9:
        return widget.listOfMonthsOfTheYear[8];
      case 10:
        return widget.listOfMonthsOfTheYear[9];
      case 11:
        return widget.listOfMonthsOfTheYear[10];
      case 12:
        return widget.listOfMonthsOfTheYear[11];
      default:
        return "...";
    }
  }

  /// Creates the calendar with all the dates for the selected month
  /// Cria o calendário com todas as datas do mês selecionado
  void setCalendarFromDate(DateTime date) {
    listDayCalendar = [];
    int year = date.year;
    int month = date.month;
    int day = date.day;
    int firstDayWeekMonth = DateTime(year, month, 1).weekday;

    List<DayCalendar?> tempWeek = [];

    /// Add the dates of the previous month to the beginning of the first week
    /// Adiciona as datas do mes anterior no início da primeira semana
    if (firstDayWeekMonth < 7) {
      DateTime lastMonth = DateTime(date.year, date.month, 0);
      int daysRemain = lastMonth.day - firstDayWeekMonth + 1;
      for (int i = daysRemain; i <= lastMonth.day; i++) {
        tempWeek.add(
          DayCalendar(
              // isEndRange: i == lastMonth.day,
              isDaySelected: (DateTime(lastMonth.year, lastMonth.month, i) == DateTime(dateSelected.year, dateSelected.month, dateSelected.day)),
              selected: isDayRangeSelected(DateTime(lastMonth.year, lastMonth.month, i)),
              isOldMonth: true,
              day: DateTime(lastMonth.year, lastMonth.month, i)),
        );
      }
    }

    /// Adiciona as datas do mês selecionado
    /// Add the dates of the selected month
    int lastDay = DateTime(date.year, date.month + 1, 0).day;
    for (int i = 1; i <= lastDay; i++) {
      DayCalendar newDayWeek = DayCalendar(
        isDaySelected: (DateTime(date.year, date.month, i) == DateTime(dateSelected.year, dateSelected.month, dateSelected.day)),
        selected: isDayRangeSelected(DateTime(year, month, i)),
        day: DateTime(year, month, i),
      );

      if (i == lastDay) {
        tempWeek.add(newDayWeek);

        /// Add the dates of the following month to the end of the last week
        /// Adiciona as datas do mes seguinte no final da útima semana
        DateTime newMont = DateTime(date.year, date.month + 1, 1);
        int dayWeekLastDay = DateTime(date.year, date.month + 1, 0).weekday == 7 ? 1 : DateTime(date.year, date.month + 1, 0).weekday + 1;
        for (int a = 1; a <= (7 - dayWeekLastDay); a++) {
          tempWeek.add(
            DayCalendar(
              isDaySelected: (DateTime(newMont.year, newMont.month, a) == DateTime(dateSelected.year, dateSelected.month, dateSelected.day)),
              selected: isDayRangeSelected(DateTime(newMont.year, newMont.month, a)),
              isOldMonth: true,
              day: DateTime(newMont.year, newMont.month, a),
            ),
          );
          // tempWeek.add(null);
        }
        listDayCalendar.add(tempWeek);
        tempWeek = [];
        break;
      }

      tempWeek.add(newDayWeek);
      if (newDayWeek.day.weekday == 6) {
        listDayCalendar.add(tempWeek);
        tempWeek = [];
      }
    }
    setState(() {});
  }

  /// returns true if the date passed as parameter is a date within the selection range
  /// retorna verdadeiro se a data passada como parametro é uma data dentro do intervalo de seleção
  bool isDayRangeSelected(DateTime _date) {
    /// if the selected interval is day
    /// se o intervalo selecionado é dia
    if (rangeSelected == CalendarRangeSelected.month) {
      if (_date.year == dateSelected.year && _date.month == dateSelected.month) {
        return true;
      }
      return false;
    }

    /// if the selected interval is week
    /// se o intervalo selecionado é semana
    if (rangeSelected == CalendarRangeSelected.week) {
      int _dayWeek = dateSelected.weekday == 7 ? 1 : dateSelected.weekday + 1;
      DateTime currentDate = DateTime(dateSelected.year, dateSelected.month, dateSelected.day);
      DateTime _startWeek = currentDate.add(Duration(days: -_dayWeek));
      DateTime _endWeek = currentDate.add(Duration(days: (6 - _dayWeek)));

      if (_date.isAfter(DateTime(_startWeek.year, _startWeek.month, _startWeek.day, 0, 0, 0)) &&
          _date.isBefore(DateTime(_endWeek.year, _endWeek.month, _endWeek.day, 23, 59, 99))) {
        return true;
      }
      return false;
    }

    /// if the selected interval is month
    /// se o intervalo selecionado é mês
    if (rangeSelected == CalendarRangeSelected.day) {
      if (_date.year == dateSelected.year && _date.month == dateSelected.month && _date.day == dateSelected.day) {
        return true;
      }
    }
    return false;
  }

  /// sets the selected date
  /// define a data selecionada
  void setDate(DateTime _date) {
    dateSelected = _date;
    viewMonth = _date;
    setCalendarFromDate(viewMonth);
    listDayCalendar = listDayCalendar;
  }

  /// add a month to the current selected month
  /// adiciona um mes ao mes atual selecionado
  void addMonth() {
    viewMonth = viewMonth.add(Duration(days: 30));
    setCalendarFromDate(viewMonth);
    listDayCalendar = listDayCalendar;
  }

  /// subtracts one month from current selected month
  /// subtrai um mês ao mês atual selecionado
  void subtMonth() {
    viewMonth = viewMonth.add(Duration(days: -30));
    setCalendarFromDate(viewMonth);
    listDayCalendar = listDayCalendar;
  }

  /// returns the number of events on the date given as parameter
  /// retorna o número de eventos na data informada como parametro
  int numEventsOnDay(DateTime? _date) {
    if (widget.events.containsKey(_date)) {
      if (widget.events[_date] != null) {
        int length = widget.events[_date]!.length;
        return length <= 3 ? length : 3;
      }
      return 1;
    }

    return 0;
  }

  /// filters events according to selected range
  /// filtra os eventos de acordo com o intervalo selecionado
  void filterEventsRangeCalendar() {
    /// if the selected interval is day
    ///  se o intervalo selecionado for dia
    if (rangeSelected == CalendarRangeSelected.day) {
      listWidgetsEvents = filterByDay();
      return;
    }

    /// if the selected interval is week
    /// se o intervalo selecionado for semana
    if (rangeSelected == CalendarRangeSelected.week) {
      listWidgetsEvents = filterByWeek();
      return;
    }

    /// if the selected interval is day
    /// se o intervalo selecionado for mês
    if (rangeSelected == CalendarRangeSelected.month) {
      listWidgetsEvents = filterByMonth();
      return;
    }
    listWidgetsEvents = [];
  }

  /// returns events filtered by day
  /// retorna os eventos filtrados pelo dia
  List<Widget> filterByDay() {
    List<Widget> _filtered = [];
    widget.events.forEach((key, value) {
      if (dateIsEqualsDateSelected(key)) {
        _filtered.addAll(value);
      }
    });
    return _filtered;
  }

  /// returns events filtered by week
  /// retorna os eventos filtrados pela semana
  List<Widget> filterByWeek() {
    List<Widget> _filtered = [];
    widget.events.forEach((key, value) {
      if (validateWeek(key)) {
        _filtered.addAll(value);
      }
    });
    return _filtered;
  }

  /// returns events filtered by month
  /// retorna os eventos filtrados pelo mês
  List<Widget> filterByMonth() {
    List<Widget> _filtered = [];
    widget.events.forEach((key, value) {
      if (validateMonth(key)) {
        _filtered.addAll(value);
      }
    });
    return _filtered;
  }

  /// if the date passed as a parameter is equal to the selected date
  /// se a data passada como parametro é igual a data selecionada
  bool dateIsEqualsDateSelected(DateTime _date) {
    return DateTime(_date.year, _date.month, _date.day) == dateSelected;
  }

  /// returns true if the date passed by parameter is within the selected week
  /// retorna verdadeiro se a data passada por parametro está dentro da semana selecionada
  bool validateWeek(DateTime element) {
    DateTime _testDate = DateTime(element.year, element.month, element.day);
    int dayWeek = dateSelected.weekday == 7 ? 1 : dateSelected.weekday + 1;
    DateTime _startWeek = dateSelected.add(Duration(days: -dayWeek));
    DateTime _endWeek = dateSelected.add(Duration(days: 6 - dayWeek));
    if (_testDate.isAfter(DateTime(_startWeek.year, _startWeek.month, _startWeek.day, 0, 0, 0)) &&
        _testDate.isBefore(DateTime(_endWeek.year, _endWeek.month, _endWeek.day, 23, 59, 99))) {
      return true;
    }
    return false;
  }

  /// returns true if the date passed by parameter is within the selected month
  /// retorna verdadeiro se a data passada por parametro está dentro do mês selecionado
  bool validateMonth(DateTime element) {
    DateTime _testDate = DateTime(element.year, element.month, element.day);
    DateTime _initMonth = DateTime(dateSelected.year, dateSelected.month, 1);
    DateTime _endMonth = DateTime(dateSelected.year, dateSelected.month + 1, 0);
    if (_testDate.isAfter(DateTime(_initMonth.year, _initMonth.month, _initMonth.day, 0, 0, 0)) &&
        _testDate.isBefore(DateTime(_endMonth.year, _endMonth.month, _endMonth.day, 23, 59, 99))) {
      return true;
    }

    return false;
  }
}

/// Enum of ranges
/// Enum dos intervalos
enum CalendarRangeSelected {
  day,
  week,
  month,
}

/// Object used to organize data for each date on the calendar
/// Objeto utilizado para organizar os dados de cada data no calendário
class DayCalendar {
  DayCalendar({
    required this.selected,
    required this.day,
    this.isOldMonth = false,
    this.isDaySelected = false,
    this.isInitRange = false,
    this.isEndRange = false,
  });

  bool selected;
  bool isDaySelected;
  bool isOldMonth;
  bool isInitRange;
  bool isEndRange;
  DateTime day;
}
