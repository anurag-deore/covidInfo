import 'package:coronaTracker/constants.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List countryList;

  Search(this.countryList);
@override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor:primarycolor,
      brightness: DynamicTheme.of(context).brightness,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().startsWith(query))
            .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  // width: 100,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        suggestionList[index]['country'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Image.network(
                          suggestionList[index]['countryInfo']['flag'],
                          height: 40,
                          width: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      suggestionList[index]['cases'].toString() +
                          '  Confirmed Cases',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      suggestionList[index]['active'].toString() +
                          '  Active Cases',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    Text(
                      suggestionList[index]['recovered'].toString() +
                          ' Recovered',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    Text(
                      suggestionList[index]['deaths'].toString() + ' Deaths',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
