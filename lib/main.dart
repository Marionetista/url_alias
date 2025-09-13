import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'app_bloc_observer.dart';

void main() {
  EquatableConfig.stringify = true;
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
