import 'package:flutter/material.dart';
import 'package:solve_tutor/feature/calendar/constants/constants.dart';
import 'package:solve_tutor/feature/calendar/model/select_option_item.dart';

enum HideFormat { phoneNumber, email, non }

class Dropdown extends StatefulWidget {
  final String hintText;
  final List<SelectOptionItem> items;
  final String errorText;
  String? selectedValue;
  final Function(String?) onChanged;
  HideFormat? hideFormate;

  Dropdown({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.hideFormate,
    this.hintText = '',
    this.errorText = '',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropdownState();
  }
}

class _DropdownState extends State<Dropdown> {
  final FocusNode focusNode = FocusNode();

  String errorText = '';

  @override
  void initState() {
    widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          decoration: const InputDecoration(
            // contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          child: SizedBox(
            height: 20,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.hintText,
                      style: CustomStyles.med14Black363636,
                    ),
                  ),
                  value: widget.selectedValue?.isEmpty == true
                      ? null
                      : widget.selectedValue,
                  isDense: true,
                  isExpanded: true,
                  items: [
                    ..._buildDropdownItem(),
                  ],
                  onChanged: (value) {
                    // setState(() {
                    widget.selectedValue = value;
                    // });
                    widget.onChanged(value);
                  }),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: double.infinity,
          child: widget.errorText == ''
              ? const SizedBox()
              : Text(
                  widget.errorText,
                  style: CustomStyles.med14redB71C1C,
                ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownItem() {
    return widget.items
        .map(
          (e) => DropdownMenuItem(
              value: e.id,
              child: Text(
                '${e.name}',
                style: CustomStyles.med14Black363636,
                overflow: TextOverflow.ellipsis,
              )),
        )
        .toList();
  }
}
