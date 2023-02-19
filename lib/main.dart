import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_api_rest/src/app_observer.dart';
import 'package:testing_bloc_api_rest/src/counter/bloc/counter_bloc.dart';
import 'package:testing_bloc_api_rest/src/counter/bloc/counter_event.dart';
import 'package:testing_bloc_api_rest/src/store/views/store_app.dart';

void main() {
  Bloc.observer = AppObserver();
  runApp(const StoreApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => CounterBloc(),
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  void _incrementCounter() {
    context.read<CounterBloc>().add(CounterIncremented());
  }

  void _decrementCounter() {
    context.read<CounterBloc>().add(CounterDecremented());
  }

  @override
  Widget build(BuildContext context) {
    // final state = context.watch<CounterBloc>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CounterBloc, int>(
              builder: (context, state) {
                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.remove),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
