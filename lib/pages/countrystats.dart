import 'package:coronaTracker/constants.dart';
import 'package:coronaTracker/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryStats extends StatefulWidget {
  @override
  _CountryStatsState createState() => _CountryStatsState();
}

class _CountryStatsState extends State<CountryStats> {
  List countryData;
  fetchcountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchcountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : primarycolor,
        title: Text(
          'Country Stats',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? primarycolor
                : Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light
              ? primarycolor
              : Colors.white,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).brightness == Brightness.light
                    ? primarycolor
                    : Colors.white,
              ),
              onPressed: () {
                showSearch(context: context, delegate: Search(countryData));
              }),
        ],
      ),
      body: countryData == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).brightness == Brightness.light
                      ? primarycolor
                      : Colors.white,
                ),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    height: 150,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                                countryData[index]['country'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.network(
                                  countryData[index]['countryInfo']['flag'],
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
                              countryData[index]['cases'].toString() +
                                  '  Confirmed Cases',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              countryData[index]['active'].toString() +
                                  '  Active Cases',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                            Text(
                              countryData[index]['recovered'].toString() +
                                  ' Recovered',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              countryData[index]['deaths'].toString() +
                                  ' Deaths',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }
}
