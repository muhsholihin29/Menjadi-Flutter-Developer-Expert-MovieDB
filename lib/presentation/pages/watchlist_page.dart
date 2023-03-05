import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';

class WatchListPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Watchlist'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.movie),
                  text: "Movies",
                ),
                Tab(
                  icon: Icon(Icons.tv),
                  text: "Tv Series",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              WatchlistMoviesPage(),
              WatchlistTvsPage(),
            ],
          ),
        ));
  }
}
