import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/cubit/movie/top_rated_movies_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_cubit_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit cubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    cubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    cubit.fetchTopRatedMovies();
    // assert
    expect(cubit.state, TopRatedMoviesLoading());
  });

  test('should change tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    await cubit.fetchTopRatedMovies();
    // assert
    expect(cubit.state, TopRatedMoviesHasData(testMovieList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchTopRatedMovies();
    // assert
    expect(cubit.state, TopRatedMoviesError('Server Failure'));
  });
}
