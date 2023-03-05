import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tv.dart';
import '../../cubit/tv/on_the_air_tvs_cubit.dart';
import '../../cubit/tv/popular_tvs_cubit.dart';
import '../../cubit/tv/top_rated_tvs_cubit.dart';
import '../watchlist_page.dart';
import 'on_the_air_tvs_page.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnTheAirTvsCubit>().fetchOnTheAirTvs();
      context.read<PopularTvsCubit>().fetchPopularTvs();
      context.read<TopRatedTvsCubit>().fetchTopRatedTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, HomeMoviePage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchListPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tv Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTvPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () =>
                    Navigator.pushNamed(context, OnTheAirTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<OnTheAirTvsCubit, OnTheAirTvsState>(
                  builder: (context, state) {
                if (state is OnTheAirTvsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnTheAirTvsHasData) {
                  return TvList(state.result);
                } else if (state is OnTheAirTvsError) {
                  return Text(state.message);
                } else {
                  return Text('Anda kurang beruntung');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvsCubit, PopularTvsState>(
                  builder: (context, state) {
                if (state is PopularTvsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvsHasData) {
                  return TvList(state.result);
                } else if (state is PopularTvsError) {
                  return Text(state.message);
                } else {
                  return Text('Anda kurang beruntung');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvsCubit, TopRatedTvsState>(
                  builder: (context, state) {
                if (state is TopRatedTvsLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvsHasData) {
                  return TvList(state.result);
                } else if (state is TopRatedTvsError) {
                  return Text(state.message);
                } else {
                  return Text('Anda kurang beruntung');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  TvList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
