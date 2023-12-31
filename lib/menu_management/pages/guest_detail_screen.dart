import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/authentication/components/footer.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/services/landing_service.dart';
import 'package:project1/common/services/likesProvider.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/pages/guest_liked_items.dart';
import 'package:project1/menu_management/pages/guest_selected_items.dart';
import 'package:provider/provider.dart';

class GuestDetailScreen extends StatefulWidget {
  const GuestDetailScreen({
    Key? key,
    required this.guestId,
  }) : super(key: key);

  final String guestId;
  @override
  State<GuestDetailScreen> createState() => _GuestDetailScreenState();
}

class _GuestDetailScreenState extends State<GuestDetailScreen> {
  late TableLayoutBloc bloc = context.read<TableLayoutBloc>();
  List<Map<String, dynamic>> notes = [];
  TextEditingController controller = TextEditingController();
  Map<String, dynamic> valueNote = {};
  CloudFirestoreService dataBase = CloudFirestoreService();
  bool? addOrEdit;
  int? clickTableRow;
  @override
  void initState() {
    clickTableRow = -1;
    addOrEdit = false;
    valueNote = {};
    notes = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerLikes = context.watch<LikesProvider>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 6),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                )),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Text(
                'Guest Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder<Guest>(
          stream: bloc.streamGuestById(widget.guestId),
          builder: (context, snapshot) {
            final guest = snapshot.data;
            if (guest == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            notes.clear();
            if (guest.listNotes != null) {
              for (var i = 0; i < guest.listNotes!.length; i++) {
                final valueNote =
                    guest.listNotes!.elementAt(i) as Map<String, dynamic>;
                notes.add(valueNote);
              }
            }
            return ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                      color: const Color.fromRGBO(102, 108, 255, 0.15),
                      child: SizedBox(
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/icons/contact.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            guest.name,
                                            style: const TextStyle(
                                                fontFamily: 'Metropolis',
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/call.png',
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                Text(
                                                  _getGuestId(guest),
                                                  style: const TextStyle(
                                                    fontFamily: 'Metropolis',
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          ))),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildGuestInformationData(guest),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Card(
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.08),
                                child: SizedBox(
                                  height: 70,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'Total Spend',
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/price.png',
                                                  height: 19,
                                                  width: 19,
                                                ),
                                                const Text(
                                                  '---',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontFamily: 'Metropolis',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ))),
                        Expanded(
                            child: Card(
                                color:
                                    const Color.fromRGBO(255, 255, 255, 0.08),
                                child: SizedBox(
                                  height: 70,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'Visits',
                                            style: TextStyle(
                                              fontFamily: 'Metropolis',
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/flag.png',
                                                  height: 19,
                                                  width: 19,
                                                ),
                                                Text(
                                                  guest.numberOfVisits
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontFamily: 'Metropolis',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                )))
                      ],
                    )),
                const SizedBox(height: 5),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )),
                const SizedBox(height: 5),
                _buildGuestInformationData(guest, mode: 'DetailsTwo'),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: SizedBox(
                    width: 10,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 0.05)),
                      onPressed: () async {
                        List<String> likesId = [];
                        if (guest.likeProducts != null) {
                          for (var i = 0; i < guest.likeProducts!.length; i++) {
                            var likeObj = guest.likeProducts!.elementAt(i)
                                as Map<String, dynamic>;
                            likesId.add(likeObj['id']);
                          }
                        }
                        await providerLikes.loadLikesProducts(
                            guest.restaurantId, likesId);
                        // await providerLikes.loadLikesProducts(
                        //     'SSkzsAvWhxPZsKpULXnCKkalSe32',
                        //     ['0QOEj9yRkAJIKOkOMMHz', '6t3c3R80cSAKPpUDTFOW']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Provider.value(
                              value: bloc,
                              child: const LikeItemsClass(),
                            ),
                          ),
                        );
                      },
                      child: const Text('Liked Items'),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  margin: const EdgeInsets.only(top: 5),
                  child: SizedBox(
                    width: 10,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 0.05)),
                      onPressed: () async {
                        List<String> likesId = [];
                        if (guest.likeProducts != null) {
                          for (var i = 0; i < guest.likeProducts!.length; i++) {
                            var likeObj = guest.likeProducts!.elementAt(i)
                                as Map<String, dynamic>;
                            likesId.add(likeObj['id']);
                          }
                        }
                        await providerLikes.loadLikesProducts(
                            guest.restaurantId, likesId);
                        // await providerLikes.loadLikesProducts(
                        //     'SSkzsAvWhxPZsKpULXnCKkalSe32',
                        //     ['0QOEj9yRkAJIKOkOMMHz', '6t3c3R80cSAKPpUDTFOW']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Provider.value(
                              value: bloc,
                              child:
                                  GuestSelectedItems(guestId: widget.guestId),
                            ),
                          ),
                        );
                      },
                      child: const Text('Selected Items'),
                    ),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Center(
                      child: Text(
                        'Notes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )),
                const SizedBox(height: 5),
                if (!addOrEdit!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SizedBox(
                        width: 10,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.05)),
                          onPressed: () {
                            setState(() {
                              addOrEdit = true;
                            });
                          },
                          child: const Icon(
                            Icons.add_box_outlined,
                            color: Colors.white,
                          ),
                        )),
                  ),
                if (addOrEdit!)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, right: 36.0, bottom: 10),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: mynuuDarkGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 30,
                            height: 30,
                            child: IconButton(
                              icon: const Icon(
                                Icons.assignment_add,
                                size: 15,
                              ),
                              onPressed: () async {
                                Timestamp now = Timestamp.now();
                                int idNumber = (notes.length - 1) + 1;
                                if (valueNote.isNotEmpty) {
                                  valueNote['note'] = controller.text;
                                  if (!valueNote.containsKey('date')) {
                                    valueNote['date'] =
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            now.microsecondsSinceEpoch);
                                  } else {
                                    valueNote['date'] =
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            now.microsecondsSinceEpoch);
                                  }
                                  for (var i = 0; i < notes.length; i++) {
                                    if (notes[i]['id'] == valueNote['id']) {
                                      notes[i] = valueNote;
                                      break;
                                    }
                                  }

                                  await dataBase.update(
                                      collectionName: 'guests',
                                      data: {'listNotes': notes},
                                      id: guest.id);
                                  setState(() {
                                    valueNote = {};
                                    controller.clear();
                                    addOrEdit = false;
                                  });
                                } else {
                                  if (controller.text.isNotEmpty) {
                                    notes.add({
                                      'id': idNumber,
                                      'note': controller.text,
                                      'date':
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              now.microsecondsSinceEpoch)
                                    });
                                    await dataBase.update(
                                        collectionName: 'guests',
                                        data: {'listNotes': notes},
                                        id: guest.id);
                                    setState(() {
                                      if (controller.text.isNotEmpty) {
                                        controller.clear();
                                      }
                                      addOrEdit = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: mynuuDarkGrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 30,
                            height: 30,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 15,
                              ),
                              onPressed: () async {
                                setState(() {
                                  if (valueNote.isNotEmpty &&
                                      controller.text.isNotEmpty) {
                                    valueNote.clear();
                                    controller.clear();
                                  }
                                  addOrEdit = false;
                                });
                              },
                            ),
                          )
                        ]),
                  ),
                if (addOrEdit!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        fontFamily: 'Metropolis',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mynuuDarkGrey,
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          gapPadding: 120,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.red),
                          gapPadding: 120,
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: _buildTableBody(notes.reversed.toList(), guest),
                ),
                const SizedBox(
                  height: 80,
                ),
                const Footer(
                  backgroundColor: Colors.black,
                ),
              ],
            );
          }),
    );
  }

  Widget _buildGuestInformationData(Guest guest, {String mode = 'Details'}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Card(
          color: const Color.fromRGBO(255, 255, 255, 0.02),
          child: Container(
              height: mode == 'Details' ? 194 : 110,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E).withOpacity(.28),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    if (mode == 'Details')
                      _buildGuestListTile(
                          title: 'Contact',
                          subtitle: _getGuestId(guest),
                          icon: Icons.contact_mail_outlined,
                          iconBackground: 'assets/icons/contact.png',
                          isCustomIcon: true),
                    if (mode == 'Details')
                      _buildGuestListTile(
                        title: 'Date of Birth',
                        subtitle: guest.birthdate != null
                            ? DateFormat('MMM dd').format(guest.birthdate!)
                            : '--/--/----',
                        icon: Icons.date_range_outlined,
                        iconBackground: 'assets/icons/Icon.png',
                        isCustomIcon: true,
                        customIcon: 'assets/icons/birthday-icon.png',
                      ),
                    if (mode == 'Details')
                      _buildGuestListTile(
                        title: 'First Visit',
                        subtitle: guest.firstVisit != null
                            ? DateFormat('MM/dd/yyyy')
                                .format(guest.firstVisit!.toDate())
                            : '--/--',
                        icon: Icons.date_range,
                        isCustomIcon: true,
                        iconBackground: 'assets/icons/dateFirst.png',
                      ),
                    if (mode == 'Details')
                      _buildGuestListTile(
                        title: 'Last Visit',
                        subtitle: guest.lastVisit != null
                            ? DateFormat('MM/dd/yyyy')
                                .format(guest.lastVisit!.toDate())
                            : '--/--',
                        icon: Icons.calendar_month_outlined,
                        isCustomIcon: true,
                        iconBackground: 'assets/icons/dateEnd.png',
                      ),
                    if (mode == 'DetailsTwo')
                      _buildGuestListTile(
                        title: 'VIP',
                        subtitle: _getGuestId(guest),
                        icon: Icons.diamond_outlined,
                        iconBackground: 'assets/icons/diamond.png',
                        isSwitch: true,
                        switchValue: guest.vip,
                        onSwitchChanged: (value) {
                          bloc.updateGuest(guest.copyWith(vip: value));
                        },
                        isCustomIcon: true,
                        customIcon: 'assets/icons/diamond.png',
                      ),
                    if (mode == 'DetailsTwo')
                      _buildGuestListTile(
                        title: 'Blacklist',
                        subtitle: _getGuestId(guest),
                        icon: Icons.block_outlined,
                        iconBackground: 'assets/icons/blacklist-bg.png',
                        isSwitch: true,
                        switchValue: guest.blacklisted,
                        onSwitchChanged: (value) {
                          bloc.updateGuest(guest.copyWith(blacklisted: value));
                        },
                      ),
                  ],
                ),
              )),
        ));
  }

  Widget _buildGuestListTile({
    required String iconBackground,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isCustomIcon = false,
    String customIcon = '',
    bool isSwitch = false,
    bool? switchValue,
    void Function(bool)? onSwitchChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Stack(
                  children: [
                    Center(
                      child: isCustomIcon
                          ? Image.asset(
                              iconBackground,
                              width: 20,
                              height: 20,
                            )
                          : Icon(
                              icon,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Metropolis',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          isSwitch
              ? SizedBox(
                  height: 20,
                  child: Switch(
                    activeColor: const Color.fromRGBO(160, 160, 160, 1),
                    inactiveThumbColor: const Color.fromRGBO(160, 160, 160, 1),
                    activeTrackColor: mynuuYellow,
                    value: switchValue ?? false,
                    onChanged: (value) {
                      onSwitchChanged!(value);
                      setState(() {});
                    },
                  ),
                )
              : Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: GoogleFonts.georama().fontFamily,
                    color: Colors.white,
                    fontSize: 11,
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildTableBody(List<Map<String, dynamic>> notes, Guest g) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTableRows(notes, g),
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

  TableRow _buildTableRow(Map<String, dynamic> note, Guest g) {
    return TableRow(
      children: [
        TableRowInkWell(
            onTap: () {
              setState(() {
                if (clickTableRow != -1 && clickTableRow == note['id']!) {
                  clickTableRow = -1;
                } else {
                  clickTableRow = note['id']!;
                }
              });
            },
            child: Card(
                color: const Color.fromRGBO(255, 255, 255, 0.02),
                child: SizedBox(
                    height: (note['note'] as String).length > 35 ? 90 : 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  note.containsKey('date')
                                      ? DateFormat('MM/dd/yyyy')
                                          .format(note['date'].toDate())
                                      : '--/--/----',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 177, 176, 176),
                                      fontSize: 12,
                                      fontFamily: 'Metropolis'),
                                ),
                                if (clickTableRow == note['id'])
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: mynuuDarkGrey,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 27,
                                        height: 27,
                                        child: Center(
                                            child: IconButton(
                                          icon: const Icon(
                                            Icons.difference_outlined,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 177, 176, 176),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              addOrEdit = true;
                                              valueNote = note;
                                              controller.text = note['note'];
                                            });
                                          },
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: mynuuDarkGrey,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 27,
                                        height: 27,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever_outlined,
                                            size: 12,
                                            color: Color.fromARGB(
                                                255, 177, 176, 176),
                                          ),
                                          onPressed: () async {
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      mynuuDarkGrey,
                                                  title: const Text('¡Alert!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontFamily:
                                                              'Metropolis')),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: const <Widget>[
                                                        Text(
                                                            '¿Are you sure you want to delete this note?',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                fontFamily:
                                                                    'Metropolis')),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: mynuuRed,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Metropolis')),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                          'Accept',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Metropolis')),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        notes.remove(note);
                                                        await dataBase.update(
                                                            collectionName:
                                                                'guests',
                                                            data: {
                                                              'listNotes': notes
                                                            },
                                                            id: g.id);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            ),
                            Text(
                              note['note'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ]),
                    )))),
      ],
    );
  }

  List<TableRow> _buildTableRows(List<Map<String, dynamic>> notes, Guest g) {
    List<TableRow> rows = [];
    for (var note in notes) {
      rows.add(
        _buildTableRow(note, g),
      );
      rows.add(_buildSpacerRow());
    }
    return rows;
  }

  String _getGuestId(Guest guest) {
    if (guest.email == '') {
      return guest.phone ?? '';
    }
    return guest.email;
  }
}
