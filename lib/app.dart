import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/constants/app_colors.dart';
import 'features/home/data/home_repository.dart';
import 'features/home/logic/home_cubit.dart';
import 'features/home/ui/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'URL Alias App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.acai),
      useMaterial3: true,
    ),
    home: BlocProvider(
      create: (context) => HomeCubit(repository: HomeRepository()),
      child: const HomePage(),
    ),
  );
}
