import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tvs.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/cubit/tv/tv_watchlist_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_dummy_objects.dart';
import 'tv_watchlist_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvs,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvWatchlistCubit cubit;
  late MockGetWatchlistTvs mockGetWatchlistTv;
  late MockGetWatchListTvStatus mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTvs();
    mockGetWatchlistStatus = MockGetWatchListTvStatus();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    cubit = TvWatchlistCubit(
      getWatchlistTvs: mockGetWatchlistTv,
      getWatchListStatus: mockGetWatchlistStatus,
        saveWatchlist: mockSaveWatchlist,
        removeWatchlist: mockRemoveWatchlist,
    );
  });

  group('Watchlist', () {
    test('should change tvs data when data is gotten successfully', () async {
      // arrange
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Right([testWatchlistTv]));
      // act
      await cubit.getWatchlist();
      // assert
      expect(cubit.state, WatchlistHasData([testWatchlistTv]));
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetWatchlistTv.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await cubit.getWatchlist();
      // assert
      expect(cubit.state, TvWatchlistError("Can't get data"));
    });

    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await cubit.loadWatchlistStatus(1);
      // assert
      expect(cubit.state, WatchlistStatusHasData(true));
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testTvDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      cubit.deleteWatchlist(testTvDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await cubit.addWatchlist(testTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTvDetail.id));
      expect(cubit.state, WatchlistStatusHasData(true));
      // expect(cubit.state, WatchlistMessageHasData('Added to Watchlist'));
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await cubit.addWatchlist(testTvDetail);
      // assert
      expect(cubit.state, WatchlistStatusHasData(false));
      // expect(cubit.state, WatchlistMessageHasData('Failed'));
    });
  });
}
