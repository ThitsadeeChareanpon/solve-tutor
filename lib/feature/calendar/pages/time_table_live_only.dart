import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/controller/create_course_live_controller.dart';
import 'package:solve_tutor/feature/calendar/helper/utility_helper.dart';
import 'package:solve_tutor/feature/calendar/model/course_model.dart';
import 'package:solve_tutor/feature/calendar/pages/utils.dart';
import 'package:solve_tutor/feature/calendar/widgets/alert_overlay.dart';
import 'package:solve_tutor/feature/calendar/widgets/format_date.dart';
import 'package:solve_tutor/feature/calendar/widgets/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeTableLiveOnly extends StatefulWidget {
  TimeTableLiveOnly({Key? key, required this.courseData}) : super(key: key);
  CourseModel courseData;
  @override
  _TimeTableLiveOnlyState createState() => _TimeTableLiveOnlyState();
}

class _TimeTableLiveOnlyState extends State<TimeTableLiveOnly> {
  final _util = UtilityHelper();
  bool light = false;
  ValueNotifier<List<Event>>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
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
    getCalendar();
  }

  void getCalendar() async {
    //ช่วงเวลาเรียนของคอร์ส
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Alert.showOverlay(
          loadingWidget: Alert.getOverlayScreen(),
          context: context,
          asyncFunction: () async {
            await courseController
                .getDataCalendarList(widget.courseData.calendars ?? []);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.grey,
                      ),
                    )),
                _calendar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _calendar() {
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
          rangeSelectionMode: _rangeSelectionMode,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          daysOfWeekHeight: 56,
          rowHeight: 128.4,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: CustomStyles.med16Black363636,
            weekdayStyle: CustomStyles.med16Black363636,
          ),
          calendarStyle: const CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: true,
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
                  padding: const EdgeInsets.only(left: 20, top: 20),
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
                  padding: const EdgeInsets.only(left: 20, top: 20),
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
                      padding: const EdgeInsets.only(left: 20, top: 20),
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
                onPressed: () {},
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  alignment: Alignment.topLeft,
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
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: 200,
                width: 200,
                color: CustomColors.green125924,
                alignment: Alignment.topLeft,
              );
            },
            markerBuilder: (context, day, event) {
              if (event.isNotEmpty && day.isAfter(DateTime.now())) {
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
          style: CustomStyles.bold22Black363636,
        ),
      ),
    );
  }

  Widget _periodTime() {
    return Column(
      children: [
        _topicText('รูปแบบการเรียน'),
        Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(bottom: 16.0),
            //         child: Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             'รูปแบบการสอน*',
            //             style: CustomStyles.med16Black36363606,
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(flex: 1, child: _dropdownFilter()),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ระยะเวลาเรียน*',
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
      onTap: () {
        _showDatePicker(context: context, dateType: 'start');
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
      onTap: () {
        _showDatePicker(context: context, dateType: 'end');
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

  Widget _startTime({DateTime? dateTime}) {
    return Consumer<CourseLiveController>(
      builder: (_, course, child) => TextFormField(
        onTap: () {
          _showTimePicker(
              context: context,
              dateType: 'start',
              time: DateTime(dateTime?.year ?? 0, dateTime?.month ?? 0,
                  dateTime?.day ?? 0, 8, 0),
              setState: setState);
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
        onTap: () {
          _showTimePicker(
              context: context,
              dateType: 'end',
              time: startTime,
              setState: setState);
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

  void _showDatePicker(
      {required BuildContext context, String dateType = 'start'}) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumYear: 2023,
                          minimumDate: dateType == 'end'
                              ? courseController.courseData?.firstDay
                              : null,
                          maximumDate: dateType == 'start'
                              ? courseController.courseData?.lastDay
                              : null,
                          initialDateTime: dateType == 'end'
                              ? courseController.courseData?.firstDay
                              : courseController.courseData?.lastDay,
                          use24hFormat: true,
                          onDateTimeChanged: (val) {
                            if (dateType == 'start') {
                              courseController.startDateController.text =
                                  FormatDate.dayOnlyNumber(val);
                              courseController.courseData?.firstDay = val;
                            } else if (dateType == 'end') {
                              courseController.endDateController.text =
                                  FormatDate.dayOnlyNumber(val);
                              courseController.courseData?.lastDay = val;
                            }
                            setState(() {});
                          }),
                    ),
                    CupertinoButton(
                      child: const Text('ตกลง'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ));
  }

  void _clearTime() {
    courseController.startTimeController.clear();
    courseController.endTimeController.clear();
  }

  void _showTimePicker(
      {required BuildContext context,
      String dateType = 'start',
      DateTime? time,
      required StateSetter setState}) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          use24hFormat: true,
                          initialDateTime: time,
                          minimumDate: dateType == 'end' ? time : null,
                          mode: CupertinoDatePickerMode.time,
                          minuteInterval: 10,
                          onDateTimeChanged: (val) {
                            if (dateType == 'start') {
                              _startSetTime?.clear();
                              startTime = val;
                              // print(val);
                              courseController.startTimeController.text =
                                  FormatDate.timeOnlyNumber(val) +
                                      ' น.'.toString();
                              courseController.endTimeController.clear();
                            }
                            if (dateType == 'end') {
                              _endSetTime?.clear();
                              endTime = val;
                              courseController.endTimeController.text =
                                  FormatDate.timeOnlyNumber(val) +
                                      ' น.'.toString();
                            }
                            setState(() {});
                          }),
                    ),
                    CupertinoButton(
                      child: const Text('ตกลง'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget _slectedDate(DateTime dt) {
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

  void _slectedDatePicker({required BuildContext context}) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          minimumYear: 2023,
                          minimumDate: DateTime.now(),
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (val) {
                            setState(() {
                              courseController.selectedDateController.text =
                                  FormatDate.dayOnlyNumber(val);
                              val;
                            });
                          }),
                    ),
                    CupertinoButton(
                      child: const Text('ตกลง'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ));
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
            )));
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
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     //set border radius more than 50% of height and width to make circle
                  //   ),
                  //   child: Wrap(
                  //     direction: Axis.horizontal,
                  //     children: [
                  //       for (var i in course.days) ...[
                  //         _buttonDay(i, onTap: () {
                  //           setState(() {
                  //             i.selected = !i.selected;
                  //             courseController.startTimeController.clear();
                  //             courseController.endTimeController.clear();
                  //           });
                  //         })
                  //       ]
                  //     ],
                  //   ),
                  // ),
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
                    _slectedDate(dt),
                    S.h(20),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: _startTime(
                              dateTime: dt,
                            )),
                        Container(
                          width: 20.0,
                          alignment: Alignment.center,
                          child: const Text('-'),
                        ),
                        Expanded(
                            flex: 1,
                            child: _endTime(
                              dateTime: dt,
                            )),
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

  Widget _eventList(DateTime day, List<Event>? event) {
    event?.sort((a, b) => a.start.compareTo(b.start));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: Text(
          'ช่วงเวลาวันนี ${FormatDate.dayOnly(day)}',
          style: CustomStyles.bold22Black363636,
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
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.check_circle_outlined,
                          color: CustomColors.greenPrimary,
                          size: 40,
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
                      ),
                    ),
                  )
                ],
              ],
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
              var endtSelected = df.end?.millisecondsSinceEpoch ?? 0;
              return courseController.calendarListAll.any((calendars) {
                var start = calendars.start?.millisecondsSinceEpoch ?? 0;
                var end = calendars.end?.millisecondsSinceEpoch ?? 0;
                // print(
                //     '${calendars.start}  :: ${df.start}  && ${calendars.start} :: ${df.end}');
                var stutasStart =
                    (start >= startSelected && start < endtSelected);
                var stutasEnd = (end > startSelected && end < endtSelected);
                print('${stutasStart}|| ${stutasEnd}');
                if (stutasStart || stutasEnd) {
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
              // print('all ${courseController.calendarListAll.length}');
              // print('light ${light}');
              if (light) {
                await courseController
                    .getDataCalendarList(courseController.calendarListAll);
                setState(() {});
              } else {
                print(courseController.courseData?.calendars?.length);
                // await courseController.getDataCalendarList(
                //     courseController.courseData?.calendars ?? []);
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
              hours: startTime?.hour ?? 0, minutes: startTime?.minute ?? 0));
          var end = startDate.add(Duration(
              hours: endTime?.hour ?? 0, minutes: endTime?.minute ?? 0));
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

  bool _skipWeek(int week, int number) {
    if (week > 1 && week <= number) {
      return false;
    }

    return true;
  }
}

class Days {
  int id;
  String day;
  bool selected;

  Days({
    required this.id,
    required this.day,
    this.selected = false,
  });
}
