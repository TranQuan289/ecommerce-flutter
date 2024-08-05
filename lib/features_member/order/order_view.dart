import 'package:ecommerce_flutter/features_member/order/order_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_flutter/models/order_model.dart';
import 'package:ecommerce_flutter/services/order_service.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OrderView extends HookWidget {
    const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderService = useMemoized(() => OrderService());
    final userService = useMemoized(() => UserService());

    final ordersStream = useMemoized(() {
      try {
        final userId = userService.getCurrentUserId();
        return orderService.getUserOrders(userId);
      } catch (e) {
        return Stream.value(<OrderModel>[]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order.status}'),
                      Text('Date: ${order.createdAt.toString()}'),
                      Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsView(order: order),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

