import 'package:flutter/material.dart';

class DokumenUploadField extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onBrowse;

  const DokumenUploadField({
    super.key,
    required this.label,
    required this.fileName,
    required this.onBrowse,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: hasFile
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFF5F6FA),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: hasFile
                        ? const Color(0xFF2E7D32)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasFile
                          ? Icons.insert_drive_file_outlined
                          : Icons.upload_file_outlined,
                      size: 16,
                      color: hasFile
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName ?? 'Pilih file PDF...',
                        style: TextStyle(
                          fontSize: 13,
                          color: hasFile
                              ? const Color(0xFF2E7D32)
                              : Colors.grey.shade400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onBrowse,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  'Browse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (hasFile) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 13,
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(width: 4),
              Text(
                'File berhasil dipilih',
                style: TextStyle(fontSize: 11, color: const Color(0xFF2E7D32)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
