import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mario_nexus/mario_nexus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MarioNexus()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//     writeBase().then((value) {
//       if (kDebugMode) {
//         print("worked");
//       }
//     });
//   }

//   int _counter = 0;

//   var shell = Shell();

//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/test.py');
//   }

//   Future<File> writeBase() async {
//     final file = await _localFile;
//     final path = await _localPath;

//     // Write the file
//     return file.writeAsString('''
// import os
// try:
//   os.mkdir(os.path.join(r"$path","trial"))
// except OSError as error:
//   print("already exists")
// try:
//   f = open(os.path.join(r"$path","trial/myfile.py"), "x")
//   f.close()
// except:
//   print("file exists")
// f = open(os.path.join(r"$path","trial/myfile.py"), "w")
// f.write("print('test')")
// f.close()
// ''');
//   }

//   Future<String> readCounter() async {
//     try {
//       final file = await _localFile;

//       // Read the file
//       final contents = await file.readAsString();

//       return contents;
//     } catch (e) {
//       // If encountering an error, return 0
//       return "Failed";
//     }
//   }

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             TextButton(
//                 onPressed: () async {
//                   File file = await _localFile;
//                   // await shell.run('''
//                   //   pip install gym_super_mario_bros===7.3.0 nes_py
//                   // ''');
//                   String dir = await _localPath;
//                   await shell.run('''
//                     python ${file.path}
//                   ''');
//                   await shell.run('''
//                     python $dir/trial/myfile.py
//                   ''');
//                 },
//                 child: const Text("test"))
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
