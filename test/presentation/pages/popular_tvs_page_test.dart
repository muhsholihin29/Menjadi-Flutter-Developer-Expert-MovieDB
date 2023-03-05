import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/cubit/tv/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/pages/tv/popular_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class PopularTvsCubitMock extends MockCubit<PopularTvsState>
    implements PopularTvsCubit {}

void main() {
  late PopularTvsCubitMock popularTvCubitMock;

  setUp(() {
    popularTvCubitMock = PopularTvsCubitMock();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsCubit>(
      create: (context) => popularTvCubitMock,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularTvCubitMock.fetchPopularTvs())
        .thenAnswer((_) async => {});
    when(() => popularTvCubitMock.state).thenAnswer((_) => PopularTvsLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => popularTvCubitMock.fetchPopularTvs())
        .thenAnswer((_) async => {});
    when(() => popularTvCubitMock.state)
        .thenAnswer((_) => PopularTvsHasData(<Tv>[]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularTvCubitMock.fetchPopularTvs())
        .thenAnswer((_) async => {});
    when(() => popularTvCubitMock.state)
        .thenAnswer((_) => PopularTvsError('Error message'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
