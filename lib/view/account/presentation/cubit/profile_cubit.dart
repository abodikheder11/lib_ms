import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../config/env.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  String get _baseUrl => "${Env.baseUrl}/api";
  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$_baseUrl/view-my-profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ProfileLoaded(data));
      } else {
        emit(ProfileError('Failed to fetch profile: ${response.body}'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
