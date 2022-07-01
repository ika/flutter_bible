// // @dart=2.9


// import 'dart:async';
// import 'package:digitalbibleapp/notes/database.dart';
// import 'package:digitalbibleapp/notes/model.dart';
// import 'package:digitalbibleapp/notes/edit.dart';
// import 'package:digitalbibleapp/utils/utilities.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// // Notes

// NDProvider _ndProvider = NDProvider();

// enum ConfirmAction { CANCEL, ACCEPT }

// class NotesPage extends StatefulWidget {
//   const NotesPage({Key key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   List<NModel> list = List<NModel>.empty();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<NModel>>(
//         future: _ndProvider.getAllNotes(),
//         builder: (context, AsyncSnapshot<List<NModel>> snapshot) {
//           if (snapshot.hasData) {
//             list = snapshot.data;
//             return showNotesList(list, context);
//           } else if (snapshot.hasError) {
//             return Text("${snapshot.error}");
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//   }

//   _navigateToEditPage(NModel model) async {
//     Route route =
//         CupertinoPageRoute(builder: (context) => EditPage(model: model));
//     Future.delayed(Duration.zero, () {
//       Navigator.push(context, route).then((value) {
//         setState(() {});
//       });
//     });
//   }

//   Future _showDialog(context, list) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete this note?'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text(list.title),
//                 Text(list.subtitle),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: const Text('YES', style: TextStyle(fontWeight: FontWeight.bold)),
//               onPressed: () {
//                 Navigator.of(context).pop(ConfirmAction.ACCEPT);
//               },
//             ),
//             TextButton(
//               child: const Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
//               onPressed: () {
//                 Navigator.of(context).pop(ConfirmAction.CANCEL);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   showNotesList(list, context) {
//     ListTile makeListTile(list, int index) => ListTile(
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//           title: Text(
//             reduceLength(20, list[index].subtitle),
//             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           subtitle: Row(
//             children: [
//               const Icon(Icons.linear_scale, color: Colors.amber),
//               Flexible(
//                 child: RichText(
//                   overflow: TextOverflow.ellipsis,
//                   strutStyle: const StrutStyle(fontSize: 12.0),
//                   text: TextSpan(
//                       style: const TextStyle(color: Colors.white),
//                       text: " " + list[index].subtitle),
//                 ),
//               ),
//             ],
//           ),
//           trailing:
//               const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
//           onTap: () {
//             _navigateToEditPage(NModel(
//                 id: list[index].id,
//                 title: null,
//                 subtitle: list[index].subtitle));
//           },
//           onLongPress: () {
//             _showDialog(context, list[index]).then((value) {
//               if (value == ConfirmAction.ACCEPT) {
//                 _ndProvider.deleteNote(list[index].id).then((value) {
//                   setState(() {
//                     list.removeAt(index);
//                   });
//                 });
//               }
//             });
//           },
//         );

//     Card makeCard(list, int index) => Card(
//           elevation: 8.0,
//           margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
//           child: Container(
//             decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
//             child: makeListTile(list, index),
//           ),
//         );

//     final makeBody = ListView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: list == null ? 0 : list.length,
//       itemBuilder: (BuildContext context, int index) {
//         return makeCard(list, index);
//       },
//     );

//     final topAppBar = AppBar(
//       elevation: 0.1,
//       backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
//       title: const Text('Notes'),
//     );

//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
//       appBar: topAppBar,
//       body: makeBody,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber,
//         onPressed: () {
//           _navigateToEditPage(NModel(id: null, title: '', subtitle: ''));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
