import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/cubit/movie/popular_movies_cubit.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class PopularMoviesCubitMock extends MockCubit<PopularMoviesState>
    implements PopularMoviesCubit {}

void main() {
  late PopularMoviesCubitMock popularMovieCubitMock;

  setUp(() {
    popularMovieCubitMock = PopularMoviesCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesCubit>(
      create: (context) => popularMovieCubitMock,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularMovieCubitMock.fetchPopularMovies())
        .thenAnswer((_) async => {});
    when(() => popularMovieCubitMock.state)
        .thenAnswer((_) => PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularMovieCubitMock.fetchPopularMovies())
        .thenAnswer((_) async => {});
    when(() => popularMovieCubitMock.state)
        .thenAnswer((_) => PopularMoviesHasData(<Movie>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularMovieCubitMock.fetchPopularMovies())
        .thenAnswer((_) async => {});
    when(() => popularMovieCubitMock.state)
        .thenAnswer((_) => PopularMoviesError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
