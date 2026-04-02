import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';

class HomeSortBottomsheet extends StatelessWidget {
  final UserController ctrl;

  const HomeSortBottomsheet({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sort', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _sortOption('All', SortType.all, ctrl, setModalState, context),
              _sortOption('Age: Elder', SortType.elder, ctrl, setModalState, context),
              _sortOption('Age: Younger', SortType.younger, ctrl, setModalState, context),
            ],
          ),
        );
      },
    );
  }

  Widget _sortOption(String label, SortType value, UserController ctrl, StateSetter setModalState, BuildContext context) {
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
}