import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/cubit/tv/tv_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../cubit/tv/tv_watchlist_cubit.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail_tv';

  final int id;

  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailCubit>().fetchTvDetail(widget.id);
      context.read<TvWatchlistCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailCubit, TvDetailState>(
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailHasData) {
            final tv = state.result;
            return SafeArea(
              child: DetailContent(
                tv,
                state.resultRecommendation,
              ),
            );
          } else if (state is TvDetailError) {
            return Text(state.message);
          } else {
            return Text('');
          }
        },
      ),
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;
  final bool isListSeasons;

  TvList(this.tvs, this.isListSeasons);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final tv = tvs[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              if (!this.isListSeasons) {
                Navigator.pushReplacementNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
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
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  bool isAddedWatchlist = false;

  DetailContent(this.tv, this.recommendations);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocBuilder<TvWatchlistCubit, TvWatchlistState>(
                                builder: (context, state) {
                              if (state is WatchlistStatusHasData) {
                                isAddedWatchlist = state.result;
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    context
                                        .read<TvWatchlistCubit>()
                                        .addWatchlist(tv);
                                  } else {
                                    context
                                        .read<TvWatchlistCubit>()
                                        .deleteWatchlist(tv);
                                  }

                                  if (state is TvWatchlistError) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(state.message),
                                          );
                                        });
                                  } else if (state is WatchlistMessageHasData) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(state.result)));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              );
                            }),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              '${tv.numberOfSeasons} Sessions',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            Container(
                                height: 150,
                                child: TvList(
                                    tv.seasons
                                        .map((e) => Tv(
                                            posterPath: e.posterPath,
                                            popularity: 0.0,
                                            id: e.id,
                                            backdropPath: '',
                                            voteAverage: 0.0,
                                            overview: '',
                                            firstAirDate: e.airDate,
                                            originCountry: [],
                                            genreIds: [],
                                            originalLanguage: '',
                                            voteCount: 0,
                                            name: e.name,
                                            originalName: ''))
                                        .toList(),
                                    true)),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvDetailCubit, TvDetailState>(
                              builder: (context, state) {
                                if (state is TvDetailLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvDetailError) {
                                  return Text(state.message);
                                } else if (state is DetailHasData) {
                                  return Container(
                                      height: 150,
                                      child: TvList(
                                          state.resultRecommendation, false));
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
