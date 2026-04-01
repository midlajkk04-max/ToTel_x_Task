import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/widgets/user_card.dart';
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
        content: const Text('Logout cheyyaano?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthController>().reset();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    final ctrl = context.read<UserController>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  _sortOption(
                    label: 'All',
                    value: SortType.all,
                    ctrl: ctrl,
                    setModalState: setModalState,
                  ),
                  _sortOption(
                    label: 'Age: Elder',
                    value: SortType.elder,
                    ctrl: ctrl,
                    setModalState: setModalState,
                  ),
                  _sortOption(
                    label: 'Age: Younger',
                    value: SortType.younger,
                    ctrl: ctrl,
                    setModalState: setModalState,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sortOption({
    required String label,
    required SortType value,
    required UserController ctrl,
    required StateSetter setModalState,
  }) {
    return RadioListTile<SortType>(
      title: Text(label),
      value: value,
      groupValue: ctrl.sortType,
      activeColor: Colors.black,
      contentPadding: EdgeInsets.zero,
      onChanged: (val) {
        if (val != null) {
          ctrl.sort(val);
          setModalState(() {});
          Navigator.pop(context);
        }
      },
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
            Text(
              'Nilambur',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutDialog,
          ),
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'search by name',
                      hintStyle:
                          const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) =>
                        context.read<UserController>().search(val),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Users Lists',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: Consumer<UserController>(
              builder: (context, ctrl, _) {
                if (ctrl.users.isEmpty && ctrl.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
                if (ctrl.users.isEmpty) {
                  return const Center(
                      child: Text('No users found'));
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  itemCount:
                      ctrl.users.length + (ctrl.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == ctrl.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }
                    return UserCard(user: ctrl.users[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddUserScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}