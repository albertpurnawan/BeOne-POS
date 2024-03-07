import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_fe/config/routes/router.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_customers.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_item_by_barcode.dart';
import 'package:pos_fe/features/sales/presentation/cubit/customers_cubit.dart';
import 'package:pos_fe/features/sales/presentation/cubit/receipt_cubit.dart';
import 'package:pos_fe/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await GetIt.instance.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print((GetIt.instance<AppDatabase>().currencyDao.readAll()).toString());
    // GetIt.instance<AppDatabase>()
    //     .itemCategoryDao
    //     .bulkCreate(tocat.map((e) => ItemCategoryModel.fromMap(e)).toList());

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 169, 0, 0),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ReceiptCubit>(
                create: (context) =>
                    ReceiptCubit(GetIt.instance<GetItemByBarcodeUseCase>())),
            BlocProvider<CustomersCubit>(
                create: (context) =>
                    CustomersCubit(GetIt.instance<GetCustomersUseCase>())),
          ],
          child: FutureBuilder<String>(
              future: Future.delayed(const Duration(seconds: 5), () {
                return "ABC";
              }),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/logo/maroon.svg",
                        width: 170,
                        color: const Color(0xFFD42627),
                      ),
                    ),
                  );
                }

                final str = snapshot.data!;
                debugPrint(str);
                return MaterialApp.router(
                  title: 'TestPOS',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
                    fontFamily: 'Roboto',
                    useMaterial3: true,
                  ),
                  routerConfig: AppRouter().router,
                );
              }),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
