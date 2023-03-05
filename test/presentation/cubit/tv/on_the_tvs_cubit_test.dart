import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/presentation/cubit/tv/on_the_air_tvs_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'on_the_tvs_cubit_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs])
void main() {
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late OnTheAirTvsCubit cubit;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    cubit = OnTheAirTvsCubit(mockGetOnTheAirTvs);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetOnTheAirTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    cubit.fetchOnTheAirTvs();
    // assert
    expect(cubit.state, OnTheAirTvsLoading());
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetOnTheAirTvs.execute())
        .thenAnswer((_) async => Right(testTvList));
    // act
    await cubit.fetchOnTheAirTvs();
    // assert
    expect(cubit.state, OnTheAirTvsHasData(testTvList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetOnTheAirTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchOnTheAirTvs();
    // assert
    expect(cubit.state, OnTheAirTvsError('Server Failure'));
  });
}
