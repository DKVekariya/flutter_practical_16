import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_practical_16/data/thought_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThoughtsApiService {
  final Dio _dio = Dio();

  // In a real app, this would be your API endpoint
  // For this example, we'll simulate API calls using local storage
  Future<List<Thought>> getThoughts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final String? thoughtsJson = prefs.getString('thoughts');

    if (thoughtsJson == null) return [];

    List<dynamic> thoughtsList = jsonDecode(thoughtsJson);
    return thoughtsList.map((json) => Thought.fromJson(json)).toList();
  }

  Future<void> saveThought(Thought thought) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final String? thoughtsJson = prefs.getString('thoughts');

    List<dynamic> thoughtsList = [];
    if (thoughtsJson != null) {
      thoughtsList = jsonDecode(thoughtsJson);
    }

    thoughtsList.add(thought.toJson());
    await prefs.setString('thoughts', jsonEncode(thoughtsList));
  }
}

