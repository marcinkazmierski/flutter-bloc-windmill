import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/models/account_model.dart';
import 'package:fl_chart/fl_chart.dart';

class ViewWindmillPage extends StatelessWidget {
  final AccountModel accountModel;

  const ViewWindmillPage({@required this.accountModel})
      : assert(accountModel != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewWindmillForm(
        accountModel: this.accountModel,
      ),
    );
  }
}

class ViewWindmillForm extends StatefulWidget {
  final AccountModel accountModel;

  const ViewWindmillForm({@required this.accountModel})
      : assert(accountModel != null);

  @override
  State<ViewWindmillForm> createState() => _ViewWindmillFormState();
}

class _ViewWindmillFormState extends State<ViewWindmillForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindmillBloc, WindmillState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Text('Your Windmill',
                      style: TextStyle(color: Colors.black, fontSize: 32)),
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Your Windmill'),
                            Expanded(
                              child: Image.asset('assets/images/windmill.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                      padding: EdgeInsets.all(20), child: LineReportChart()),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("floatingActionButton onPressed!");
              BlocProvider.of<WindmillBloc>(context).add(
                WindmillCreateInitialize(),
              );
            },
            tooltip: 'Add new',
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class LineReportChart extends StatelessWidget {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Monthly Sales',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: LineChart(mainData()),
              ),
            ],
          ),
        ],
      ),
    );
  }



  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 12),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'Sty';
              case 2:
                return 'Lut';
              case 3:
                return 'Mar';
              case 4:
                return 'Kwi';
              case 5:
                return 'Maj';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10 tys';
              case 3:
                return '30 tys';
              case 5:
                return '50 tys';
            }
            return '';
          },
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 3),
            FlSpot(6, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
