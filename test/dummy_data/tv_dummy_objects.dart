import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testTv = Tv(
    posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
    popularity: 4.566,
    id: 87022,
    backdropPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
    voteAverage: 7.0,
    overview: 'The essence of love is fading and is evermore harder to do.',
    firstAirDate: '2019-02-23',
    originCountry: ['ko'],
    genreIds: [18],
    originalLanguage: 'ko',
    voteCount: 1,
    name: 'Love in Sadness',
    originalName: '슬플 때 사랑한다');

final testTvList = [testTv];

final testTvDetail = TvDetail(
    backdropPath: '/natwd6L8zzDMCTeMqDE7ZYLdRFM.jpg',
    firstAirDate: '2019-02-23',
    genres: [Genre(id: 18, name: 'Drama')],
    homepage: 'http://www.imbc.com/broad/tv/drama/loveinsadness/',
    id: 87022,
    name: 'Love in Sadness',
    numberOfEpisodes: 40,
    numberOfSeasons: 1,
    originalLanguage: 'ko',
    originalName: '슬플 때 사랑한다',
    overview: 'The essence of love is fading and is evermore harder to do.',
    popularity: 4.566,
    posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
    seasons: [],
    status: 'Ended',
    voteAverage: 7.0,
    voteCount: 1);

final testWatchlistTv = Tv.watchlist(
  id: 87022,
  name: 'Love in Sadness',
  posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
  overview: 'The essence of love is fading and is evermore harder to do.',
);

final testTvTable = TvTable(
  id: 87022,
  name: 'Love in Sadness',
  posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
  overview: 'The essence of love is fading and is evermore harder to do.',
);

final testTvMap = {
  'id': 87022,
  'overview': 'The essence of love is fading and is evermore harder to do.',
  'posterPath': '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
  'name': 'Love in Sadness',
};
