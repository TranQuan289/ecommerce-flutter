import 'package:ecommerce_flutter/features_member/home/product_detail_view.dart';
import 'package:ecommerce_flutter/models/product_model.dart';
import 'package:ecommerce_flutter/services/product_service.dart';
import 'package:ecommerce_flutter/services/user_service.dart'; // Import the UserService
import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();
    final userService = UserService(); // Create an instance of UserService
    final products = useState<List<ProductModel>>([]);
    final isLoading = useState<bool>(true);
    final currentUserId = useState<String>(''); // State for current user ID

    useEffect(() {
      Future<void> fetchCurrentUserId() async {
        // Fetch the current user ID from the UserService
        try {
          // Assuming you have a method to fetch the current user
          String userId = userService
              .getCurrentUserId(); // Implement this method in UserService
          currentUserId.value = userId;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to get user ID: $e'),
          ));
        }
      }

      fetchCurrentUserId();
      return null;
    }, []);

    useEffect(() {
      Future<void> fetchData() async {
        try {
          List<ProductModel> fetchedProducts =
              await productService.fetchProducts();
          products.value = fetchedProducts;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to load products: $e'),
          ));
        } finally {
          isLoading.value = false;
        }
      }

      fetchData();
      return null;
    }, []);

    if (isLoading.value) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorUtils.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.primaryBackgroundColor,
          title: Text(
            'Home',
            style: TextStyle(
              color: ColorUtils.primaryColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Home',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: products.value.length,
        itemBuilder: (context, index) {
          final product = products.value[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            elevation: 2,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  product.imageUrl,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product.name),
              subtitle: Text('${product.price} USD'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      product.favoriteUserIds.contains(currentUserId.value)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          product.favoriteUserIds.contains(currentUserId.value)
                              ? Colors.red
                              : null,
                    ),
                    onPressed: () async {
                      await productService.toggleFavorite(
                          product.id, currentUserId.value);
                      // Refresh the product list to reflect the updated favorite status
                      final updatedProducts =
                          await productService.fetchProducts();
                      products.value = updatedProducts;
                    },
                  ),
                  // Inside the ListView.builder in HomeView
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailView(product: product),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
