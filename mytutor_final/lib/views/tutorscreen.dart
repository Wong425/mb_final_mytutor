import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mytutor_final/models/tutor.dart';
import 'package:mytutor_final/views/profilescreen.dart';
import 'package:mytutor_final/views/registrationscreen.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../constants.dart';
import '../models/customer.dart';
import '../models/tutor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cartscreen.dart';
import 'loginscreen.dart';
import 'orderscreen.dart';

// import 'profilescreen.dart';

class TutorScreen extends StatefulWidget {
  final Customer customer;
  const TutorScreen({
    Key? key,
    required this.customer,
  }) : super(key: key);

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  List<Tutor> tutorList = <Tutor>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  // final df = DateFormat('dd/MM/yyyy hh:mm a');
  var numofpage, curpage = 1;
  var _image;
  int numofitem = 0;
  var color;
  int cart = 0;
  TextEditingController searchController = TextEditingController();
  String search = "";
  String dropdownvalue = 'All';
  int rowcount = 2;
  var types = [
    'All',
    // 'Baby',
    // 'Beverage',
    // 'Bread',
    // 'Breakfast',
    // 'Canned Food',
    // 'Condiment',
    // 'Care Product',
    // 'Dairy',
    // 'Dried Food',
    // 'Grains',
    // 'Frozen',
    // 'Snack',
    // 'Health',
    // 'Meat',
    // 'Miscellaneous',
    // 'Seafood',
    // 'Pet',
    // 'Produce',
    // 'Household',
    // 'Vegetables',
  ];
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadTutor(1, search, "All");
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          TextButton.icon(
            onPressed: () async {
              if (widget.customer.email == "guest@wong.com") {
                _loadOptions();
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              customer: widget.customer,
                            )));
                _loadTutor(1, search, "All");
                // _loadMyCart();
              }
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: Text(widget.customer.cart.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.customer.name.toString()),
              accountEmail: Text(widget.customer.email.toString()),
              currentAccountPicture: ClipOval(
                child: Image.network(
                  CONSTANTS.server +
                      '/279199/final_mbmytutor/assets/profile/${widget.customer.email}.jpg',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 128);
                  },
                ),
              ),
            ),
            _createDrawerItem(
              icon: Icons.tv,
              text: 'tutors',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => TutorScreen(
                              customer: widget.customer,
                            )));
              },
            ),
            _createDrawerItem(
              icon: Icons.local_shipping_outlined,
              text: 'My Cart',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              customer: widget.customer,
                            )));
                _loadTutor(1, search, "All");
                _loadMyCart();
              },
            ),
            _createDrawerItem(
              icon: Icons.supervised_user_circle,
              text: 'My Orders',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => OrderScreen(
                              customer: widget.customer,
                            )));
                _loadTutor(1, search, "All");
                _loadMyCart();
              },
            ),
            _createDrawerItem(
              icon: Icons.verified_user,
              text: 'My Profile',
              onTap: () async {
                Navigator.pop(context);
                if (widget.customer.email == "guest@wong.com") {
                  Fluttertoast.showToast(
                      msg: "Please login/register an account",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      fontSize: 16.0);
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const ProfileScreen()));
              },
            ),
            _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Logout',
              onTap: () {},
            ),
          ],
        ),
      ),
      body: tutorList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: types.map((String char) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: ElevatedButton(
                            child: Text(char),
                            onPressed: () {
                              _loadTutor(1, "", char);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: types.map((String char) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                        child: Text(char),
                        onPressed: () {
                          _loadTutor(1, "", char);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                key: refreshKey,
                onRefresh: () async {
                  _loadTutor(1, search, "All");
                },
                child: GridView.count(
                    crossAxisCount: rowcount,
                    childAspectRatio: (1 / 1),
                    children: List.generate(tutorList.length, (index) {
                      return InkWell(
                        splashColor: Colors.amber,
                        onTap: () => {_loadTutorDetails(index)},
                        child: Card(
                            child: Column(
                          children: [
                            Flexible(
                                flex: 6,
                                child: SizedBox(
                                    height: screenHeight / 2.5,
                                    width: screenWidth,
                                    child: _image == null
                                        ? CachedNetworkImage(
                                          // C:\xampp\htdocs\final_mbmytutor\assets\subjects
                                            imageUrl: CONSTANTS.server +
                                                "/279199/final_mbmytutor/assets/tutors/" +
                                                tutorList[index]
                                                    .tutor_id
                                                    .toString() +
                                                '.jpg',
                                            fit: BoxFit.cover,
                                            width: screenWidth,
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                          ))),
                            Text(
                              tutorList[index].tutor_name.toString(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Column(children: [
                                            Text("Tutor Description " +
                                                tutorList[index]
                                                        .tutor_description
                                                        .toString()),
                                      
                                          ]),
                                        ),
                                        // Expanded(
                                        //     flex: 3,
                                        //     child: IconButton(
                                        //         onPressed: () {
                                        //           _addtocartDialog(index);
                                        //         },
                                        //         icon: const Icon(
                                        //             Icons.shopping_cart))),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        )),
                      );
                    })),
              )),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () =>
                              {_loadTutor(index + 1, "", "All")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _loadTutor(int pageno, String _search, String _type) {
    curpage = pageno;
    numofpage ?? 1;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(msg: 'Loading...', max: 100);
    http.post(
        Uri.parse(CONSTANTS.server + "/279199/final_mbmytutor/php/load_tutor.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
          'type': _type,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        titlecenter = "Timeout Please retry again later";
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutor'] != null) {
          tutorList = <Tutor>[];
          extractdata['tutors'].forEach((v) {
            tutorList.add(Tutor.fromJson(v));
          });
          titlecenter = tutorList.length.toString() + " Tutor Available";
        } else {
          titlecenter = "No Tutor Available";
          tutorList.clear();
        }
        setState(() {});
      } else {
        //do something
        titlecenter = "No Tutor Available";
        tutorList.clear();
        setState(() {});
      }
    });
    pd.close();
  }

  _loadOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Please select",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _onLogin, child: const Text("Login")),
                ElevatedButton(
                    onPressed: _onRegister, child: const Text("Register")),
              ],
            ),
          );
        });
  }

  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Tutor Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/279199/final_mbmytutor/assets/tutors/" +
                      tutorList[index].tutor_id.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  tutorList[index].tutor_name.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Tutor Name: \n" +
                      tutorList[index].tutor_name.toString()),
                  Text("Tutor Description: \n" +
                      tutorList[index].tutor_description.toString()),
                  Text("Tutor Phone Number " +
                      tutorList[index].tutor_phone.toString()),
                  Text("Tutor Email: " +
                      tutorList[index].tutor_email.toString()),
                  // Text("Course Rating: " +
                  //     tutorList[index].courseRating.toString()),
                  // Text("Product Date: " +
                  //     df.format(DateTime.parse(
                  //         productList[index].productDate.toString()))),
                ]),
              ],
            )),
            // actions: [
            //   SizedBox(
            //       width: screenWidth / 1,
            //       child: ElevatedButton(
            //           onPressed: () {
            //             _addtocartDialog(index);
            //           },
            //           child: const Text("Add to cart"))),
            // ],
          );
        });
  }
    void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        child: DropdownButton(
                          value: dropdownvalue,
                          underline: const SizedBox(),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: types.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadTutor(1, search, "All");
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }
  void _onLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _loadMyCart() {
    if (widget.customer.email != "guest@wong.com") {
      http.post(
          Uri.parse(
              CONSTANTS.server + "/279199/final_mbmytutor/php/load_mycartqty.php"),
          body: {
            "email": widget.customer.email.toString(),
          }).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      ).then((response) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (response.statusCode == 200 && jsondata['status'] == 'success') {
          print(jsondata['data']['carttotal'].toString());
          setState(() {
            widget.customer.cart = jsondata['data']['carttotal'].toString();
          });
        }
      });
    }
  }
}