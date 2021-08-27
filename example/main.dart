import 'package:flutter/material.dart';
import 'package:cmdb/cmdb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cmdb Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CmdbExample(
        title: 'Cmdb Example',
      ),
      // home: AudioScreen(),
    );
  }
}

class CmdbExample extends StatefulWidget {
  CmdbExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CmdbExampleState createState() => _CmdbExampleState();
}

class _CmdbExampleState extends State<CmdbExample> {
  CMDB database = CMDB();
  Map<String, dynamic> _users = {};

  int _counter = 1;

  @override
  void initState() {
    super.initState();
    //Use initialize function only in the main. Once it is initialized you do not need to use initialize('url') in other pages.
    // You only use CMDB database = CMDB() and use the other functions;
    database
        .initialize('https://cmdatabase-85466-default-rtdb.firebaseio.com/');
  }

  void getUsers() {
    String path = 'Users/';
    database.get<Map<String, dynamic>>(path).then((value) {
      if (value != null)
        setState(() {
          _users = value;
        });
    });
  }

  void createUserWithUniqueKey(String username, String password) {
    String path = 'Users';
    database.create(path, {'username': username, 'password': password}).then(
        (response) {
      if (response != null) _counter++;
    });
  }

  void createUser(String username, String password) {
    String path = 'Users/$username';
    database.update(path,
        {'username': username, 'password': password}).then((response) {
      if (response) _counter++;
    });
  }

  Widget showUserList() {
    return ListView.separated(
      itemCount: _users.length,
      itemBuilder: (BuildContext context, int index) {
        String key = _users.keys.elementAt(index);
        return Center(
          child: Column(
            children: [
              Text('key:' + key),
              Text("username: " + _users[key]!['username'] ),
              Text("password: " + _users[key]!['password'])
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                createUserWithUniqueKey('username $_counter', 'password $_counter');
              },
              child: Text('Create User with unique key')),
          ElevatedButton(
              onPressed: () {
                createUser('username $_counter', 'password $_counter');
              },
              child: Text('Create User')),
          ElevatedButton(
              onPressed: () {
                getUsers();
              },
              child: Text('Get Users')),
          showUserList(),
        ],
      ),
    );
  }
}
