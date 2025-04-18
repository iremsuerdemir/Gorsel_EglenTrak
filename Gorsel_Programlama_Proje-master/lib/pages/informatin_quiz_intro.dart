import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationQuizIntro extends StatelessWidget {
  final List<Map<String, dynamic>> rules = [
    {"emoji": "✔️", "text": "Her doğru cevap 10 puan kazandırır."},
    {"emoji": "❌", "text": "Yanlış cevapta puan kaybı yok."},
    {"emoji": "⏱️", "text": "Soru başına 20 saniye süren var."},
    {"emoji": "🏆", "text": "En yüksek puanını hedefle!"},
    {"emoji": "📊", "text": "Her 5 sorudan sonra kısa bir mola verilecektir."},
    {"emoji": "🎯", "text": "Sorular rastgele sırayla karşına çıkacaktır."},
    {"emoji": "💡", "text": "Hızlı düşün ve doğru cevabı ver!"},
    {"emoji": "📅", "text": "Sorular kategorilere göre hazırlanmıştır."},
    {"emoji": "🔒", "text": "Oyun ilerledikçe sorular zorlaşacaktır."},
    {
      "emoji": "📈",
      "text": "En yüksek puanını kaydet ve arkadaşlarınla paylaş!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade700,
        centerTitle: true,
        title: Text(
          "📌 Oyun Kuralları",
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 2),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: rules.length,
          separatorBuilder: (context, index) => Divider(color: Colors.white24),
          itemBuilder: (context, index) {
            final rule = rules[index];
            return Card(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.white24),
              ),
              elevation: 4,
              child: ListTile(
                leading: Text(rule["emoji"], style: TextStyle(fontSize: 24)),
                title: Text(
                  rule["text"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
