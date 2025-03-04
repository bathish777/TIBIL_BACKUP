import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderTextCubit extends Cubit<bool> {
  HeaderTextCubit({bool? initialState}) : super(initialState ??  true);
  closeHeaderText() => emit(false);
}