import 'package:bloc/bloc.dart';
import 'package:personal_finance_tracker/app.dart';
import 'package:flutter/material.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}
