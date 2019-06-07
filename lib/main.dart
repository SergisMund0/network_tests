import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:network_tests/entities/post_errorResponse.dart';
import 'package:network_tests/entities/post_request.dart';
import 'package:network_tests/entities/post_response.dart';

import 'package:network_tests/network_services/post_service.dart';
import 'package:network_tests/network_layer/http_session.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Network Layer example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _jsonString = '';
  String _finalString = '{}';

  void _makeRequest() async {
    // Initialize the HttpClient.
    final client = Client();
    // Create the request.
    final postRequest = PostRequest('1');
    // Create an instance of the Post endpoint.
    final postService = PostService(postRequest);
    // Create an instance of the server session.
    final session = HttpSession(client);
    // Define the response type for the request.
    final postList = PostList();

    final serverResponse =
        await session.request(service: postService, responseType: postList);

    setState(() {
      if (serverResponse is PostList) {
        for (var i = 0; i < serverResponse.posts.length; i++) {
          _jsonString =
              '$_jsonString "userId:" "${serverResponse.posts[i].userId}", "title": "${serverResponse.posts[i].title}", "body: "${serverResponse.posts[i].body}",';
        }
        _finalString = '[{$_jsonString}]';
      } else if (serverResponse is ErrorResponse) {
        _finalString =
            '{"errorCode:" "${serverResponse.errorCode}", "Description": "${serverResponse.description}"}';
      }
    });
  }

  void _clearContent() {
    setState(() {
      _finalString = '{}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return body();
        },
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.0, 55.0, 15.0, 35.0),
              child: Text(_finalString,
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 15.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text('Make request'),
                  onPressed: () {
                    _makeRequest();
                  },
                ),
                RaisedButton(
                  child: Text('Clear content'),
                  onPressed: () {
                    _clearContent();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}