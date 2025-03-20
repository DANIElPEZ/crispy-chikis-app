import 'package:flutter/material.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/card_orders_view.dart';
import 'package:chispy_chikis/components/filter_option_orders_view.dart';

class Orders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrdersState();
}

class OrdersState extends State<Orders> {
  List orders = [
    [
      '23/04/2025 14h',
      [
        [2, 'presa de pollo y pechuga', '3.000'],
        [1, 'Cocacola', '3.100']
      ],
      0
    ],
    [
      '23/04/2025 12h',
      [
        [2, 'presa de pechuga', '3.000'],
        [1, 'Jugo de mora', '3.100']
      ],
      1
    ]
  ];

  String selectedFilter = 'Todos';
  final List<List> filters = [
    ['Todos', () {}],
    ['Pendientes', () {}],
    ['Cancelados', () {}]
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      color: colorsPalete['dark blue'],
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: filters
                .map((filter) =>
                FilterOption(
                    title: filter[0],
                    onPressed: () {
                      setState(() => selectedFilter = filter[0]);
                      filter[1]();
                    },
                    isSelected: selectedFilter == filter[0]))
                .toList()),
        SizedBox(height: 13),
        Expanded(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return CardOrder(date: orders[index][0],
                      order: orders[index][1],
                      cancel: orders[index][2]);
                }))
      ]),
    );
  }
}
