import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/model/days.dart';
import 'package:solve_tutor/feature/calendar/pages/utils.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeTableLive extends StatefulWidget {
  const TimeTableLive({
    Key? key,
  }) : super(key: key);

  @override
  _TimeTableLiveState createState() => _TimeTableLiveState();
}

class _TimeTableLiveState extends State<TimeTableLive> {
  final _util = UtilityHelper();
  bool light = false;
  ValueNotifier<List<Event>>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  CourseModel? courseModel;
  var courseController = CourseLiveController();
  List<DateTime>? _startSetTime;
  List<DateTime>? _endSetTime;
  DateTime? startTime;
  DateTime? endTime;

  List<CalendarDate> calendarListAll = [];
  List<CalendarDate> calendarForCourse = [];

  @override
  void initState() {
    super.initState();
    courseController =
        Provider.of<CourseLiveController>(context, listen: false);
    // print(courseController.courseData?.firstDay);
    // print(courseController.courseData?.lastDay);
    // print(courseController.courseData?.calendars);
    getCalendar();
  }

  void getCalendar() async {
    //ช่วงเวลาเรียนของคอร์ส
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Alert.showOverlay(
          loadingWidget: Alert.getOverlayScreen(),
          context: context,
          asyncFunction: () async {
            await courseController.getDataCalendarList(
                courseController.courseData?.calendars ?? []);
            setState(() {});
          });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return courseController.kEvents?[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_selectedEvents?.value.isNotEmpty == true) {
      setState(() {
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents?.value = _getEventsForDay(selectedDay);
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents?.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents?.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents?.value = _getEventsForDay(end);
    }
  }

  _switchCalendar() {
    return Switch(
      value: light,
      activeColor: Colors.white,
      activeTrackColor: CustomColors.greenPrimary,
      onChanged: (bool value) async {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
        if (light) {
          await Alert.showOverlay(
              context: context,
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                await courseController
                    .getDataCalendarList(courseController.calendarListAll);
              });
        } else {
          await Alert.showOverlay(
              context: context,
              loadingWidget: Alert.getOverlayScreen(),
              asyncFunction: () async {
                await courseController.getDataCalendarList(
                    courseController.courseData?.calendars ?? []);
              });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<CourseLiveController>(builder: (_, course, child) {
          return StreamBuilder(
              stream: course.updateStream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _periodTime(),
                      S.h(20),
                      if (_util.isTablet()) ...[
                        // _buttonAddClassTime(),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _topicText('จัดการตารางเรียน'),
                            _buttonAddClassTime(),
                          ],
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          solveIcon(),
                          S.w(20),
                          Text(
                            "ระยะเวลาเรียน:  ${courseController.startDateController.text} - ${courseController.endDateController.text}",
                            textAlign: TextAlign.center,
                            style: CustomStyles.med14Black363636
                                .copyWith(color: CustomColors.gray878787)
                                .copyWith(fontSize: _util.addMinusFontSize(14)),
                          ),
                          Expanded(child: Container()),
                          // if (courseController.filterCreateCalendar == '1' &&
                          //     courseController.startDateController.text.isNotEmpty &&
                          //     courseController.endDateController.text.isNotEmpty) ...[
                          if (_util.isTablet()) ...[
                            _buttonAddClassTime(),
                          ]
                          // ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _switchCalendar(),
                          Text(
                            'แสดงตารางสอนทุกคอร์ส',
                            style: CustomStyles.med14Black363636
                                .copyWith(color: CustomColors.gray878787)
                                .copyWith(fontSize: _util.addMinusFontSize(14)),
                          )
                        ],
                      ),
                      S.h(20),
                      if (courseController
                                  .startDateController.text.isNotEmpty &&
                              courseController
                                  .endDateController.text.isNotEmpty ||
                          courseController.calendarListAll.isNotEmpty) ...[
                        if (_util.isTablet()) ...[
                          _tableCalendarTablet(),
                        ] else ...[
                          tableCalendarMobile()
                        ],
                      ]
                    ],
                    // ],
                  ),
                );
              });
        }),
      ),
    );
  }

  Widget _tableCalendarTablet() {
    return Consumer<CourseLiveController>(builder: (_, course, child) {
      DateTime today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      var firstDay = course.courseData?.firstDay ?? DateTime.now();
      var lastDay = course.courseData?.lastDay ?? DateTime.now();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TableCalendar<Event>(
          availableGestures: AvailableGestures.horizontalSwipe,
          locale: 'en_US',
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: firstDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          daysOfWeekHeight: 56,
          rowHeight: 128.4,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: CustomStyles.weekendStyle,
            weekdayStyle: CustomStyles.med16Black363636,
          ),
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: true,
            tableBorder: TableBorder(
              horizontalInside:
                  BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              verticalInside:
                  BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              left: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              right: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              top: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              bottom: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              if ((today.isAfter(firstDay) || today == firstDay) &&
                  (today.isBefore(lastDay) || today == lastDay)) {
                return TextButton(
                  onPressed: () {
                    _clearTime();
                    courseController.haveErrorText = '';
                    showDialog(
                      context: context,
                      builder: (context) => _addClassTime(day),
                    );
                  },
                  child: Container(
                    color: const Color(0xffB9E7C9),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      day.day.toString(),
                      style: CustomStyles.med16Black363636
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
            outsideBuilder: (context, day, event) {
              if (day.isAfter(today)) {
                return TextButton(
                  onPressed: () {
                    _clearTime();
                    courseController.haveErrorText = '';
                    showDialog(
                      context: context,
                      builder: (context) => _addClassTime(day),
                    );
                  },
                  child: Container(
                    color: const Color(0xffB9E7C9),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      day.day.toString(),
                      style: CustomStyles.med16Black363636
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              } else {
                return Container(
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              }
            },
            disabledBuilder: (context, day, focusedDay) {
              return TextButton(
                onPressed: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: CustomColors.grayF3F3F3,
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.gray878787),
                  ),
                ),
              );
            },
            defaultBuilder: (context, day, event) {
              DateTime selectedDay =
                  DateTime(day.year, day.month, day.day, day.hour);
              if (today.isAfter(selectedDay)) {
                return Container(
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              } // the past
              else {
                return TextButton(
                  onPressed: () {
                    _clearTime();
                    courseController.haveErrorText = '';
                    showDialog(
                      context: context,
                      builder: (context) => _addClassTime(day),
                    );
                  },
                  child: Container(
                    color: const Color(0xffB9E7C9),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      day.day.toString(),
                      style: CustomStyles.med16Black363636
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: 200,
                width: 200,
                color: CustomColors.green125924,
                alignment: Alignment.topLeft,
                // child: Text(
                //   day.day.toString(),
                //   style: CustomStyles.med16Black363636
                //       .copyWith(fontWeight: FontWeight.bold),
                // ),
              );
            },
            markerBuilder: (context, day, event) {
              DateTime markerDay = DateTime(day.year, day.month, day.day);
              if (event.isNotEmpty &&
                  (today.isBefore(markerDay) || (today == markerDay))) {
                return Column(
                  children: [
                    S.h(70),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomColors.gray878787,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          shape: BoxShape.rectangle,
                          color: CustomColors.white),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => _eventList(day, event));
                              setState(() {});
                            },
                            child: Text(
                              '+${event.length} รายการ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomStyles.med12GreenPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } // past marker
              else if (event.isNotEmpty && today.isAfter(markerDay)) {
                return Column(
                  children: [
                    S.h(70),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: CustomColors.gray878787,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          shape: BoxShape.rectangle,
                          color: CustomColors.white),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _eventList(day, event, isPast: true));
                              setState(() {});
                            },
                            child: Text(
                              '+${event.length} รายการ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomStyles.med11gray878787,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      );
    });
  }

  Widget tableCalendarMobile() {
    return Consumer<CourseLiveController>(builder: (_, course, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TableCalendar<Event>(
          availableGestures: AvailableGestures.horizontalSwipe,
          locale: 'en_US',
          firstDay: course.courseData?.firstDay ?? DateTime.now(),
          lastDay: course.courseData?.lastDay ?? DateTime.now(),
          focusedDay: course.courseData?.firstDay ?? DateTime.now(),
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          daysOfWeekHeight: 30,
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: CustomStyles.med16Black363636,
            weekdayStyle: CustomStyles.med16Black363636,
          ),
          calendarStyle: const CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
            tableBorder: TableBorder(
                horizontalInside:
                    BorderSide(width: 1, color: CustomColors.grayCFCFCF),
                verticalInside:
                    BorderSide(width: 1, color: CustomColors.grayCFCFCF),
                left: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
                right: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
                top: BorderSide(width: 1, color: CustomColors.grayCFCFCF),
                bottom: BorderSide(
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
          onDaySelected: _onDaySelected,
          onRangeSelected: _onRangeSelected,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // _focusedDay = focusedDay;
          },
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              return TextButton(
                onPressed: () {},
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            outsideBuilder: (context, day, event) {
              return Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: CustomColors.grayF3F3F3,
                  ),
                  alignment: Alignment.topCenter,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.gray878787),
                  ));
            },
            disabledBuilder: (context, day, focusedDay) {
              return TextButton(
                  onPressed: () {},
                  child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: CustomColors.grayF3F3F3,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        day.day.toString(),
                        style: CustomStyles.med16Black363636.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.gray878787),
                      )));
            },
            defaultBuilder: (context, day, event) {
              return TextButton(
                onPressed: () {
                  _clearTime();
                  courseController.haveErrorText = '';
                  showDialog(
                    context: context,
                    builder: (context) => _addClassTime(day),
                  );
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    day.day.toString(),
                    style: CustomStyles.med16Black363636
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                height: 200,
                width: 200,
                color: CustomColors.green125924,
                alignment: Alignment.topLeft,
                // child: Text(
                //   day.day.toString(),
                //   style: CustomStyles.med16Black363636
                //       .copyWith(fontWeight: FontWeight.bold),
                // ),
              );
            },
            markerBuilder: (context, day, event) {
              if (event.isNotEmpty && day.isAfter(DateTime.now())) {
                return Column(
                  children: [
                    S.h(20),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 5.0, vertical: 5.0),
                    //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: CustomColors.gray878787,
                    //         width: 1,
                    //       ),
                    //       borderRadius:
                    //           const BorderRadius.all(Radius.circular(20.0)),
                    //       shape: BoxShape.rectangle,
                    //       color: CustomColors.white),
                    //   alignment: Alignment.center,
                    //   child: Column(
                    //     children: [
                    //       InkWell(
                    //         onTap: () async {
                    //           await showDialog(
                    //               context: context,
                    //               builder: (context) => _eventList(day, event));
                    //           setState(() {});
                    //         },
                    //         child: Text(
                    //           '+${event.length} รายการ',
                    //           maxLines: 1,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: CustomStyles.med12GreenPrimary,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => _eventList(day, event));
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 7,
                        width: 5,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.greenPrimary),
                      ),
                    )
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buttonAddClassTime() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: Text(
          "เพิ่มเวลาเรียน",
          style: CustomStyles.med14White.copyWith(
            color: CustomColors.white,
          ),
        ),
        onPressed: () async {
          courseController.startTimeController.clear();
          courseController.endTimeController.clear();
          courseController.haveErrorText = '';
          await showDialog(
            context: context,
            builder: (context) => _filterForm(),
          );
          // courseController.courseData?.calendars = null;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.greenPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _topicText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: _util.isTablet()
              ? CustomStyles.bold22Black363636
              : CustomStyles.bold18Black363636,
        ),
      ),
    );
  }

  Widget _periodTime() {
    return Column(
      children: [
        _topicText('ตั้งค่าตารางสอน'),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'วันเริ่มและสิ้นสุดคอร์ส*',
                        style: CustomStyles.med16Black36363606,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(flex: 1, child: _startDate()),
                      S.w(10),
                      Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: const Text('-'),
                      ),
                      S.w(10),
                      Expanded(flex: 1, child: _endDate()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _startDate() {
    return TextFormField(
      onTap: () async {
        /// TODO: reconsider changing start date of ongoing course
        // if (courseController.courseData != null &&
        //     courseController.courseData!.firstDay!.isBefore(DateTime.now())) {
        //   return;
        // }
        DateTime? getDate = await showPopupSelectDate(context,
            firstDate: courseController.courseData?.firstDay);
        if (getDate == null) return;
        courseController.startDateController.text =
            FormatDate.dayOnlyNumber(getDate);
        courseController.courseData?.firstDay = getDate;
        courseController.refresh();
      },
      controller: courseController.startDateController,
      decoration: const InputDecoration(
        hintText: 'วันที่เริ่มเรียน',
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      readOnly: true,
      onChanged: (value) {},
    );
  }

  Widget _endDate() {
    return TextFormField(
      onTap: () async {
        // _showDatePicker(context: context, dateType: 'end');
        DateTime? getDate = await showPopupSelectDate(context,
            firstDate: courseController.courseData?.firstDay);
        if (getDate == null) return;
        courseController.endDateController.text =
            FormatDate.dayOnlyNumber(getDate);
        courseController.courseData?.lastDay = getDate;
        courseController.refresh();
      },
      controller: courseController.endDateController,
      decoration: const InputDecoration(
        hintText: 'วันที่เรียนจบ',
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      readOnly: true,
      onChanged: (value) {},
    );
  }

  Future<DateTime?> showPopupSelectDate(BuildContext context,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime now = DateTime.now();
    initialDate ??= now;
    lastDate ??= now.add(const Duration(days: 366));
    if (firstDate == null) {
      firstDate = now;
    } else if (firstDate.isAfter(now)) {
      initialDate = firstDate;
      firstDate = now;
    }
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    return picked;
  }

  Future<dynamic> showPopupSelectTime(
    BuildContext context,
  ) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    return picked;
  }

  Widget _startTime({DateTime? dateTime}) {
    return Consumer<CourseLiveController>(
      builder: (_, course, child) => TextFormField(
        onTap: () async {
          DateTime date = dateTime ?? DateTime.now();
          TimeOfDay? time = await showPopupSelectTime(context);
          if (time == null) return;
          DateTime selectedTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _startSetTime?.clear();
          startTime = selectedTime;
          courseController.startTimeController.text =
              FormatDate.timeOnlyNumber(selectedTime) + ' น.'.toString();
        },
        controller: course.startTimeController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
        ),
        readOnly: true,
        onChanged: (value) {},
      ),
    );
  }

  Widget _endTime({DateTime? dateTime}) {
    return Consumer<CourseLiveController>(
      builder: (_, course, child) => TextFormField(
        onTap: () async {
          DateTime date = dateTime ?? DateTime.now();
          TimeOfDay? time = await showPopupSelectTime(context);
          if (time == null) return;
          DateTime selectedTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _endSetTime?.clear();
          endTime = selectedTime;
          courseController.endTimeController.text =
              FormatDate.timeOnlyNumber(selectedTime) + ' น.'.toString();
        },
        controller: course.endTimeController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
        ),
        readOnly: true,
        onChanged: (value) {},
      ),
    );
  }

  void _clearTime() {
    courseController.startTimeController.clear();
    courseController.endTimeController.clear();
  }

  Widget _selectedDate(DateTime dt) {
    courseController.selectedDateController.text = FormatDate.dayOnlyNumber(dt);

    return TextFormField(
      onTap: () {
        // _slectedDatePicker(
        //   context: context,
        // );
      },
      controller: courseController.selectedDateController,
      decoration: const InputDecoration(
        hintText: '',
        suffixIcon: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      readOnly: true,
      onChanged: (value) {},
    );
  }

  Widget _buttonDay(
    Days days, {
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.grayCFCFCF,
            width: 1,
          ),
          color: days.selected == true
              ? CustomColors.green20B153.withOpacity(0.8)
              : CustomColors.white,
          borderRadius: days.day == 'อา'
              ? const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0))
              : days.day == 'ส'
                  ? const BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0))
                  : BorderRadius.circular(0.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Text(
          days.day,
          style: CustomStyles.med16Black363636.copyWith(
            color: days.selected == true
                ? CustomColors.white
                : CustomColors.gray363636,
          ),
        ),
      ),
    );
  }

  Widget _filterForm() {
    return Consumer<CourseLiveController>(builder: (_, course, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ระยะเวลาเรียน:  ${courseController.startDateController.text} - ${courseController.endDateController.text}",
                    textAlign: TextAlign.center,
                    style: CustomStyles.med14Black363636
                        .copyWith(color: CustomColors.gray878787)
                        .copyWith(fontSize: _util.addMinusFontSize(16)),
                  ),
                  // Row(
                  //   children: [
                  //     Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         'เกิดซ้ำทุก',
                  //         style: CustomStyles.med16Black36363606,
                  //       ),
                  //     ),
                  //     S.w(20.0),
                  //     Expanded(
                  //       flex: 2,
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //         child: TextFormField(
                  //           controller: courseController.skipWeekTextEditing,
                  //           keyboardType: TextInputType.number,
                  //           textAlign: TextAlign.end,
                  //           decoration: const InputDecoration(
                  //             labelText: '',
                  //             border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.all(
                  //                 Radius.circular(8.0),
                  //               ),
                  //             ),
                  //           ),
                  //           inputFormatters: [
                  //             LengthLimitingTextInputFormatter(1),
                  //             FilteringTextInputFormatter.allow(
                  //                 RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                  //             TextInputFormatter.withFunction(
                  //               (oldValue, newValue) => newValue.copyWith(
                  //                 text: newValue.text.replaceAll('.', ','),
                  //               ),
                  //             ),
                  //           ],
                  //           onChanged: (value) {},
                  //         ),
                  //       ),
                  //     ),
                  //     S.w(20.0),
                  //     Text(
                  //       'สัปดาห์',
                  //       style: CustomStyles.med16Black36363606,
                  //     ),
                  //     Expanded(flex: 2, child: Container()),
                  //   ],
                  // ),
                  S.h(20.0),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        for (var i in course.days) ...[
                          _buttonDay(i, onTap: () {
                            setState(() {
                              i.selected = !i.selected;
                              courseController.startTimeController.clear();
                              courseController.endTimeController.clear();
                            });
                          })
                        ]
                      ],
                    ),
                  ),
                  S.h(20.0),
                  Row(
                    children: [
                      Expanded(flex: 1, child: _startTime()),
                      Container(
                        width: 20.0,
                        alignment: Alignment.center,
                        child: const Text('-'),
                      ),
                      Expanded(flex: 1, child: _endTime()),
                    ],
                  ),
                  S.h(20),
                  if (course.haveErrorText.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(courseController.haveErrorText,
                            textAlign: TextAlign.center,
                            style: CustomStyles.reg16gray878787
                                .copyWith(color: Colors.red)),
                      ],
                    ),
                    S.h(20),
                  ],

                  Row(
                    children: [_backTo(), S.w(10), _buttonFilterCreateClass()],
                  ),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _addClassTime(DateTime dt) {
    return Consumer<CourseLiveController>(builder: (_, course, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _selectedDate(dt),
                    S.h(20),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _startTime(
                            dateTime: dt,
                          ),
                        ),
                        Container(
                          width: 20.0,
                          alignment: Alignment.center,
                          child: const Text('-'),
                        ),
                        Expanded(
                          flex: 1,
                          child: _endTime(
                            dateTime: dt,
                          ),
                        ),
                      ],
                    ),
                    S.h(20),
                    if (course.haveErrorText.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            courseController.haveErrorText,
                            textAlign: TextAlign.center,
                            style: CustomStyles.reg16gray878787.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      S.h(20),
                    ],
                    Row(
                      children: [_backTo(), S.w(10), _buttonCreateClass(dt)],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _eventList(DateTime day, List<Event>? event, {bool isPast = false}) {
    event?.sort((a, b) => a.start.compareTo(b.start));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: Text(
          'คอร์สในวันที่ ${FormatDate.dayOnly(day)}',
          style: _util.isTablet()
              ? CustomStyles.bold22Black363636
              : CustomStyles.bold18Black363636,
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: CustomColors.grayE5E6E9,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text(
                "ปิดหน้านี้",
                style: CustomStyles.med14Gray878787,
              ),
            ),
          )
        ],
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (event?.isEmpty == true) ...[
                    const Center(
                      child: SizedBox(
                        child: Text('ไม่พบตารางเรียน'),
                      ),
                    )
                  ],
                  S.h(10),
                  for (Event i in event ?? [] as List<Event>) ...[
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      elevation: 5,
                      child: SizedBox(
                        // padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.check_circle_outlined,
                            color: CustomColors.greenPrimary,
                            size: _util.isTablet() ? 40 : 30,
                          ),
                          title: Text(
                            i.courseName,
                            style: CustomStyles.blod16gray878787,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            i.title,
                            overflow: TextOverflow.ellipsis,
                            style: CustomStyles.blod16gray878787,
                          ),
                          trailing: i.courseId ==
                                      courseController.courseData?.id &&
                                  !isPast
                              ? TextButton(
                                  onPressed: () async {
                                    var result2 = courseController
                                        .courseData?.calendars
                                        ?.where((element) =>
                                            element.courseId ==
                                                courseController
                                                    .courseData?.id &&
                                            element.start?.compareTo(i.start) ==
                                                0 &&
                                            element.end?.compareTo(i.end) == 0)
                                        .toList();
                                    if (result2?.isNotEmpty == true) {
                                      for (var i in result2 ?? []) {
                                        courseController.courseData?.calendars
                                            ?.remove(i);
                                        courseController.calendarListAll
                                            .remove(i);
                                      }
                                      event?.remove(i);
                                      setState(() {});
                                    }
                                  },
                                  child: Text(
                                    'ลบ',
                                    textAlign: TextAlign.center,
                                    style: CustomStyles.blod16gray878787
                                        .copyWith(color: Colors.red),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buttonCreateClass(DateTime dt) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.green20B153,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          // if (courseController.startTimeController.text.isNotEmpty &&
          //     courseController.endTimeController.text.isNotEmpty) {
          //   var filteSelectedDay = courseController.courseData?.calendars
          //       ?.where((element) =>
          //           DateTime(element.start!.year, element.start!.month,
          //                   element.start!.day)
          //               .compareTo(DateTime(dt.year, dt.month, dt.day)) ==
          //           0);
          //   var startSlected = startTime?.millisecondsSinceEpoch ?? 0;
          //   var endSlected = endTime?.millisecondsSinceEpoch ?? 0;
          //   final dontAddTime = filteSelectedDay?.map((element) {
          //     var start = element.start?.millisecondsSinceEpoch ?? 0;
          //     var end = element.end?.millisecondsSinceEpoch ?? 0;
          //     // '${(element.start?.isBefore(startTime!) == true) && (element.end?.isAfter(startTime!) == true)} || ${((element.start?.isBefore(endTime!) == true) && (element.end?.isAfter(endTime!) == true))}');
          //     bool starts = ((start >= startSlected) == true &&
          //         (start < endSlected) == true);
          //     bool ends =
          //         ((end > startSlected) == true && (end < endSlected) == true);
          //     print('${starts}|| ${ends}');
          //     if (starts || ends) {
          //       return true;
          //     } else {
          //       return false;
          //     }
          //   }).toList();

          //   if (dontAddTime?.contains(true) == true) {
          //     courseController.setHaveError('ช่วงเวลานี้ถูกจองเเล้ว');
          //   } else {
          //     courseController.setHaveError('');
          //     courseController.courseData?.calendars?.add(CalendarDate(
          //         start: startTime,
          //         end: endTime,
          //         courseId: courseController.courseData?.id,
          //         courseName: courseController.courseData?.courseName));
          //     await courseController.getDataCalendarList(
          //         courseController.courseData?.calendars ?? []);
          //     Navigator.of(context).pop();
          //   }
          // } else {
          //   courseController.setHaveError('กรุณาเลือกช่วงเวลา');
          // }
          if (courseController.startTimeController.text.isNotEmpty &&
              courseController.endTimeController.text.isNotEmpty) {
            var filteSelectedDay = courseController.calendarListAll.where(
                (element) =>
                    DateTime(element.start!.year, element.start!.month,
                            element.start!.day)
                        .compareTo(DateTime(dt.year, dt.month, dt.day)) ==
                    0);
            var startSlected = startTime?.millisecondsSinceEpoch ?? 0;
            var endSlected = endTime?.millisecondsSinceEpoch ?? 0;
            final dontAddTime = filteSelectedDay.map((element) {
              var start = element.start?.millisecondsSinceEpoch ?? 0;
              var end = element.end?.millisecondsSinceEpoch ?? 0;
              // '${(element.start?.isBefore(startTime!) == true) && (element.end?.isAfter(startTime!) == true)} || ${((element.start?.isBefore(endTime!) == true) && (element.end?.isAfter(endTime!) == true))}');
              bool starts = ((start >= startSlected) == true &&
                  (start < endSlected) == true);
              bool ends =
                  ((end > startSlected) == true && (end < endSlected) == true);
              // print('${starts}|| ${ends}');
              if (starts || ends) {
                return true;
              } else {
                return false;
              }
            }).toList();

            if (dontAddTime.contains(true) == true) {
              courseController.setHaveError('ช่วงเวลานี้ถูกจองเเล้ว');
            } else {
              courseController.courseData?.calendars ??= [];
              courseController.setHaveError('');
              print('all ${courseController.calendarListAll.length}');
              var calendarData = CalendarDate(
                  start: startTime,
                  end: endTime,
                  courseId: courseController.courseData?.id,
                  courseName: courseController.courseData?.courseName);
              courseController.calendarListAll.add(calendarData);
              courseController.courseData?.calendars?.add(calendarData);
              print('all ${courseController.calendarListAll.length}');
              print('light ${light}');
              if (light) {
                await courseController
                    .getDataCalendarList(courseController.calendarListAll);
                setState(() {});
              } else {
                await courseController.getDataCalendarList(
                    courseController.courseData?.calendars ?? []);
                setState(() {});
              }
              Navigator.of(context).pop();
            }
          } else {
            courseController.setHaveError('กรุณาเลือกช่วงเวลา');
          }
        },
        child: Text(
          "เพิ่ม",
          style: CustomStyles.med14White,
        ),
      ),
    );
  }

  Widget _buttonFilterCreateClass() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.green20B153,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () async {
          var selectedDay =
              courseController.days.map((e) => e.selected).toList();
          if (selectedDay.contains(true) &&
              courseController.startTimeController.text.isNotEmpty &&
              courseController.endTimeController.text.isNotEmpty) {
            var dayFilterList = await getWeekdaysBetweenDates();
            var dontAddTime = dayFilterList.where((df) {
              var startSelected = df.start?.millisecondsSinceEpoch ?? 0;
              var endSelected = df.end?.millisecondsSinceEpoch ?? 0;
              return courseController.calendarListAll.any((calendars) {
                var start = calendars.start?.millisecondsSinceEpoch ?? 0;
                var end = calendars.end?.millisecondsSinceEpoch ?? 0;
                // print(
                //     '${calendars.start}  :: ${df.start}  && ${calendars.start} :: ${df.end}');
                var statusStart =
                    (start >= startSelected && start < endSelected);
                var stutasEnd = (end > startSelected && end < endSelected);
                print('${statusStart}|| ${stutasEnd}');
                if (statusStart || stutasEnd) {
                  return true;
                } else {
                  return false;
                }
              });
            }).toList();

            if (dontAddTime.isNotEmpty) {
              courseController.setHaveError(
                  'ช่วงเวลาซ้ำ ${FormatDate.dayOnly(dontAddTime.first.start)}');
            } else {
              courseController.courseData?.calendars ??= [];
              courseController.setHaveError('');
              print('all ${courseController.calendarListAll.length}');
              // var calendarData = CalendarDate(
              //     start: startTime,
              //     end: endTime,
              //     courseId: courseController.courseData?.id,
              //     courseName: courseController.courseData?.courseName);
              for (var calendar in dayFilterList) {
                courseController.calendarListAll.add(calendar);
                courseController.courseData?.calendars?.add(calendar);
              }

              if (light) {
                await courseController
                    .getDataCalendarList(courseController.calendarListAll);
                setState(() {});
              } else {
                print(courseController.courseData?.calendars?.length);
                await courseController.getDataCalendarList(
                    courseController.courseData?.calendars ?? []);
                setState(() {});
              }
              Navigator.of(context).pop();
            }
          } else {
            courseController.setHaveError('กรุณาเลือกช่วงเวลา');
          }
        },
        child: Text(
          "เพิ่ม",
          style: CustomStyles.med14White,
        ),
      ),
    );
  }

  Widget _backTo() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        child: Text(
          "ย้อนกลับ",
          style: CustomStyles.med14Gray878787,
        ),
      ),
    );
  }

  Future<List<CalendarDate>> getWeekdaysBetweenDates() async {
    DateTime? startDate =
        courseController.courseData?.firstDay?.add(const Duration(days: -1));
    DateTime? endDate = courseController.courseData?.lastDay;
    List<CalendarDate> filterList = [];
    var selectedDay =
        courseController.days.where((e) => e.selected == true).toList();
    while (startDate!.isBefore(endDate!)) {
      startDate = startDate.add(const Duration(days: 1));
      for (int day = 0; day < selectedDay.toList().length; day++) {
        if (startDate.weekday == selectedDay[day].id) {
          // print('${startDate}');
          var start = startDate.add(Duration(
              // days: 1,
              hours: startTime?.hour ?? 0,
              minutes: startTime?.minute ?? 0));
          var end = startDate.add(Duration(
              // days: 1,
              hours: endTime?.hour ?? 0,
              minutes: endTime?.minute ?? 0));
          filterList.add(CalendarDate(
              start: start,
              end: end,
              courseId: courseController.courseData?.id,
              courseName: courseController.courseData?.courseName));
        }
      }
    }

    return filterList;
  }

  // bool _skipWeek(int week, int number) {
  //   if (week > 1 && week <= number) {
  //     return false;
  //   }
  //
  //   return true;
  // }
}
