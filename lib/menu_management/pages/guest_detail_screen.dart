import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project1/authentication/components/footer.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Guest Profile',
          style: TextStyle(
            fontFamily: GoogleFonts.georama().fontFamily,
          ),
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
            return ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/guest-avatar.png',
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    guest.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: GoogleFonts.georama().fontFamily,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _getGuestId(guest),
                    style: TextStyle(
                      fontFamily: GoogleFonts.georama().fontFamily,
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (guest.birthdate != null)
                  Center(
                    child: Text(
                      DateFormat('MMM dd').format(guest.birthdate!).toString(),
                      style: TextStyle(
                        fontFamily: GoogleFonts.georama().fontFamily,
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 27,
                ),
                _buildGuestInformationData(guest),
                const Padding(
                  padding: EdgeInsets.all(36.0),
                  child: Text(
                    'ACTIVITY',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatisticDataContainer(
                          'ORDERS',
                          '-',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: _buildStatisticDataContainer(
                              'TOTAL SPEND', '-',
                              valueColor: mynuuYellow)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: _buildStatisticDataContainer(
                          'VISITS',
                          '-',
                          valueColor: mynuuPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(36.0),
                  child: Text(
                    'NOTE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit duis nisi urna ornare nunc mauris turpis. Phasellus integer tellus vitae non non congue. Donec interdum tristique odio turpis faucibus curabitur tempus ipsum sagittis. In nulla nunc, habitant consequat viverra donec gravida posuere adipiscing. Id volutpat arcu tincidunt sit massa',
                    style: TextStyle(
                      fontFamily: GoogleFonts.georama().fontFamily,
                      color: const Color(0xFF646464),
                      fontSize: 11,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(36.0),
                  child: Text(
                    'TAGS',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Chip(
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 80,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: mynuuGreen,
                              ),
                              Text(
                                'allergy',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.georama().fontFamily,
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: const Color(0xFF1E1E1E),
                      ),
                      Chip(
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 70,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: mynuuGreen,
                              ),
                              Expanded(
                                child: Text(
                                  'friends',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.georama().fontFamily,
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: const Color(0xFF1E1E1E),
                      ),
                      Chip(
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 80,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: mynuuYellow,
                              ),
                              Text(
                                'Birthday',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.georama().fontFamily,
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: const Color(0xFF1E1E1E),
                      ),
                    ],
                  ),
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

  Widget _buildStatisticDataContainer(
    String title,
    String value, {
    Color valueColor = mynuuGreen,
  }) {
    return Container(
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withOpacity(.28),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GoogleFonts.georama().fontFamily,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 20,
              fontFamily: GoogleFonts.georama().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestInformationData(Guest guest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E).withOpacity(.28),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _buildGuestListTile(
              title: 'Mail Address',
              subtitle: _getGuestId(guest),
              icon: Icons.mail_outlined,
              iconBackground: 'assets/icons/email-bg.png',
            ),
            _buildGuestListTile(
              title: 'Date of Birth',
              subtitle: guest.birthdate != null
                  ? DateFormat('MMM dd').format(guest.birthdate!)
                  : '--/--',
              icon: Icons.mail_outlined,
              iconBackground: 'assets/icons/birthday-bg.png',
              isCustomIcon: true,
              customIcon: 'assets/icons/birthday-icon.png',
            ),
            _buildGuestListTile(
              title: 'VIP',
              subtitle: '',
              icon: Icons.mail_outlined,
              iconBackground: 'assets/icons/vip-bg.png',
              isCustomIcon: true,
              customIcon: 'assets/icons/vip-icon.png',
            ),
            _buildGuestListTile(
              title: 'VIP MODE',
              subtitle: _getGuestId(guest),
              icon: Icons.mail_outlined,
              iconBackground: 'assets/icons/vipmode-bg.png',
              isSwitch: true,
              switchValue: guest.vip,
              onSwitchChanged: (value) {
                bloc.updateGuest(guest.copyWith(vip: value));
              },
              isCustomIcon: true,
              customIcon: 'assets/icons/vipmode-icon.png',
            ),
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
      ),
    );
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
                    Image.asset(
                      iconBackground,
                    ),
                    Center(
                      child: isCustomIcon
                          ? Image.asset(customIcon)
                          : Icon(
                              icon,
                              color: Colors.white,
                              size: 12,
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
                    activeTrackColor: mynuuYellow,
                    value: switchValue ?? false,
                    onChanged: (value) {
                      onSwitchChanged!(value);
                      setState(() {});
                    },
                    activeColor: Colors.white,
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

  String _getGuestId(Guest guest) {
    if (guest.email == '') {
      return guest.phone ?? '';
    }
    return guest.email;
  }
}
