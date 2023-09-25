
import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Node extends StatelessWidget {
const Node({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    fetchData() async{
    var url = Uri.parse("http://10.0.2.2:400/users");
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

    return Scaffold(
      appBar: AppBar(title: Text("localhost"),),
      body: Center(
        child: Column(
            children: [
              FutureBuilder(
                future: fetchData(),
                builder: (context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        ...snapshot.data.map((e){
                          return ListTile(title: Text(e['name']),);
                        })
                      ],
                    );
                  }
                  else{
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          )
        ));
  }
}