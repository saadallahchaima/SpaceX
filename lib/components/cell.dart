import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_orange2/models/Launch.dart';
import 'package:test_orange2/views/listeLaunch.dart';

class Cell extends StatelessWidget {
  final Launch launch;

  const Cell(this.launch, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaunchDetailsScreen(launchId: launch.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 8,
        color: theme.cardColor, 
        child: ListTile(
          contentPadding: EdgeInsets.all(16.w),
          leading: Icon(
            Icons.flight_takeoff,
            color: theme.iconTheme.color,
            size: 40.sp,
          ),
          title: Text(
            launch.missionName.isNotEmpty ? launch.missionName : 'Pas de nom disponible',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              launch.details.isNotEmpty
                  ? launch.details
                  : 'Pas de détails disponibles',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color ?? Colors.grey[600],
              ),
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              launch.launchYear,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
