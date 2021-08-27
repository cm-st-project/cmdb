# cmdb

A Flutter plugin to store and get access to information to/from Firebase Realtime database.

## Getting Started

* Create a project in the [Firebase] (https://firebase.google.com/)

* Go to the rule tab in the Realtime database and set .read and .write variables to true.

* Copy the url that shows in the Realtime database section and uses it when initialize the cmdb (eg. https://cmdatabase-xxxxx-default-rtdb.firebaseio.com/)

* Add cmdb as a [dependency in your pubspec.yaml file] (https://flutter.dev/docs/development/packages-and-plugins/using-packages)

## Example

```dart
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
