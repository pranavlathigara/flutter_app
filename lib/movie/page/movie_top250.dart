import 'package:flutter/material.dart';
import 'package:flutter_app/custom_widgets/toast/toast.dart';
import 'package:flutter_app/global/data.dart';
import 'package:flutter_app/movie/bean/movie.dart';
import 'package:flutter_app/movie/service/api_service.dart';
import 'package:flutter_app/movie/ui/item_grid_view.dart';
import 'package:flutter_app/utils/loading_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MovieTop250 extends StatefulWidget {
  @override
  _MovieTop250State createState() => _MovieTop250State();
}

class _MovieTop250State extends State<MovieTop250> {
  int page = 1;
  int pagesize = 30;

  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  bool isFirst = true;

  List<Movie> movies = [];

  var text = "";

  bool loadError = false;

  @override
  void initState() {
    super.initState();

    getMovieTop250List(page, pagesize, RefreshType.DEFAULT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('豆瓣排行前250电影'),
      ),
      body: _builderPageView(movies),
    );
  }

  Widget _builderPageView(List<Movie> movies) {
    if (isFirst) {
      return Center(
        child: getLoadingWidget(),
      );
    } else {
      if (loadError) {
        return Center(
          child: RaisedButton(
            onPressed: () {
              page = 1;
              getMovieTop250List(page, pagesize, RefreshType.DEFAULT);
            },
            child: Text("加载失败"),
          ),
        );
      } else if ((movies.length > 0)) {
        return _builderGridView(movies);
      } else {
        return Center(child: Text(text));
      }
    }
  }

  Widget _builderGridView(List<Movie> movies) {
    return EasyRefresh(
      key: _easyRefreshKey,

      /// 自动控制(刷新和加载完成)
      autoControl: true,

      /// 底部视图
      refreshFooter: BallPulseFooter(
        key: _footerKey,
        color: Colors.indigo,
        backgroundColor: Colors.white,
      ),

      ///加载回调方法
      loadMore: () async {
        page++;
        getMovieTop250List(page, pagesize, RefreshType.LOAD_MORE);
      },

      /// 子部件 内容视图
      child: ItemGridView(movies: movies),
    );
  }

  void getMovieTop250List(int page, int pagesize, int type) async {
    List<Movie> list = await ApiService.getTop250List(
        start: (page - 1) * pagesize, count: pagesize);
    if (type == RefreshType.DEFAULT) {
      movies.addAll(list);
      if (isFirst && movies.length == 0) {
        text = "暂无数据";
      } else {
        text = "";
      }
    } else if (type == RefreshType.LOAD_MORE) {
      movies.addAll(list);
      if (list.length == 0) {
        setState(() {
          Toast.show("加载完...", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        });
      }
    }

    if (isFirst) {
      loadError = movies == null;
      isFirst = false;
    }

    setState(() {});
  }
}