import 'package:coronaTracker/constants.dart';
import 'package:flutter/material.dart';

class FAQS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ\'s'),
      ),
      body: ListView.builder(itemBuilder: (context,index){
        return ExpansionTile(title: Text(Datasource.questionAnswers[index]['question'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(Datasource.questionAnswers[index]['answer'],style: TextStyle(fontSize: 16.0),),
          )
        ],);
      },
      itemCount: Datasource.questionAnswers.length,
      ),
    );
  }
}