import 'package:flutter/material.dart';
import 'package:form_validation/src/pages/citas_page.dart';
import 'package:form_validation/src/pages/home_page.dart';

class NavtabPage extends StatefulWidget {
  @override
  // _NavtabPageState createState() => _NavtabPageState();
  State<StatefulWidget> createState() => NavtabPageState();
}

class NavtabPageState extends State<NavtabPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> myTabs = <Tab>[
     Tab(icon: Icon(Icons.account_circle), text: 'Pacientes'),
     Tab(icon: Icon(Icons.calendar_today), text: 'Citas')
  ];

  @override
  void initState() {
    tabController =  TabController(length: myTabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        print("index ${tabController.index}");
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  Text('Dental Perfection'),
        bottom: TabBar(tabs: myTabs, controller: tabController),
      ),
      body:  TabBarView(
        children: [
          HomePage(),
          CitasPage(),
        ],
        controller: tabController,
      ),
    );
  }
}
