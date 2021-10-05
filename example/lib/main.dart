import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:range_calendar/range_calendar.dart';

void main() => runApp(MaterialApp(
      home: HomeView(),
    ));

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map<DateTime, List<Widget>> events = {};

  List<String> listOfMonthsOfTheYear = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];
  List<String> listLabelWeekday = ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SAB"];

  @override
  void initState() {
    setState(() {
      events[DateTime(2021, 10, 3)] = [generateWidget("Futebol"), generateWidget("Volei"), generateWidget("Futsal"), generateWidget("Xadrez")];
      events[DateTime(2021, 10, 4)] = [generateWidget("Flutter"), generateWidget("Dart")];
      events[DateTime(2021, 10, 12)] = [generateWidget("Faculdade"), generateWidget("Trabalho")];
    });
    super.initState();
  }

  Widget generateWidget(String title) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventView(titleEvent: title),
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 25),
              CircleAvatar(
                child: Text(
                  "${title.substring(0, 1)}".toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey.shade200,
              ),
              SizedBox(width: 25),
              Text("$title"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Range Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RangeCalendar(
              onDateSelected: (DateTime date) => null,
              onTapRange: (CalendarRangeSelected range) => null,
              events: events,
              titleListEvents: Padding(
                padding: const EdgeInsets.all(15),
                child: Text("EVENTOS"),
              ),
              listLabelWeekday: listLabelWeekday,
              viewYerOnMonthName: true,
              listOfMonthsOfTheYear: listOfMonthsOfTheYear,
            ),
          ],
        ),
      ),
    );
  }
}

class EventView extends StatelessWidget {
  const EventView({Key? key, required this.titleEvent}) : super(key: key);
  final String titleEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Event"),
      ),
      body: Center(
        child: Text(
          "$titleEvent",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
