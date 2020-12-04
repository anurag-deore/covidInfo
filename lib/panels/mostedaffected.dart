import 'package:flutter/material.dart';

class MostAffected extends StatelessWidget {
  final List countryData;

  const MostAffected({Key key, this.countryData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.network(
                  countryData[index]['countryInfo']['flag'],
                  height: 25,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                Text(
                  countryData[index]['country'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Affected : ' + countryData[index]['cases'].toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, ),
                ),
                Text(
                  'Deaths : ' + countryData[index]['deaths'].toString(),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )
              ],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}
