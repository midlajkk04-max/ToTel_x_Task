import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/widgets/home_custom_serchbar.dart';
import 'package:totel_x_task/view/widgets/home_sort_bottomsheet.dart';
import 'package:totel_x_task/view/widgets/home_user_list.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../auth/login_screen.dart';
import 'add_user_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchUsers(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<UserController>().fetchUsers();
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthController>().reset();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => HomeSortBottomsheet(ctrl: context.read<UserController>()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.location_on, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text('Nilambur', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _showLogoutDialog),
          GestureDetector(
            onTap: _showSortSheet,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.sort, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          HomeCustomSerchbar(
            controller: _searchController,
            onChanged: (val) => context.read<UserController>().search(val),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Users List', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          HomeUserList(scrollController: _scrollController),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddUserScreen())),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}