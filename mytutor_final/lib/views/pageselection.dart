// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mytutor_final/views/loginscreen.dart';
import 'package:mytutor_final/views/mainscreen.dart';
import 'package:mytutor_final/views/orderscreen.dart';
import 'package:mytutor_final/views/profilescreen.dart';
import 'package:mytutor_final/views/registrationscreen.dart';
import 'package:mytutor_final/views/subscirbescreen.dart';
import 'package:mytutor_final/views/tutorscreen.dart';

import '../models/customer.dart';
import 'cartscreen.dart';
import 'favouritescreen.dart';

// class MainPage extends StatefulWidget {
//   // final Customer customer;
//   // const MainPage({
//   //   Key? key,
//   //   required this.customer,
//   // }) : super(key: key);
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

class PageSelection extends StatefulWidget {
  final Customer customer;
  const PageSelection({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<PageSelection> createState() => _PageSelectionState();
}

class _PageSelectionState extends State<PageSelection> {
  late final List screens;
  int index = 0;
  @override
  void initState() {
    super.initState();

    screens = [
      MainScreen(
        customer: widget.customer,
      ),
      TutorScreen(
        customer: widget.customer,
      ),
      // CartScreen(customer: widget.customer),
      // OrderScreen(customer: widget.customer),
      // RegistrationScreen(),
      SubscirbeScreen(),
      FavouriteScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        // body: screens[index],
        // body: IndexedStack(index: index, children: screens,),
        bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.amber.shade100,
            ),
            child: NavigationBar(
              backgroundColor: Colors.yellow,
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              selectedIndex: index,
              animationDuration: Duration(seconds: 3),
              destinations: [
                NavigationDestination(icon: Icon(Icons.book), label: 'Course'),
                NavigationDestination(icon: Icon(Icons.class_), label: 'Tutor'),
                // NavigationDestination(
                //     icon: Icon(Icons.shopping_cart), label: 'Cart'),
                //     NavigationDestination(
                //     icon: Icon(Icons.shopping_bag), label: 'Order'),
                //     NavigationDestination(
                //     icon: Icon(Icons.account_balance_outlined), label: 'Register'),
                NavigationDestination(
                    icon: Icon(Icons.bookmark_sharp), label: ' Subcribe'),
                NavigationDestination(
                    icon: Icon(Icons.favorite), label: 'Favourite'),
                NavigationDestination(
                    icon: Icon(Icons.account_box), label: 'Profile'),
              ],
            )));
  }
}
