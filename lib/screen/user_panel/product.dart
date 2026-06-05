import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    String imageUrl(String fileName) {
      return supabase.storage.from("images").getPublicUrl(fileName);
    }

    return Scaffold(
      body: FutureBuilder(
        future: supabase.from("product").select(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = snapshot.data as List;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // WEB GRID
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: product.length,
              itemBuilder: (context, index) {
                final p = product[index];

                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGE
                        Expanded(
                          child: Center(
                            child: p["image_url"] == null
                                ? const Icon(Icons.image, size: 60)
                                : Image.network(
                                    imageUrl(p["image_url"]),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // NAME
                        Text(
                          p["name"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // PRICE
                        Text(
                          "Rs ${p["price"]}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final existing = await supabase
                                    .from("cart")
                                    .select()
                                    .eq("product_id", p["id"])
                                    .maybeSingle();

                                if (existing != null) {
                                  await supabase.from("cart").update({
                                    "quantity": existing["quantity"] + 1
                                  }).eq("id", existing["id"]);
                                } else {
                                  await supabase.from("cart").insert({
                                    "product_id": p["id"],
                                    "quantity": 1,
                                  });
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Added to Cart")),
                                );
                              },
                              child: const Text("Add"),
                            ),

                           
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}