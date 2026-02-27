import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? value;
  final DateTime? minDate;
  final DateTime? maxDate;
  final ValueChanged<DateTime> onChanged;
  final String? Function(DateTime?)? validator;
  final bool withTime;
  final bool readOnly;

  const CustomDateTimePicker({
    super.key,
    required this.label,
    this.hint = 'dd/MM/yyyy',
    this.value,
    this.validator,
    required this.onChanged,
    this.withTime = false,
    this.readOnly = false,
    this.maxDate,
    this.minDate,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: value != null
          ? (withTime
              ? DateFormat('dd/MM/yyyy HH:mm').format(value!)
              : DateFormat('dd/MM/yyyy').format(value!))
          : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          validator: (_) => validator?.call(value),
          onTap: readOnly
              ? null
              : () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: value ?? DateTime.now(),
                    firstDate: minDate ?? DateTime(2000),
                    lastDate: maxDate ?? DateTime(2100),
                  );

                  if (pickedDate == null) return;

                  if (withTime) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(value ?? DateTime.now()),
                    );

                    if (pickedTime == null) return;

                    final combined = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    onChanged(combined);
                  } else {
                    onChanged(pickedDate);
                  }
                },
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(
              withTime ? Icons.access_time : Icons.calendar_today,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
