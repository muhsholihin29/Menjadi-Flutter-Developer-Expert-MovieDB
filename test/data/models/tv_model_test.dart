import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvModel = TvModel(
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

  final tTv = Tv(
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

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
