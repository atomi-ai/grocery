import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/order_provider.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    _fetchOrders = _fetchOrdersFromProvider();
  }

  Future<void> _fetchOrdersFromProvider() async {
    await Provider.of<OrderProvider>(context, listen: false).fetchOrders();
  }
  String formatDate(DateTime createdAt) {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}:${createdAt.second.toString().padLeft(2, '0')}';
  }

  Widget buildOrderItem(BuildContext context, OrderItem item) {
    return Row(
      children: [
        Image.asset(
          '${item.product.imageUrl}',
          height: 60,
          width: 60,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  '${item.product.name} × ${item.quantity}',
                  style: TextStyle(fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 6),
              Text('\$${item.product.price * item.quantity}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOrderCard(BuildContext context, Order order) {
    Color statusTextColor;
    switch (order.displayStatus) {
      case 'succeeded':
        statusTextColor = Colors.green;
        break;
      case 'pending payment':
        statusTextColor = Colors.red;
        break;
      case 'refunded':
        statusTextColor = Colors.grey;
        break;
      default:
        statusTextColor = Colors.orange;
        break;
    }

    String formattedDate = formatDate(order.createdAt!);
    double totalPrice = order.orderItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formattedDate),
                Text(
                  '${order.displayStatus}',
                  style: TextStyle(color: statusTextColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              // child: Divider(
              //   color: Colors.grey,
              //   thickness: 0.3,
              //   height: 0.3,
              // ),
            ),
            for (OrderItem item in order.orderItems)
              buildOrderItem(context, item),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              // child: Divider(
              //   color: Colors.grey,
              //   thickness: 0.3,
              //   height: 0.3,
              // ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: \$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder<void>(
        future: _fetchOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _fetchOrdersFromProvider,
            child: Consumer<OrderProvider>(
              builder: (context, orderProvider, _) {
                List<Order> orders = orderProvider.orders;

                if (orders.isEmpty) {
                  return Center(child: Text('No orders found'));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return buildOrderCard(context, orders[index]);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

}
