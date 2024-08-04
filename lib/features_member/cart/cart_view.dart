import 'package:ecommerce_flutter/models/cart_item_model.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/cart_service.dart';
import 'package:ecommerce_flutter/services/product_service.dart'; // Import ProductService
import 'package:ecommerce_flutter/services/user_service.dart'; // Import UserService
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends HookWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final productService =
        ProductService(); // Create an instance of ProductService
    final userService = UserService(); // Create an instance of UserService
    final cartItems = useState<List<CartItemModel>>([]);
    final isLoading = useState<bool>(true);
    final totalAmount = useState<double>(0.0); // To hold the total amount

    // Get the current user ID directly from UserService
    final currentUserId = userService.getCurrentUserId();

    void calculateTotalAmount() {
      totalAmount.value = cartItems.value.fold(
          0.0,
          (sum, item) =>
              sum +
              (item.quantity *
                  item.price)); // Assuming price is available in the CartItemModel
    }

    useEffect(() {
      Future<void> fetchCartItems() async {
        try {
          List<CartItemModel> fetchedItems =
              await cartService.fetchCartItems(currentUserId);
          cartItems.value = fetchedItems;
          calculateTotalAmount(); // Calculate total amount on fetch
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to load cart items: $e'),
          ));
        } finally {
          isLoading.value = false;
        }
      }

      fetchCartItems();
      return null;
    }, []);

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text('Cart'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text('Cart'),
      ),
      body: cartItems.value.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.value.length,
                    itemBuilder: (context, index) {
                      final item = cartItems.value[index];
                      return FutureBuilder<ProductModel?>(
                        future: productService.fetchProductDetails(
                            item.productId), // Fetch product details
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Show loading indicator while fetching
                          } else if (snapshot.hasError) {
                            return ListTile(
                                title: Text('Error fetching product details'));
                          } else if (!snapshot.hasData) {
                            return ListTile(title: Text('Product not found'));
                          } else {
                            final product = snapshot.data!;
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 15.w),
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 100.w,
                                      height: 100.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Price: ${item.price} USD',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        Text(
                                          'Quantity: ${item.quantity}',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: Colors.red),
                                        onPressed: () {
                                          if (item.quantity > 1) {
                                            item.quantity--;
                                            cartItems.value = List.from(
                                                cartItems.value); // Refresh UI
                                            calculateTotalAmount(); // Recalculate total
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          item.quantity++;
                                          cartItems.value = List.from(
                                              cartItems.value); // Refresh UI
                                          calculateTotalAmount(); // Recalculate total
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.black),
                                        onPressed: () async {
                                          // Remove item from cart
                                          await cartService.removeFromCart(item
                                              .id); // Implement this method in CartService
                                          cartItems.value.removeAt(index);
                                          cartItems.value = List.from(
                                              cartItems.value); // Refresh UI
                                          calculateTotalAmount(); // Recalculate total
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total: ${totalAmount.value} USD',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      ElevatedButton(
                        onPressed: () async {
                          // Checkout logic
                          for (var item in cartItems.value) {
                            await cartService.addToWaitingCart(
                                item); // You need to implement this method
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Checkout successful! Your order is waiting for approval.'),
                          ));
                          // Clear cart after checkout
                          cartItems.value.clear();
                          totalAmount.value = 0.0; // Reset total
                        },
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
