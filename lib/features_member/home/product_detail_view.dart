import 'package:ecommerce_flutter/models/cart_item_model.dart';
import 'package:ecommerce_flutter/services/cart_service.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/user_service.dart';
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailView extends HookWidget {
  final ProductModel product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final quantity = useState<int>(1); // Track the quantity to add to cart
    final comments = useState<List<String>>([]);
    final isLoading = useState<bool>(true);
    final currentUserId = useState<String>('');
    final userService = UserService();

    useEffect(() {
      Future<void> fetchComments() async {
        comments.value = []; // Fetch comments based on product if needed
        isLoading.value = false;
      }

      // Assuming you have a method to fetch the current user
      String userId = userService
          .getCurrentUserId(); // Implement this method in UserService
      currentUserId.value = userId;
      fetchComments();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(product.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              product.name,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              '${product.price} USD',
              style: TextStyle(fontSize: 20.sp, color: Colors.green),
            ),
            SizedBox(height: 8.h),
            Text(
              product.description,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity.value > 1) {
                      quantity.value--;
                    }
                  },
                ),
                Text('${quantity.value}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    quantity.value++;
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                // Create a CartItemModel to add to the cart
                final cartItem = CartItemModel(
                  productId: product.id,
                  quantity: quantity.value,
                  // userId: currentUserId.value, // Replace with actual user ID
                  price: product.price, // Use the product price
                );
                await cartService.addOrUpdateCartItem( currentUserId.value,  cartItem);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Added to cart!'),
                ));
              },
              child: Text('Add to Cart'),
            ),
            SizedBox(height: 16.h),
            Text(
              'Comments',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.builder(
                itemCount: comments.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments.value[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
