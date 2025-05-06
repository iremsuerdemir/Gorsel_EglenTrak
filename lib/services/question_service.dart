import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gorsel_programlama_proje/models/question.dart';

class QuestionService {
  // Backend’inizin base URL’i
  static const _baseUrl = 'https://<YOUR_API_DOMAIN>/api/questions';

  // Tüm soruları getir
  static Future<List<Question>> fetchAll() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Question.fromJson(e)).toList();
    } else {
      throw Exception('Sorular alınamadı: ${response.statusCode}');
    }
  }

  // Kategoriye göre soruları getir
  static Future<List<Question>> fetchByCategory(String category) async {
    final url = '$_baseUrl/by-category/${Uri.encodeComponent(category)}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Question.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      // Eğer kategori bulunamazsa, boş liste dön veya hata fırlat
      return [];
    } else {
      throw Exception('Sorular alınamadı: ${response.statusCode}');
    }
  }

  // Kategorileri getir (isteğe bağlı)
  static Future<List<String>> fetchCategories() async {
    final url = '$_baseUrl/categories';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Kategoriler alınamadı: ${response.statusCode}');
    }
  }
}
