// import 'dart:async';
// import 'package:digital_bible_app/notes/db/database.dart';
// import 'package:digital_bible_app/notes/models/model.dart';
// import 'package:digital_bible_app/notes/pages/edit.dart';
// import 'package:digital_bible_app/utils/utilities.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';



// class NotesPage extends StatefulWidget {
//   NotesPage();

//   @override
//   _NotesPageState createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {

//   FutureOr onReturnFromEdit(dynamic value) {
//     // update notes
//     setState(() {});
//   }

//   _navigateToEditPage(NModel model) async {
//     Route route =
//         CupertinoPageRoute(builder: (context) => EditPage(model: model));
//         Future.delayed(Duration.zero,() {
//           Navigator.push(context, route).then(onReturnFromEdit);
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(64, 75, 96, .9),
//         title: Text('Notes')
//       ),
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               child: FutureBuilder<List<NModel>>(
//                 future: NDProvider.db.getAllNotes(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<List<NModel>> snapshot) {
//                   // Make sure data exists and is actually loaded
//                   if (snapshot.hasData) {
//                     // If there are no notes.
//                     if (snapshot.data.length < 1) {
//                       //_navigateToEditPage(Model(id: null, contents: ''));
//                       return Center(
//                         child: Text('No items found!'),
//                       );
//                     }

//                     List<NModel> notes = snapshot.data;

//                     return ListView.builder(
//                       itemCount: snapshot.data.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         NModel model = notes[index];
//                         return Column(
//                           children: [
//                             ListTile(
//                               title: Text(reduceLength(model.contents)),
//                               onTap: () {
//                                 _navigateToEditPage(model);
//                               },
//                               leading:
//                                   Icon(Icons.chevron_right, color: Colors.orangeAccent),
//                             ),
//                             Divider(
//                               height: 2.0,
//                               indent: 15.0,
//                               endIndent: 20.0,
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }

//                   return Center(
//                     child: Text('An error has occured!'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.amber,
//         onPressed: () {
//           _navigateToEditPage(NModel(id: null, contents: null));
//         },
//         child: Icon(Icons.add),
//       ),
//     );
    
//   }


// }
