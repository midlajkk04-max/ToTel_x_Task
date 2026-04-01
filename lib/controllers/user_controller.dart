import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

enum SortType { all, elder, younger }

class UserController extends ChangeNotifier {
  final UserService _service = UserService();
  final _uuid = const Uuid();

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _offset = 0;
  String _searchQuery = '';
  SortType _sortType = SortType.all;
  SortType get sortType => _sortType;

  String get _sortString {
    switch (_sortType) {
      case SortType.elder:
        return 'elder';
      case SortType.younger:
        return 'younger';
      default:
        return 'all';
    }
  }

  Future<void> fetchUsers({bool refresh = false}) async {
    if (_isLoading) return;
    if (!_hasMore && !refresh) return;

    if (refresh) {
      _offset = 0;
      _hasMore = true;
      _users = [];
    }

    _isLoading = true;
    notifyListeners();

    final newUsers = await _service.fetchUsers(
      offset: _offset,
      searchQuery: _searchQuery,
      sortType: _sortString,
    );

    if (newUsers.length < UserService.pageSize) _hasMore = false;
    _offset += newUsers.length;
    _users.addAll(newUsers);

    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.trim();
    fetchUsers(refresh: true);
  }

  void sort(SortType type) {
    _sortType = type;
    fetchUsers(refresh: true);
  }

  Future<bool> addUser({
    required String name,
    required String phone,
    required int age,
    File? image,
  }) async {
    try {
      String? imagePath;
      if (image != null) {
        imagePath = await _service.saveImageLocally(image);
      }
      final user = UserModel(
        id: _uuid.v4(),
        name: name,
        phone: phone,
        age: age,
        imagePath: imagePath,
      );
      await _service.addUser(user);
      await fetchUsers(refresh: true);
      return true;
    } catch (e) {
      print('[UserController] addUser error: $e');
      return false;
    }
  }
}