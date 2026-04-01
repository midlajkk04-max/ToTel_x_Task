import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UserService {
  static const String _fileName = 'users.json';
  static const int pageSize = 10;
  final _uuid = const Uuid();

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<List<UserModel>> _readAll() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((e) => UserModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _writeAll(List<UserModel> users) async {
    final file = await _getFile();
    await file.writeAsString(
        jsonEncode(users.map((u) => u.toJson()).toList()));
  }

  Future<List<UserModel>> fetchUsers({
    int offset = 0,
    String searchQuery = '',
    String sortType = 'all',
  }) async {
    List<UserModel> all = await _readAll();

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      all = all
          .where((u) =>
              u.name.toLowerCase().contains(q) || u.phone.contains(q))
          .toList();
    }

    if (sortType == 'elder') {
      all = all.where((u) => u.age > 60).toList();
    } else if (sortType == 'younger') {
      all = all.where((u) => u.age <= 60).toList();
    }

    if (offset >= all.length) return [];
    final end = (offset + pageSize).clamp(0, all.length);
    return all.sublist(offset, end);
  }

  Future<String?> saveImageLocally(File image) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${_uuid.v4()}.jpg';
      final saved = await image.copy('${dir.path}/$fileName');
      return saved.path;
    } catch (e) {
      print('[UserService] saveImage error: $e');
      return null;
    }
  }

  Future<void> addUser(UserModel user) async {
    final all = await _readAll();
    all.insert(0, user);
    await _writeAll(all);
  }
}