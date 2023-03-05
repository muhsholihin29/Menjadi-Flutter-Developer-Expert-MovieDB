import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/presentation/cubit/tv/tv_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'tv_detail_cubit_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
])
void main() {
  late TvDetailCubit cubit;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    cubit = TvDetailCubit(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
    );
  });

  final tId = 1;

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvList));
  }

  group('Get Tv Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
      expect(cubit.state, DetailHasData(testTvDetail, testTvList));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      cubit.fetchTvDetail(tId);
      // assert
      expect(cubit.state, TvDetailLoading());
    });

    test(
        'should change tv and recommendation when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await cubit.fetchTvDetail(tId);
      // assert
      expect(cubit.state, DetailHasData(testTvDetail, testTvList));
    });
  });

  group('on Error', () {
    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await cubit.fetchTvDetail(tId);
      // assert
      expect(cubit.state, TvDetailError('Failed'));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      // act
      await cubit.fetchTvDetail(tId);
      // assert
      expect(cubit.state, TvDetailError('Server Failure'));
    });
  });
}
