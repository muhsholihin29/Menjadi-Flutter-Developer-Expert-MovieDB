import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/tv/on_the_air_tvs_cubit.dart';
import '../../widgets/tv_card_list.dart';

class OnTheAirTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/onTheAir-tv';

  @override
  _OnTheAirTvsPageState createState() => _OnTheAirTvsPageState();
}

class _OnTheAirTvsPageState extends State<OnTheAirTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<OnTheAirTvsCubit>().fetchOnTheAirTvs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OnTheAir Tvs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvsCubit, OnTheAirTvsState>(
          builder: (context, state) {
            if (state is OnTheAirTvsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirTvsHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is OnTheAirTvsError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text('Anda kurang beruntung'),
              );
            }
          },
        ),
      ),
    );
  }
}
