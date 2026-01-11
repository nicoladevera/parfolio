import 'package:flutter/material.dart';
import '../core/theme.dart';

class ExportButton extends StatelessWidget {
  final Function(String) onExport;

  const ExportButton({
    Key? key,
    required this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Export Stories',
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(Icons.download_rounded, color: AppColors.textMain, size: 20),
      ),
      onSelected: onExport,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'json',
          child: Row(
            children: [
              Icon(Icons.data_object, color: AppColors.textMain, size: 20),
              SizedBox(width: 8),
              Text('Export as JSON'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'csv',
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: AppColors.textMain, size: 20),
              SizedBox(width: 8),
              Text('Export as CSV'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'txt',
          child: Row(
            children: [
              Icon(Icons.text_snippet_outlined, color: AppColors.textMain, size: 20),
              SizedBox(width: 8),
              Text('Export as Text'),
            ],
          ),
        ),
      ],
    );
  }
}
