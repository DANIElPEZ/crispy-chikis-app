abstract class OrdersEvent{}

class StreamGetLatestOrder extends OrdersEvent{}

class loadProducts extends OrdersEvent{}

class createListProducts extends OrdersEvent{}

class OnOrderDataReceived extends OrdersEvent {
  final List<Map<String, dynamic>> data;
  OnOrderDataReceived(this.data);
}