import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:ditonton/presentation/cubit/movie/movie_watchlist_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieDetailCubitMock extends MockCubit<MovieDetailState>
    implements MovieDetailCubit {}

class MovieWatchlistCubitMock extends MockCubit<MovieWatchlistState>
    implements MovieWatchlistCubit {}

void main() {
  late MovieDetailCubitMock movieDetailCubitMock;
  late MovieWatchlistCubitMock movieWatchlistCubitMock;

  setUpAll(() {
    registerFallbackValue(testMovieDetail);
  });

  setUp(() {
    movieDetailCubitMock = MovieDetailCubitMock();
    movieWatchlistCubitMock = MovieWatchlistCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider<MovieDetailCubit>(
          create: (context) => movieDetailCubitMock,
        ),
        BlocProvider<MovieWatchlistCubit>(
          create: (context) => movieWatchlistCubitMock,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void initializeFunction() {
    when(() => movieDetailCubitMock.fetchMovieDetail(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.addWatchlist(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.deleteWatchlist(any()))
        .thenAnswer((_) async => {});
    when(() => movieWatchlistCubitMock.loadWatchlistStatus(any()))
        .thenAnswer((_) async => {});
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    initializeFunction();

    final watchlistButtonIcon = find.byIcon(Icons.add);

    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testMovieDetail, testMovieList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => MovieWatchlistStatusHasData(false));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
        initializeFunction();

    final watchlistButtonIcon = find.byIcon(Icons.check);

    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testMovieDetail, testMovieList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => MovieWatchlistStatusHasData(true));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    initializeFunction();
    when(() => movieDetailCubitMock.state)
        .thenAnswer((_) => DetailHasData(testMovieDetail, testMovieList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => MovieWatchlistMessageHasData('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

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
        .thenAnswer((_) => DetailHasData(testMovieDetail, testMovieList));

    when(() => movieWatchlistCubitMock.state)
        .thenAnswer((_) => MovieWatchlistError('Failed'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
