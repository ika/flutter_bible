// // @dart=2.9


// import 'package:digitalbibleapp/notes/database.dart';
// import 'package:digitalbibleapp/notes/model.dart';
// import 'package:digitalbibleapp/utils/utilities.dart';
// import 'package:flutter/material.dart';

// // Edit Note

// NDProvider _ndProvider = NDProvider.db;

// String noteFunction;

// int id;
// String title;
// String subtitle;

// class EditPage extends StatefulWidget {
//   const EditPage({Key key, this.model}) : super(key: key);

//   final NModel model;

//   @override
//   _EditPageState createState() => _EditPageState();
// }

// class _EditPageState extends State<EditPage> {
//   //final subtitleController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();

//     id = widget.model.id ?? null;
//     title = widget.model.title ?? '';
//     subtitle = widget.model.subtitle ?? '';

//     //subtitleController.text = subtitle;

//     if (id == null) {
//       noteFunction = 'Add Note';
//     } else {
//       noteFunction = 'Edit Note';
//     }
//   }

//   @override
//   void dispose() {
//     //subtitleController.dispose();
//     super.dispose();
//   }

//   _handleOnChange() {
//     if (id == null) {
//       // no id, save
//       _saveEdit();
//     } else {
//       // with id, update
//       _updateEdit();
//     }
//   }

//   _saveEdit() async {
//     await _ndProvider
//         .insertNote(NModel(title: title, subtitle: subtitle, time: getTime()))
//         .then((res) {
//       id = res; // populate 'id' so that it is not saved more than once
//     });
//   }

//   _updateEdit() async {
//     await _ndProvider.updateNote(
//         NModel(id: id, title: title, subtitle: subtitle, time: getTime()));
//   }

//   void _deleteEdit() async {
//     await _ndProvider.deleteNote(id).then((value) {
//       int count = 0;
//       Navigator.popUntil(context, (route) {
//         return count++ == 2;
//       });
//     });
//   }

//   _deleteDialogWrapper() {
//     if (id != null) {
//       return showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title:
//               const Text('Delete this note?', style: TextStyle(color: Colors.black)),
//           content:
//               Text(subtitle.isNotEmpty ? subtitle : 'Delete this null entry?'),
//           actions: [
//             TextButton(
//               child: const Text('YES', style: TextStyle(color: Colors.blue)),
//               onPressed: () {
//                 FocusScope.of(context).unfocus();
//                 _deleteEdit();
//               },
//             ),
//             TextButton(
//               child: const Text('NO', style: TextStyle(color: Colors.blue)),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   formDesign() {
//     return Form(
//       key: _formKey,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
//         child: TextFormField(
//             //controller: subtitleController,
//             initialValue: subtitle,
//             maxLength: 256,
//             maxLines: null, // auto line break
//             autofocus: true,
//             // decoration: InputDecoration(
//             //   labelText: 'Enter your text',
//             //   labelStyle: Theme.of(context).textTheme.subtitle1,
//             //   border: OutlineInputBorder(
//             //     borderRadius: BorderRadius.circular(5.0),
//             //   ),
//             // ),
//             onChanged: (text) {
//               subtitle = text;
//               _handleOnChange();
//             },
//             keyboardType: TextInputType.text),
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
//         title: Text(noteFunction),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: _deleteDialogWrapper,
//           )
//         ],
//       ),
//       body: formDesign(),
//     );
//   }
// }
