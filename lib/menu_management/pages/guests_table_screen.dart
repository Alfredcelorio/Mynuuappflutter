import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/pages/guest_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../authentication/blocs/authentication_bloc.dart';

class GuestsTableScreen extends StatefulWidget {
  const GuestsTableScreen({Key? key}) : super(key: key);

  @override
  State<GuestsTableScreen> createState() => _GuestsTableScreenState();
}

class _GuestsTableScreenState extends State<GuestsTableScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? nowUtc;
  int covers = 0;
  @override
  void initState() {
    super.initState();
    nowUtc = DateTime.now();
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['token'] as String;
    context.read<Providers>().getGuest(role).then((value) {
      covers = filterDate(value, nowUtc!).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Providers>();
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    const borderColor = Color(0xFF646464);
    TableLayoutBloc bloc = context.read<TableLayoutBloc>();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      children: [
        const Center(
          child: Text('Guests List',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: borderColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: buildSearchOptions(context),
            ),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    theme: const DatePickerTheme(
                        headerColor: mynuuBlack,
                        backgroundColor: mynuuBlack,
                        itemStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                        doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                        cancelStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) async {
                  final result = await provider.getGuest(
                      authProvider.idsR.value.first['token'] as String);
                  setState(() {
                    nowUtc = date;
                    covers = filterDate(result, nowUtc!).length;
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: const Center(child: Icon(Icons.calendar_month_outlined)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //_buildTableHeaders(),
        Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text(
                        nowUtc != null
                            ? DateFormat('EEE, MMM d yyyy')
                                .format(nowUtc!)
                                .toString()
                            : DateFormat('EEE, MMM d yyyy')
                                .format(DateTime.now())
                                .toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Metropolis'))),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Covers',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Metropolis')),
                        Row(
                          children: [
                            const Icon(Icons.group),
                            Text(covers.toString(),
                                style: TextStyle(color: Colors.white))
                          ],
                        )
                      ],
                    ))
              ],
            )),
        const SizedBox(height: 5),
        StreamBuilder<List<Guest>>(
          stream: role == 'Staff'
              ? bloc.streamRestaurantGuestsStaff(
                  authProvider.idsR.value.first['token'] as String)
              : bloc.streamRestaurantGuests(),
          builder: (context, snapshot) {
            final guests = snapshot.data;
            if (guests == null) {
              EasyLoading.show(status: '');
              // return const Center(
              //   child: CircularProgressIndicator(
              //     color: Colors.white,
              //   ),
              // );
              return Center();
            }
            EasyLoading.dismiss();
            if (guests.isEmpty) {
              return const Center(
                child: Text(
                  "No guests yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final guestsAux = <Guest>[...guests];
            if (filterDate(guestsAux, nowUtc!).isEmpty) {
              return const Center(
                child: Text(
                  "No guests yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return _buildTableBody(
                filterDate(guestsAux, nowUtc!), context, bloc);
          },
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Restaurant guests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: mynuuYellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaders() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            tableHeader("Name", isHeader: true),
            tableHeader("Contact", isHeader: true),
            tableHeader("Birthday", isHeader: true),
            tableHeader("First visit", isHeader: true),
            tableHeader("Last visit", isHeader: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTableBody(
      List<Guest> guests, BuildContext context, TableLayoutBloc bloc) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTableRows(
        guests
            .where(
              (element) => element.name.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
            )
            .toList(),
        bloc,
      ),
    );
  }

  TableRow _buildSpacerRow() {
    return const TableRow(
      children: [
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows(List<Guest> guests, TableLayoutBloc bloc) {
    List<TableRow> rows = [];
    for (var guest in guests) {
      rows.add(
        _buildTableRow(context, bloc, guest),
      );
      rows.add(_buildSpacerRow());
    }
    return rows;
  }

  TableRow _buildTableRow(
      BuildContext context, TableLayoutBloc bloc, Guest guest) {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
      ),
      children: [
        TableRowInkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider.value(
                  value: bloc,
                  child: GuestDetailScreen(
                    guestId: guest.id,
                  ),
                ),
              ),
            );
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                height: 80,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: Text(
                                    nowUtc != null
                                        ? DateFormat('h:mm a')
                                            .format(guest.lastVisit == null
                                                ? DateTime.now()
                                                : guest.lastVisit!.toDate())
                                            .toString()
                                        : DateFormat('h:mm a')
                                            .format(DateTime.now())
                                            .toString(),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12))),
                            Container(
                              width: 90,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: const [
                                      Icon(Icons.monetization_on_outlined,
                                          size: 18),
                                      Text('-',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Icon(Icons.account_circle_outlined,
                                          size: 18),
                                      Text(guest.numberOfVisits.toString(),
                                          style: const TextStyle(
                                              color: Colors.white))
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: Text(guest.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily: 'Metropolis')))
                      ],
                    )),
              )),
        ),
      ],
    );
  }

  String _getGuestId(Guest guest) {
    if (guest.email == '') {
      return guest.phone ?? '';
    }
    return guest.email;
  }

  Widget buildSearchOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withOpacity(.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: searchController,
          cursorColor: Colors.white,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) {
            //search();
            setState(() {});
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            hintText: "Search guest",
            hintStyle: const TextStyle(
              color: Color(0xffb5b6b8),
            ),
            contentPadding: EdgeInsets.only(top: 1.w, left: 3.w),
          ),
        ),
      ),
    );
  }

  Widget tableHeader(
    String data, {
    bool isHeader = false,
    Color textcolor = Colors.white,
  }) {
    var text = Text(
      data.toString(),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isHeader ? 12 : 10,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.w300,
        color: textcolor,
      ),
    );
    return isHeader
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: text,
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: text,
          );
  }
}
