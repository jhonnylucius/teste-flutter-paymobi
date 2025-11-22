import 'package:base_project/src/app_widget.dart';
import 'package:base_project/src/core/core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa as dependências
  await setupDependencies();

  runApp(const AppWidget());
}
