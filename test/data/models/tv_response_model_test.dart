import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
      popularity: 4.566,
      id: 87022,
      backdropPath: '/natwd6L8zzDMCTeMqDE7ZYLdRFM.jpg',
      voteAverage: 7.0,
      overview: 'The essence of love is fading and is evermore harder to do.',
      firstAirDate: '2019-02-23',
      originCountry: ['KR'],
      genreIds: [18],
      originalLanguage: 'ko',
      voteCount: 1,
      name: 'Love in Sadness',
      originalName: '슬플 때 사랑한다');
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_the_air.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/natwd6L8zzDMCTeMqDE7ZYLdRFM.jpg",
            "first_air_date": '2019-02-23',
            "genre_ids": [18],
            "id": 87022,
            "name": "Love in Sadness",
            "origin_country": ["KR"],
            "original_language": "ko",
            "original_name": "슬플 때 사랑한다",
            "overview":
                "The essence of love is fading and is evermore harder to do.",
            "popularity": 4.566,
            "poster_path": "/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg",
            "vote_average": 7.0,
            "vote_count": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
