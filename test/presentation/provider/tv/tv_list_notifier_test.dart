import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListNotifier provider;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    provider = TvListNotifier(
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    )
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(posterPath: '/hNqlMpmzdQywzRSEk2AcTSTUrQP.jpg',
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
  final tTvList = <Tv>[tTv];

  group('now playing tvs', () {
    test('initialState should be Empty', () {
      expect(provider.onTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      verify(mockGetOnTheAirTvs.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.Loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.Loaded);
      expect(provider.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchOnTheAirTvs();
      // assert
      expect(provider.onTheAirState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tvs data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetPopularTvs.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchPopularTvs();
          // assert
          expect(provider.popularTvsState, RequestState.Loaded);
          expect(provider.popularTvs, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTvs();
      // assert
      expect(provider.popularTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tvs', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Loading);
    });

    test('should change tvs data when data is gotten successfully',
            () async {
          // arrange
          when(mockGetTopRatedTvs.execute())
              .thenAnswer((_) async => Right(tTvList));
          // act
          await provider.fetchTopRatedTvs();
          // assert
          expect(provider.topRatedTvsState, RequestState.Loaded);
          expect(provider.topRatedTvs, tTvList);
          expect(listenerCallCount, 2);
        });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTvs();
      // assert
      expect(provider.topRatedTvsState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
