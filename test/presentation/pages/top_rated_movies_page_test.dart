import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/cubit/movie/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TopRatedMoviesCubitMock extends MockCubit<TopRatedMoviesState>
    implements TopRatedMoviesCubit {}

void main() {
  late TopRatedMoviesCubitMock topRatedMoviesCubitMock;

  setUp(() {
    topRatedMoviesCubitMock = TopRatedMoviesCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>(
      create: (context) => topRatedMoviesCubitMock,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedMoviesCubitMock.fetchTopRatedMovies())
        .thenAnswer((_) async => {});
    when(() => topRatedMoviesCubitMock.state)
        .thenAnswer((_) => TopRatedMoviesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedMoviesCubitMock.fetchTopRatedMovies())
        .thenAnswer((_) async => {});
    when(() => topRatedMoviesCubitMock.state)
        .thenAnswer((_) => TopRatedMoviesHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedMoviesCubitMock.fetchTopRatedMovies())
        .thenAnswer((_) async => {});
    when(() => topRatedMoviesCubitMock.state)
        .thenAnswer((_) => TopRatedMoviesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
