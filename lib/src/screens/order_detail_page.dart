import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:intl/intl.dart';
class OrderDetailsPage extends StatelessWidget {
  final Order order;

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${order.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text('Created at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.createdAt!)}'),
            SizedBox(height: 10),
            Text('Updated at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(order.updatedAt!)}'),
            SizedBox(height: 10),
            Text('Payment Intent ID: ${order.paymentIntentId}'),
            SizedBox(height: 10),
            Text('Deliver ID: ${order.deliveryId}'),
            SizedBox(height: 10),
            Text('Status: ${order.displayStatus}'),
            SizedBox(height: 20),
            Text(
              'Order Items:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(
              children: order.orderItems.map((item) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      '${item.product.imageUrl}',
                      height: 60,
                      width: 60,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text('${item.product.name} × ${item.quantity}'),
                    subtitle: Text('Price: \$${item.product.price}\nCategory: ${item.product.category}'),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

