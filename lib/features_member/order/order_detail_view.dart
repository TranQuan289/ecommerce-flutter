import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.id}'),
            SizedBox(height: 8),
            Text('Status: ${order.status}'),
            Text('Date: ${order.createdAt.toString()}'),
            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text(
              'Items:',
            ),
            ...order.items.map((item) => ListTile(
                  title: Text(item.productId),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                )),
          ],
        ),
      ),
    );
  }
}
