import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/trailer_model.dart';
import '../resources/repository.dart';
import '../models/item_model.dart';

class MovieDetailBloc {
  final _repository = Repository();
  final _movieId = PublishSubject<int>();
  final _trailers = BehaviorSubject<Future<TrailerModel>>();

  Function(int) get fetchTrailersById => _movieId.sink.add;
  Observable<Future<TrailerModel>> get movieTrailers => _trailers.stream;

  final _moviesFetcher = PublishSubject<ItemModel>();
  //create observer when change data
  Observable<ItemModel> get allMovies => _moviesFetcher.stream;


  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }


  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
  }

  dispose() async {
    _movieId.close();
    await _trailers.drain();
    _trailers.close();
    _moviesFetcher.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
          (Future<TrailerModel> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailers(id);
        return trailer;
      },
    );
  }

}

