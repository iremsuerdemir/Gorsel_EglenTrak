import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/custom_text_field.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});
  final TextEditingController nameController = TextEditingController();
  final List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // --- Resim Alanı ---
              GestureDetector(
                onTap: () {
                  // buraya galeri açma kodu eklenir
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Resim seçme fonksiyonu buraya eklenecek!'),
                    ),
                  );
                },
                child: GradientBorder(
                  height: 180,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Resim Ekle',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // --- TextField ---
              CustomTextField(controller: nameController, label: "Ad"),

              // --- Liste ya da Boş İkon ---
              imagePaths.isEmpty
                  ? SizedBox(
                    height: MediaQuery.of(context).size.height - 350,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imagePaths.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Image.network(imagePaths[i]),
                        title: Text(imagePaths[i]),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      text: "İptal",
                      height: 30,
                      icon: Icon(Icons.close),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      height: 30,
                      text: "Kaydet",
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icon(Icons.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
