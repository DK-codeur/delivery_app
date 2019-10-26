// import 'package:delivery_app/main_drawer.dart';
// import 'package:flutter/material.dart';


// class MyHomePage extends StatefulWidget {

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {

//   List<String> myliste = [
//     'AAAAAAAAAAAAAAAAA',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'BBBBBBBBBBBBBBBBBB',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'CCCCCCCCCCCCCCCCC',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'bjsbdjbdjkdbkjbdkD',
//     'ZZZZZZZZZZZZZZZZ',
//   ];

//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       drawer: MainDrawer(),
//       body: CustomScrollView(
//         slivers: <Widget> [
//           SliverAppBar(
//             centerTitle: true,
//             pinned: true,
//             expandedHeight: 160.0,
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.motorcycle, size: 30,),
//                 onPressed: () {},
//               )
//             ],

//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: Text(
//                 'COMMANDES',
//                 style: TextStyle(
//                   fontFamily: 'CenturyGhotic',
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.4

//                 ),
//               ),

//               background: Container(
//                 height: 150.0,
//                 color: Colors.blue,
//               ),
//             ),
            
//           ),

//           SliverList(
//             delegate: SliverChildBuilderDelegate(
              
//               (BuildContext context, int index) {
//                 return Text(myliste[index], style: TextStyle(fontSize: 30),);
//               },

//               childCount: myliste.length,
//             ),
//           )

//           // SliverFillRemaining(
            
//           // )
//         ]
//       ),

      
//     );
//   }
// }








// import 'package:flutter/material.dart';

// import '../main_drawer.dart';

// class CmdScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: MainDrawer(),
//       body: CustomScrollView(
//         slivers: <Widget> [
//           SliverAppBar(
//             centerTitle: true,
//             pinned: true,
//             expandedHeight: 160.0,
//             actions: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.motorcycle, size: 30,),
//                 onPressed: () {},
//               )
//             ],

//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               title: Text(
//                 'COMMANDES',
//                 style: TextStyle(
//                   fontFamily: 'CenturyGhotic',
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.4

//                 ),
//               ),

//               background: Container(
//                 height: 150.0,
//                 color: Colors.blue,
//               ),
//             ),
            
//           ),

//           SliverList(
//             delegate: SliverChildBuilderDelegate(
              
//               // (BuildContext context, int index) {
//               //   return Text(myliste[index], style: TextStyle(fontSize: 30),);
//               // },

//               // childCount: myliste.length,
//             ),
//           )

//           // SliverFillRemaining(
            
//           // )
//         ]
//       ),

      
//     );
//   }
// }