import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA APOD',
      theme: myTheme,
      home: const MyHomePage(title: 'NASA APOD'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pillars of creation",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Divider(),
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(55),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          "Date:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "2023-13-07",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 60,
        type: ExpandableFabType.up,
        children: [
          FloatingActionButton.small(
            // shape: const CircleBorder(),
            heroTag: null,
            child: const Icon(Icons.linked_camera_outlined),
            onPressed: () {},
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
