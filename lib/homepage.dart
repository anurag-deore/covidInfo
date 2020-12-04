import 'dart:convert';

import 'package:coronaTracker/constants.dart';
import 'package:coronaTracker/pages/countrystats.dart';
import 'package:coronaTracker/panels/infopanel.dart';
import 'package:coronaTracker/panels/mostedaffected.dart';
import 'package:coronaTracker/panels/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;

  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

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
    fetchOnRefresh();
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    animation =
        ColorTween(begin: Colors.pink[50], end: Colors.pink).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });
    controller.forward();
  }

  Future fetchOnRefresh() async {
    fetchWorldWideData();
    fetchcountryData();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.lightbulb_outline
                    : Icons.highlight,
                color: Theme.of(context).brightness == Brightness.light
                    ? primarycolor
                    : Colors.white,
              ),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light);
              }),
        ],
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : primarycolor,
        title: Text(
          'COVID INFO',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? primarycolor
                : Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: fetchOnRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget child) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Datasource.quote,
                            style: TextStyle(
                              color: animation.value,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.favorite_border,
                            size: 28,
                            color: animation.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current World Stats',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primarycolor),
                      ),
                    )
                  : WorldWidePanel(
                      worldData: worldData,
                    ),
              worldData == null
                  ? Container()
                  : PieChart(
                      chartType: ChartType.disc,
                      dataMap: {
                        'Confirmed': worldData['cases'].toDouble(),
                        'Active': worldData['active'].toDouble(),
                        'Recovered': worldData['recovered'].toDouble(),
                        'Deaths': worldData['deaths'].toDouble(),
                      },
                      colorList: [
                        Colors.lightBlue[200],
                        Colors.orange[300],
                        Colors.greenAccent,
                        Colors.red[300],
                      ],
                    ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most Affected Countries',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryStats()));
                      },
                      child: Row(
                        children: [
                          Text(
                            'All countries',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10.0,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              countryData == null
                  ? Container()
                  : MostAffected(
                      countryData: countryData,
                    ),
              Divider(),
              InfoPanel(),
              SizedBox(height: 20.0),
              Center(
                  child: Text(
                'WE ARE TOGETHER IN THIS FIGHT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              )),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
