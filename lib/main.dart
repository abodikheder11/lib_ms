import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/view/account/presentation/cubit/profile_cubit.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';
import 'package:lib_ms/view/onbording/welcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/auth/data/repository/auth_repository.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/cart/presentation/bloc/cart_cubit.dart';
import 'feature/home/data/repository/book_repository.dart';
import 'feature/home/presentation/cubit/books_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  // prefs.remove('auth_token');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(AuthRepository()),
        ),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(
          create: (_) => ProfileCubit()..fetchProfile(),
        ),
        BlocProvider(
          create: (_) => BookCubit(BookRepository())..fetchBooks(),
        )
      ],
      child: MyApp(initialRoute: token != null ? '/home' : '/welcome'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute; // ✅ store it

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
      routes: {
        '/welcome': (context) => const WelcomeView(),
        '/home': (context) => const MainTabView(),
      },
      theme: ThemeData(
        primaryColor: Tcolor.primary,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
    );
  }
}
