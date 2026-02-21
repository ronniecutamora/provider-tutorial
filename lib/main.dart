import 'package:flutter/material.dart';
import 'package:my_provider/cart_provider.dart';
import 'package:my_provider/counter_provider.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CounterProvider(),),
      ChangeNotifierProvider(create: (context) => CartProvider(),)
    ],
    child: MaterialApp(
      home: MyApp(),
    ),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Consumer<CounterProvider>(builder: (context, value, child) {
              return Column(
                children: [
                  child!,
                  Text("Counter: ${value.count}")
                ],
              );
            }, child: Icon(Icons.favorite), ),

            ElevatedButton(onPressed: (){context.read<CounterProvider>().increment();}, child: Text("increment")),

            Consumer<CartProvider>(builder: (context, value, child) => Text("Cart items: ${value.items}")),

            ElevatedButton(onPressed: (){context.read<CartProvider>().addNewItem();}, child: Text("add new item")),
          ],
        ),
      ),
    );
  }
}