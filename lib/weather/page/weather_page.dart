import 'package:flutter/material.dart';
import 'package:flutter_app/bean/he_weather.dart';
import 'package:flutter_app/service/api_service.dart';

import '../../page_index.dart';
import '../page/city_page.dart';
import '../ui/air_view.dart';
import '../ui/hourly_view.dart';
import '../ui/lifestyle_view.dart';
import '../ui/now_view.dart';
import '../ui/sun_view.dart';
import '../ui/weekly_view.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';

class WeatherPage extends StatefulWidget {
  final String cityname;

  WeatherPage(this.cityname, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  HeWeather weather;
  HeWeather air;

  AirNowCity air_now_city;
  NowBean now;
  List<DailyForecast> daily_forecast = [];
  List<Lifestyle> lifestyle = [];
  List<Hourly> hourly = [];

  String background = 'images/weather_backgrounds/back_100d.jpg';

  ScrollController scrollController = ScrollController();
  double navAlpha = 0;
  double headerHeight = 200;

  Color barColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var offset = scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < headerHeight) {
        setState(() {
          navAlpha = 1 - (headerHeight - offset) / headerHeight;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
        });
      }
    });

    _getWeather(widget.cityname);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// 根据城市名查询该城市天气预报
  _getWeather(String cityname) async {
    air = await ApiService.getAir(cityname);
    weather = await ApiService.getHeWeather(cityname);

    background = weatherBg(now?.cond_code);

    barColor = await Utils.getImageDominantColor(background, type: "asset");

    setState(() {
      if (weather != null) {
        now = weather.now;
        background = weatherBg(now?.cond_code);
        daily_forecast = weather.daily_forecast;
        lifestyle = weather.lifestyle;
        hourly = weather.hourly;
      }
      if (air != null) {
        air_now_city = air.air_now_city;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Image.asset(background, fit: BoxFit.fitHeight, height: double.infinity),
        _buildContentView(),
        Container(
            height: Utils.navigationBarHeight,
            child: AppBar(
                centerTitle: true,
                title: Text('${widget.cityname}'),
                elevation: 0.0,
                backgroundColor: Color.fromARGB((navAlpha * 255).toInt(),
                    barColor.red, barColor.green, barColor.blue),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.blur_on, color: Colors.white),
                      onPressed: () => pushNewPage(context, CityPage()))
                ]))
      ]),
    );
  }

  Widget _buildContentView() {
    if (null == weather) {
      return getLoadingWidget();
    }
    return EasyRefresh(
        key: _easyRefreshKey,
        refreshHeader: MaterialHeader(
          key: _headerKey,
        ),
        child: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: <Widget>[
              NowView(now,
                  daily_forecast: daily_forecast[0],
                  air_now_city: air_now_city),
              AirView(air_now_city),
              HourlyView(hourly),
              WeeklyView(daily_forecast),
              LifestyleView(lifestyle),
              SunView(this.widget.cityname)
            ])),
        onRefresh: () => _getWeather(widget.cityname));
  }
}
