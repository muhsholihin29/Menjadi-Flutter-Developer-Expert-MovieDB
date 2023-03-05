import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tvs.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton/presentation/cubit/movie/movie_detail_cubit.dart';
import 'package:ditonton/presentation/cubit/movie/movie_watchlist_cubit.dart';
import 'package:ditonton/presentation/cubit/movie/now_playing_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/movie/popular_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/movie/top_rated_movies_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/on_the_air_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/popular_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/top_rated_tvs_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/tv_detail_cubit.dart';
import 'package:ditonton/presentation/cubit/tv/tv_watchlist_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/tv_local_data_source.dart';
import 'data/datasources/tv_remote_data_source.dart';
import 'domain/usecases/tv/get_watchlist_tv_status.dart';
import 'domain/usecases/tv/get_watchlist_tvs.dart';
import 'domain/usecases/tv/remove_watchlist_tv.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => MovieSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvSearchBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailCubit(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => TvWatchlistCubit(
      getWatchlistTvs: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieWatchlistCubit(
      getWatchlistMovies: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
        () => OnTheAirTvsCubit(locator()),
  );
  locator.registerFactory(
        () => PopularTvsCubit(locator()),
  );
  locator.registerFactory(
        () => TopRatedTvsCubit(locator()),
  );

  locator.registerFactory(
        () => NowPlayingMoviesCubit(locator()),
  );
  locator.registerFactory(
        () => PopularMoviesCubit(locator()),
  );
  locator.registerFactory(
        () => TopRatedMoviesCubit(locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListMovieStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
