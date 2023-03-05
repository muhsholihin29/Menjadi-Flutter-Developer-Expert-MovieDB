import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/cubit/tv/top_rated_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'top_rated_tvs_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsCubit cubit;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    cubit = TopRatedTvsCubit(mockGetTopRatedTvs);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    cubit.fetchTopRatedTvs();
    // assert
    expect(cubit.state, TopRatedTvsLoading());
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    await cubit.fetchTopRatedTvs();
    // assert
    expect(cubit.state, TopRatedTvsHasData(testTvList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchTopRatedTvs();
    // assert
    expect(cubit.state, TopRatedTvsError('Server Failure'));
  });
}
