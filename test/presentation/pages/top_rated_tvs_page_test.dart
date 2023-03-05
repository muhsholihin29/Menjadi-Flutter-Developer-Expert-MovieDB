import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/cubit/tv/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TopRatedTvsCubitMock extends MockCubit<TopRatedTvsState>
    implements TopRatedTvsCubit {}

void main() {
  late TopRatedTvsCubitMock topRatedTvsCubitMock;

  setUp(() {
    topRatedTvsCubitMock = TopRatedTvsCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvsCubit>(
      create: (context) => topRatedTvsCubitMock,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedTvsCubitMock.fetchTopRatedTvs())
        .thenAnswer((_) async => {});
    when(() => topRatedTvsCubitMock.state)
        .thenAnswer((_) => TopRatedTvsLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedTvsCubitMock.fetchTopRatedTvs())
        .thenAnswer((_) async => {});
    when(() => topRatedTvsCubitMock.state)
        .thenAnswer((_) => TopRatedTvsHasData(<Tv>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedTvsCubitMock.fetchTopRatedTvs())
        .thenAnswer((_) async => {});
    when(() => topRatedTvsCubitMock.state)
        .thenAnswer((_) => TopRatedTvsError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
