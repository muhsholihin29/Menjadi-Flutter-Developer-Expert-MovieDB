import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late MovieDetailCubit cubit;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    cubit = MovieDetailCubit(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
    );
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testMovieList));
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
      expect(cubit.state, DetailHasData(testMovieDetail, testMovieList));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, MovieDetailLoading());
    });

    test(
        'should change tv and recommendation when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, DetailHasData(testMovieDetail, testMovieList));
    });
  });

  group('on Error', () {
    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, MovieDetailError('Failed'));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));
      // act
      await cubit.fetchMovieDetail(tId);
      // assert
      expect(cubit.state, MovieDetailError('Server Failure'));
    });
  });
}
