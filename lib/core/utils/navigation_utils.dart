import 'package:flutter/material.dart';
import '../../model/user_model.dart';
import '../../views/main_layout.dart';
import '../../views/collector/collector_layout.dart';
import '../../views/auth/collector_pending_screen.dart';

Widget getLayoutForUser(UserModel? user) {
  if (user == null) return const MainLayout();
  
  // If user has a collector profile but is not approved yet
  if (user.collectorId != null && user.isCollectorApproved != true) {
    return const CollectorPendingScreen();
  }

  if (user.role == 'COLLECTOR' || (user.collectorId != null && user.isCollectorApproved == true)) {
    return const CollectorLayout();
  }
  
  // If user is ADMIN or anything else, just fall back to MainLayout 
  return const MainLayout();
}
