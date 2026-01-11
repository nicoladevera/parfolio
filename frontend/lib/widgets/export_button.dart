import 'package:flutter/material.dart';

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
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.onSurface, size: 20),
      ),
      onSelected: onExport,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'json',
          child: Row(
            children: [
              Icon(Icons.data_object, color: Theme.of(context).colorScheme.onSurface, size: 20),
              SizedBox(width: 8),
              Text('Export as JSON', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'csv',
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: Theme.of(context).colorScheme.onSurface, size: 20),
              SizedBox(width: 8),
              Text('Export as CSV', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'txt',
          child: Row(
            children: [
              Icon(Icons.text_snippet_outlined, color: Theme.of(context).colorScheme.onSurface, size: 20),
              SizedBox(width: 8),
              Text('Export as Text', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

