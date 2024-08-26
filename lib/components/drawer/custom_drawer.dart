import 'package:flutter_application_1/components/drawer/bottom_user_info.dart';
import 'package:flutter_application_1/components/drawer/custom_list_tile.dart';
import 'package:flutter_application_1/components/drawer/header.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 0.932),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDrawerHeader(isColapsed: _isCollapsed),
              const Divider(
                color: Colors.grey,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                onPressed: () {},
                isSelected: null, 
                color: Colors.yellow,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.track_changes,
                title: 'Tracking',
                infoCount: 0,
                onTap: () {
                  Navigator.pushNamed(context, '/tracking');
                },
                isSelected: null,
                onPressed: () {},
                color: Colors.yellow,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.calendar_today,
                title: 'Bookings',
                infoCount: 0,
                onTap: () {
                  Navigator.pushNamed(context, '/booking');
                },
                isSelected: null,
                onPressed: () {},
                color: Colors.yellow,
              ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.car_crash,
                title: 'Ambulance',
                infoCount: 0,
                onTap: () {
                  Navigator.pushNamed(context, '/vehicle');
                },
                isSelected: null,
                onPressed: () {},
                color: Colors.yellow,
              ),
              

              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.message_rounded,
              //   title: 'Messages',
              //   infoCount: 8,
              // ),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.cloud,
              //   title: 'Weather',
              //   infoCount: 0,
              //   doHaveMoreOptions: Icons.arrow_forward_ios,
              // ),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.airplane_ticket,
              //   title: 'Flights',
              //   infoCount: 0,
              //   doHaveMoreOptions: Icons.arrow_forward_ios,
              // ),
              const Divider(color: Colors.grey),
              const Spacer(),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                infoCount: 2,
                onTap: () {},
                isSelected: null,
                onPressed: () {},
                color: Colors.yellow,
              ),
              // CustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.settings,
              //   title: 'Settings',
              //   infoCount: 0,
              //   onTap: () {},
              //   isSelected: null,
              //   onPressed: () {},
              // ),
              CustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.airplane_ticket,
                title: 'Swicth to Driver',
                infoCount: 0,
                doHaveMoreOptions: Icons.arrow_forward_ios,
                onTap: () {},
                isSelected: null,
                onPressed: () {},
                color: Colors.yellow,
              ),
              const SizedBox(height: 10),
              BottomUserInfo(isCollapsed: _isCollapsed, isLoggedIn: false,),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
