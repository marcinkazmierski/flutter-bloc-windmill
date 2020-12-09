import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windmill/blocs/windmill_bloc.dart';
import 'package:windmill/models/account_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 14),
                  child: Text(this.widget.accountModel.name,
                      style: TextStyle(color: Colors.black, fontSize: 32)),
                ),
              CarouselSlider(
                  options: CarouselOptions(
                      height: 500,
                      enableInfiniteScroll: false,
                      initialPage: (state is WindmillLoadSuccessState)
                          ? this
                          .widget
                          .accountModel
                          .windmills
                          .indexOf(state.windmillModel)
                          : 0),
                  items: this.widget.accountModel.windmills.map((windmill) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4.0, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: Offset(
                                    4, // Move to right 10  horizontally
                                    4, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(windmill.name,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(windmill.location,
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14)),
                              ),
                              Expanded(
                                child:
                                Image.asset('assets/images/windmill.png'),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(20),
                                  child: LineReportChart()),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<WindmillBloc>(context).add(
                WindmillCreateInitializeEvent(),
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
                'Monthly production',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 24,
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
              case 6:
                return 'Cze';
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
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 100:
                return '100 kW';
              case 300:
                return '300 kW';
              case 500:
                return '500 kW';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minY: 0,
      maxY: 600,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, 200),
            FlSpot(2, 510),
            FlSpot(3, 290),
            FlSpot(4, 370),
            FlSpot(5, 180),
            FlSpot(6, 420),
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
