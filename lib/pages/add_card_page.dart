import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/custom_text_field.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController nameController = TextEditingController();

  final List<Map<String, String>> imagePaths =
      []; // Her resim için hem URL hem de dosya adı tutacağız

  // Tarayıcıda resim seçme fonksiyonu
  void pickImage(BuildContext context) async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Sadece resim dosyaları kabul edilecek
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files!.isEmpty) return;

      final reader = html.FileReader();
      reader.readAsDataUrl(files[0]);
      reader.onLoadEnd.listen((e) {
        final imageUrl = reader.result as String;
        final fileName = files[0].name; // Dosya adı

        // Resim URL'ini ve dosya adını listeye ekleyelim
        setState(() {
          imagePaths.add({'url': imageUrl, 'name': fileName});
        });
      });
    });
  }

  void showEditDialog(BuildContext context, int index) {
    final TextEditingController editNameController = TextEditingController(
      text: imagePaths[index]['name'],
    );
    String? editedImageUrl = imagePaths[index]['url'];

    void pickNewImage() async {
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;

        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]);
        reader.onLoadEnd.listen((e) {
          setState(() {
            editedImageUrl = reader.result as String;
            editNameController.text = files[0].name;
          });
        });
      });
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Düzenle'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editNameController,
                  decoration: InputDecoration(labelText: 'Dosya Adı'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('İptal'),
              ),
              ElevatedButton.icon(
                onPressed: pickNewImage,
                icon: Icon(Icons.image),
                label: Text('Yeni Resim Seç'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    imagePaths[index] = {
                      'url': editedImageUrl!,
                      'name': editNameController.text,
                    };
                  });
                  Navigator.pop(context);
                },
                child: Text('Kaydet'),
              ),
            ],
          ),
    );
  }

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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            // --- Resim Alanı ---
            GestureDetector(
              onTap:
                  () => pickImage(
                    context,
                  ), // Resim seçme fonksiyonunu çağırıyoruz
              child: GradientBorder(
                height: 180,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Resim Ekle', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // --- TextField ---
            CustomTextField(
              controller: nameController,
              label: "Başlık",
              focusedColor: Theme.of(context).primaryColor,
            ),

            SizedBox(height: 10),

            // --- Liste ya da Boş İkon ---
            imagePaths.isEmpty
                ? SizedBox(
                  height: MediaQuery.of(context).size.height - 370,
                  child: Center(
                    child: Icon(Icons.image_not_supported, size: 50),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    physics:
                        BouncingScrollPhysics(), // Scroll özelliklerini ekliyoruz
                    shrinkWrap: true,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Image.network(
                            imagePaths[i]['url']!, // URL kullanılıyor
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            imagePaths[i]['name']!,
                          ), // Dosya adı burada gösteriliyor
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEditDialog(context, i);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    imagePaths.removeAt(i); // Resim silme
                                  });
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

            SizedBox(height: 10),
            // --- Butonlar ---
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
    );
  }
}
