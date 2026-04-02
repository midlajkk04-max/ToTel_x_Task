import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/user_controller.dart';
import 'user_card.dart';

class HomeUserList extends StatelessWidget {
  final ScrollController scrollController;

  const HomeUserList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<UserController>(
        builder: (context, ctrl, _) {
          if (ctrl.users.isEmpty && ctrl.isLoading) return const Center(child: CircularProgressIndicator());
          if (ctrl.users.isEmpty) return const Center(child: Text('No users found'));

          return ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: ctrl.users.length + (ctrl.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == ctrl.users.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return UserCard(user: ctrl.users[index]);
            },
          );
        },
      ),
    );
  }
}