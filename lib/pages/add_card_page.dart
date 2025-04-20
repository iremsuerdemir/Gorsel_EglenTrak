import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:gorsel_programlama_proje/components/custom_button.dart';
import 'package:gorsel_programlama_proje/components/custom_text_field.dart';
import 'package:gorsel_programlama_proje/components/gradient_border.dart';
import 'package:gorsel_programlama_proje/models/card_model.dart';

class AddCardPage extends StatefulWidget {
  final List<CardModel>? cards;
  final String? title;
  final String? description;
  final int? round;
  const AddCardPage({
    super.key,
    this.cards,
    this.title,
    this.round,
    this.description,
  });

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController headerController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<CardModel> imagePaths =
      []; // Her resim için hem URL hem de dosya adı tutacağız

  int? selectedValue = 32;
  int selectedHeaderIndex = 0;
  late bool isWillUpdate; //veri tabanına güncelleme yapılacak mı?

  @override
  void initState() {
    super.initState();
    if (widget.cards != null) {
      if (widget.title != null &&
          widget.round != null &&
          widget.description != null) {
        imagePaths.addAll(widget.cards!);
        isWillUpdate = true;
        headerController.text = widget.title!;
        descriptionController.text = widget.description!;
      } else {
        throw Exception(
          "Düzenleme yapılacağından title, description ve round null olamaz",
        );
      }
    } else {
      isWillUpdate = false;
    }
  }

  // Tarayıcıda resim seçme fonksiyonu
  void pickImage(BuildContext context) async {
    if (selectedValue == null) {
      setState(() {
        selectedValue = 32;
      });
    }
    if (imagePaths.length >= selectedValue!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Eklenen görsel sayısısı $selectedValue sayısını aştı"),
          showCloseIcon: true,
        ),
      );
      return;
    }
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
          imagePaths.add(
            CardModel(
              id: DateTime.now().millisecondsSinceEpoch,
              name: fileName,
              imagePath: imageUrl,
            ),
          );
        });
      });
    });
  }

  void showEditDialog(BuildContext context, int index) {
    final TextEditingController editNameController = TextEditingController(
      text: imagePaths[index].name,
    );
    String? editedImageUrl = imagePaths[index].imagePath;

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
            content: CustomTextField(
              controller: editNameController,
              label: "Ad",
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
                    imagePaths[index] = CardModel(
                      id: imagePaths[index].id,
                      name: editNameController.text,
                      imagePath: editedImageUrl!,
                    );
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
                backgroundImage:
                    imagePaths.isNotEmpty
                        ? imagePaths[selectedHeaderIndex].imagePath
                        : null,
                child: Center(
                  child:
                      imagePaths.isEmpty
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Resim Ekle',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                          : Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Eklemeye Devam et',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // --- TextField ---
            CustomTextField(
              controller: headerController,
              label: "Başlık",
              focusedColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 10),
            CustomTextField(
              controller: descriptionController,
              label: "Açıklama",
              focusedColor: Theme.of(context).primaryColor,
            ),

            SizedBox(height: 10),

            SizedBox(
              width: 100,
              child: DropdownButton<int>(
                isExpanded: true,
                value: selectedValue,
                icon: Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
                underline: Container(
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
                focusColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                onChanged: (int? newValue) {
                  if (imagePaths.length > newValue!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Görsel sayısı bu miktar için çok büyük"),
                        showCloseIcon: true,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                items:
                    <int>[2, 4, 8, 16, 32, 64, 128].map<DropdownMenuItem<int>>((
                      int value,
                    ) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Center(child: Text(value.toString())),
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 10),

            // --- Liste ya da Boş İkon ---
            imagePaths.isEmpty
                ? Expanded(
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
                            imagePaths[i].imagePath, // URL kullanılıyor
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                          title: Text(
                            imagePaths[i].name,
                          ), // Dosya adı burada gösteriliyor
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedHeaderIndex = i;
                                  });
                                },
                                icon:
                                    selectedHeaderIndex != i
                                        ? Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.white,
                                        )
                                        : Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                              ),
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
                                    imagePaths.removeAt(i);
                                    if (imagePaths.isEmpty ||
                                        selectedHeaderIndex == i) {
                                      selectedHeaderIndex = 0;
                                    } else if (i < selectedHeaderIndex) {
                                      selectedHeaderIndex--;
                                    } else if (i > selectedHeaderIndex) {
                                      //hiçbir şey yapma
                                    } else {
                                      selectedHeaderIndex = 0;
                                    }
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
                    onPressed: () {
                      setState(() {
                        imagePaths.clear();
                        headerController.clear();
                        selectedHeaderIndex = 0;
                      });
                    },
                    text: "Tümünü temizle",
                    height: 30,
                    icon: Icon(Icons.close),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      if (imagePaths.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Lütfen en az bir görsel ekleyin!"),
                          ),
                        );
                        return;
                      }

                      if (headerController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Başlık boş olamaz!")),
                        );
                        return;
                      }

                      if (isWillUpdate) {
                        // 🔄 GÜNCELLEME İŞLEMİ
                        // Buraya veri tabanı güncelleme kodunu koyacaksın.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Başarıyla güncellendi!")),
                        );
                      } else {
                        // ➕ YENİ KAYIT İŞLEMİ
                        // Buraya veri tabanı kayıt kodunu koyacaksın.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Başarıyla kaydedildi!")),
                        );
                      }
                    },
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
