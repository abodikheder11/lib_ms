import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/env.dart';
import '../../../home/data/models/book_model.dart';

class BookRepository {
  BookRepository();

  String get _baseUrl => "${Env.baseUrl}/api";

  Future<List<Book>> getFavoriteBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final res = await http.get(
      Uri.parse('$_baseUrl/view-favorite-books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load favorite books');
    }
  }

  Future<void> addToFavorite(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final res = await http.post(
      Uri.parse('$_baseUrl/add-book-to-Favorite/$bookId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to add book to favorites');
    }
  }

  Future<List<Book>> fetchBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final res = await http.get(
      Uri.parse('${Env.baseUrl}/api/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<File> downloadBook(int bookId, String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final dio = Dio();
    final dir = await getApplicationDocumentsDirectory();
    final savePath = '${dir.path}/$fileName';

    try {
      final response = await dio.download(
        '$_baseUrl/download-books/$bookId',
        savePath,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );
      if (response.statusCode == 200) {
        return File(savePath);
      } else {
        throw Exception("Failed to download book: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error downloading book: $e");
    }
  }
}
