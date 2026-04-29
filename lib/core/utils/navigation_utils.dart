import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../views/main_layout.dart';
import '../../views/collector/collector_layout.dart';

Widget getLayoutForUser(UserModel? user) {
  if (user == null) return const MainLayout();
  if (user.role == 'COLLECTOR') return const CollectorLayout();
  
  // If user is ADMIN or anything else, just fall back to MainLayout 
  // (Admin is primarily on web)
  return const MainLayout();
}
