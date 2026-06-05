import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProduct extends StatefulWidget {
  final Map product; // 👈 important

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  Uint8List? imageBytes;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    // old data fill
    nameController.text = widget.product["name"];
    priceController.text = widget.product["price"].toString();
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      imageBytes = result.files.first.bytes;
    });
  }

  Future<void> updateProduct() async {
    try {
      String? uploadedFileName;

      // upload new image if selected
      if (imageBytes != null) {
        uploadedFileName =
            "${DateTime.now().microsecondsSinceEpoch}.png";

        await supabase.storage
            .from("images")
            .uploadBinary(uploadedFileName, imageBytes!);
      }

      await supabase.from("product").update({
        "name": nameController.text,
        "price": double.parse(priceController.text),
        if (uploadedFileName != null) "image_url": uploadedFileName,
      }).eq("id", widget.product["id"]);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Updated")),
      );

      Navigator.pop(context); // back to list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Change Image"),
            ),

            const SizedBox(height: 10),

            if (imageBytes != null)
              Image.memory(imageBytes!, height: 120),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateProduct,
              child: const Text("Update Product"),
            ),
          ],
        ),
      ),
    );
  }
}