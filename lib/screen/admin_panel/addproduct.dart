import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  String? imageName;

  final supabase = Supabase.instance.client;

  // IMAGE PICK + UPLOAD
  Future<void> uploadImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null) return;

      final Uint8List imageBytes = result.files.first.bytes!;

      final String fileName =
          "${DateTime.now().microsecondsSinceEpoch}.png";

      await supabase.storage
          .from("images")
          .uploadBinary(fileName, imageBytes);

      setState(() {
        imageName = fileName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image Uploaded")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error ${e.toString()}")),
      );
    }
  }

  // PRODUCT INSERT
  Future<void> addProduct() async {
    try {
      if (imageName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload image first")),
        );
        return;
      }

      await supabase.from("product").insert({
        "name": nameController.text,
        "price": double.parse(priceController.text),
        "image_url": imageName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added")),
      );

      nameController.clear();
      priceController.clear();

      setState(() {
        imageName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
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
              onPressed: uploadImage,
              child: const Text("Upload Image"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: addProduct,
              child: const Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }
}