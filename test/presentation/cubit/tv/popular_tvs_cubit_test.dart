import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/presentation/cubit/tv/popular_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'popular_tvs_cubit_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsCubit cubit;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    cubit = PopularTvsCubit(mockGetPopularTvs);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsLoading());
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    await cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsHasData(testTvList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchPopularTvs();
    // assert
    expect(cubit.state, PopularTvsError('Server Failure'));
  });
}
