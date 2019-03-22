import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';

class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  //create observer when change data
  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  /**
   * call service
   */
  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  /**
   * release PublishSubject
   */
  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = MoviesBloc();