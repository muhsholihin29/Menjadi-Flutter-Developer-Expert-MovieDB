import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:ditonton/presentation/cubit/movie/movie_watchlist_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListMovieStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieWatchlistCubit cubit;
  late MockGetWatchlistMovies mockGetWatchlistMovie;
  late MockGetWatchListMovieStatus mockGetWatchlistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovie = MockGetWatchlistMovies();
    mockGetWatchlistStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();
    cubit = MovieWatchlistCubit(
      getWatchlistMovies: mockGetWatchlistMovie,
      getWatchListStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
    );
  });

  group('Watchlist', () {
    test('should change tvs data when data is gotten successfully', () async {
      // arrange
      when(mockGetWatchlistMovie.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      // act
      await cubit.getWatchlist();
      // assert
      expect(cubit.state, MovieWatchlistHasData([testWatchlistMovie]));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetWatchlistMovie.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await cubit.getWatchlist();
      // assert
      expect(cubit.state, MovieWatchlistError("Can't get data"));
    });

    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await cubit.loadWatchlistStatus(1);
      // assert
      expect(cubit.state, MovieWatchlistStatusHasData(true));
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      verify(mockSaveWatchlist.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      cubit.deleteWatchlist(testMovieDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      expect(cubit.state, MovieWatchlistStatusHasData(true));
      // expect(cubit.state, WatchlistMessageHasData('Added to Watchlist'));
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      // act
      await cubit.addWatchlist(testMovieDetail);
      // assert
      expect(cubit.state, MovieWatchlistStatusHasData(false));
      // expect(cubit.state, WatchlistMessageHasData('Failed'));
    });
  });
}
