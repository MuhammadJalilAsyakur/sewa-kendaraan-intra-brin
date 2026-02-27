import 'package:flutter/material.dart';

class ReviewerDetailRow {
  final String label;
  final String value;

  const ReviewerDetailRow({required this.label, required this.value});
}

class ReviewerDetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<ReviewerDetailRow> rows;

  const ReviewerDetailSection({
    super.key,
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF1565C0), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // Rows
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: rows.map((row) => _buildRow(row)).toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(ReviewerDetailRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              row.label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
          Text(': ', style: TextStyle(color: Colors.grey.shade400)),
          Expanded(
            child: Text(
              row.value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
