import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/cubit/movie/popular_movies_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movies_cubit_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesCubit cubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    cubit = PopularMoviesCubit(mockGetPopularMovies);
  });

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    cubit.fetchPopularMovies();
    // assert
    expect(cubit.state, PopularMoviesLoading());
  });

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    await cubit.fetchPopularMovies();
    // assert
    expect(cubit.state, PopularMoviesHasData(testMovieList));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await cubit.fetchPopularMovies();
    // assert
    expect(cubit.state, PopularMoviesError('Server Failure'));
  });
}
