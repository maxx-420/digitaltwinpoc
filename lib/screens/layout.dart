import 'package:digitaltwinpoc/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  String appBarTitle = 'KogniTwin Assets';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image(
            image: AssetImage('assets/images/kongsberg-seeklogo.png'),
            color: null,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(appBarTitle),
      ),
      // body: DataTableWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: const DashboardScreen()
    );
    ;
  }
}
