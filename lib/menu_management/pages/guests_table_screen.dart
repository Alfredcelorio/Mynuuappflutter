import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/pages/guest_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GuestsTableScreen extends StatefulWidget {
  const GuestsTableScreen({Key? key}) : super(key: key);

  @override
  State<GuestsTableScreen> createState() => _GuestsTableScreenState();
}

class _GuestsTableScreenState extends State<GuestsTableScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TableLayoutBloc bloc = context.read<TableLayoutBloc>();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: buildSearchOptions(context),
            ),
            Expanded(
              child: ElevatedButton.icon(
                icon: Image.asset('assets/icons/calendar.png'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mynuuYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                label: Text(
                  DateFormat('dd/MM/yyyy').format(
                    DateTime.now(),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        _buildTitle(),
        _buildTableHeaders(),
        StreamBuilder<List<Guest>>(
          stream: bloc.streamRestaurantGuests(),
          builder: (BuildContext context, AsyncSnapshot<List<Guest>> snapshot) {
            final guests = snapshot.data;
            if (guests == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (guests.isEmpty) {
              return const Center(
                child: Text(
                  "No guests yet",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return _buildTableBody(guests, context, bloc);
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
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 8,
        ),
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
      rows.add(
        _buildSpacerRow(),
      );
    }
    return rows;
  }

  TableRow _buildTableRow(
      BuildContext context, TableLayoutBloc bloc, Guest guest) {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(.5),
        borderRadius: BorderRadius.circular(8),
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
          child: tableHeader(
            guest.name,
          ),
        ),
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
          child: tableHeader(
            _getGuestId(guest),
            textcolor: mynuuGreen,
          ),
        ),
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
          child: tableHeader(
            guest.birthdate == null
                ? ''
                : DateFormat('MMM dd').format(guest.birthdate!).toString(),
          ),
        ),
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
          child: tableHeader(
            DateFormat('dd/MM/yyyy HH:mm:ss').format(
              guest.firstVisit!.toDate(),
            ),
            textcolor: mynuuPurple,
          ),
        ),
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
          child: tableHeader(
            DateFormat('dd/MM/yyyy HH:mm:ss').format(
              guest.lastVisit!.toDate(),
            ),
            textcolor: mynuuYellow,
          ),
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
