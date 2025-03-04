import 'package:equatable/equatable.dart';
import 'package:sound_box/src/data/data.dart';

abstract class Repository <T extends Model> {
Stream<RepositoryEvent<T>> get events;
}

abstract class RepositoryEvent<T extends Model> extends Equatable {
  const RepositoryEvent();
}

/// A model has been created.
class ModelCreated<T extends Model> extends RepositoryEvent<T> {
  const ModelCreated(this.model);

  final T? model;

  @override
  List<Object> get props => [];
}