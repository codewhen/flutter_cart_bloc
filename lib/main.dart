import 'package:cart_bloc/core/observer/bloc_observer_console.dart';
import 'package:cart_bloc/data/repository/product_repository.dart';
import 'package:cart_bloc/logic/bloc/cart/cart_bloc.dart';
import 'package:cart_bloc/logic/cubit/products/products_cubit.dart';
import 'package:cart_bloc/presentation/pages/cartpage/cart_page.dart';
import 'package:cart_bloc/presentation/pages/homepage/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await path.getTemporaryDirectory()).path),
  );
  Bloc.observer = BlocObserverConsole();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(CartStarted()),
      child: MaterialApp(
        title: 'Cart Bloc',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/": ((context) => RepositoryProvider(
                create: (context) => ProductRepository(),
                child: BlocProvider(
                  create: (context) =>
                      ProductsCubit(context.read<ProductRepository>()),
                  child: const HomePage(),
                ),
              )),
          "/cart": ((context) => const CartPage())
        },
      ),
    );
  }
}
