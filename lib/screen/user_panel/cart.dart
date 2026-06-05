import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final supabase = Supabase.instance.client;

  Future<void> deleteCartItem(String id) async {
    await supabase.from("cart").delete().eq("id", id);

    setState(() {});
  }

  String imageUrl(String fileName) {
    return supabase.storage.from("images").getPublicUrl(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 400,
      child: FutureBuilder(
        future: supabase
            .from("cart")
            .select("id,quantity,product(name,price,image_url)"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final cart = snapshot.data as List;

          if (cart.isEmpty) {
            return const Center(
              child: Text("No Items In Cart"),
            );
          }

          return ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final p = cart[index];
              final product = p["product"];
              final quantity = p["quantity"];
              final price = product["price"];
              final totalPrice = quantity * price;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: product["image_url"] == null
                      ? const Icon(Icons.image)
                      : Image.network(
                          imageUrl(product["image_url"]),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                  title: Text(product["name"]),
                  subtitle: Text(
                    "Rs $price × $quantity = Rs $totalPrice",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () async {
                          if (quantity > 1) {
                            await supabase
                                .from("cart")
                                .update({
                                  "quantity": quantity - 1,
                                })
                                .eq("id", p["id"]);
                          } else {
                            await supabase
                                .from("cart")
                                .delete()
                                .eq("id", p["id"]);
                          }

                          setState(() {});
                        },
                      ),

                      Text(quantity.toString()),

                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await supabase
                              .from("cart")
                              .update({
                                "quantity": quantity + 1,
                              })
                              .eq("id", p["id"]);

                          setState(() {});
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await deleteCartItem(p["id"]);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Item Deleted"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
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