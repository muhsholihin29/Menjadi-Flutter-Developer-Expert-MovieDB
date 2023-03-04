import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/cubit/tv/tv_detail_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/tv_watchlist_cubit.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/tv_dummy_objects.dart';

class TvDetailCubitMock extends MockCubit<TvDetailState>
    implements TvDetailCubit {}

class TvWatchlistCubitMock extends MockCubit<TvWatchlistState>
    implements TvWatchlistCubit {}

void main() {
  late TvDetailCubitMock movieDetailCubitMock;
  late TvWatchlistCubitMock movieWatchlistCubitMock;

  setUpAll(() {
    registerFallbackValue(testTvDetail);
  });

  setUp(() {
    movieDetailCubitMock = TvDetailCubitMock();
    movieWatchlistCubitMock = TvWatchlistCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<TvDetailCubit>(
          create: (context) => movieDetailCubitMock,
        ),
        BlocProvider<TvWatchlistCubit>(
          create: (context) => movieWatchlistCubitMock,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void initializeFunction() {
    when(() => movieDetailCubitMock.fetchTvDetail(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.addWatchlist(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.deleteWatchlist(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.loadWatchlistStatus(any()))
        .thenAnswer((_) async => {});
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    initializeFunction();

    final watchlistButtonIcon = find.byIcon(Icons.add);

    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testTvDetail, testTvList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => WatchlistStatusHasData(false));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    initializeFunction();

    final watchlistButtonIcon = find.byIcon(Icons.check);

    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testTvDetail, testTvList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => WatchlistStatusHasData(true));

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    initializeFunction();
    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testTvDetail, testTvList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => WatchlistMessageHasData('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    initializeFunction();
    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testTvDetail, testTvList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => TvWatchlistError('Failed'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
