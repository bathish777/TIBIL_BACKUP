import 'package:http/http.dart';

/// The route name is needed for endpoint.
/// It represents the URL used to access data from the remote source.
abstract class RemoteSource {
  // Declaration of the route name property
  String get routeName;

}