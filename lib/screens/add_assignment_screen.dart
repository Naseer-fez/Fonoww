import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../theme/app_theme.dart';

/// AddAssignmentScreen provides a form to create a new assignment.
/// Demonstrates:
/// - Form validation with GlobalKey<FormState>
/// - Form input widgets: TextFormField, DropdownButtonFormField
/// - Interactive date picking via showDatePicker
/// - Navigator-based navigation (Navigator.pop)
/// - Material 3 modal / screen presentation
class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({super.key});

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // College Subjects List
  final List<String> _subjects = const [
    'Mobile App Development',
    'Data Structures & Algorithms',
    'Database Systems',
    'Operating Systems',
    'Computer Networks',
    'Software Engineering',
    'Discrete Mathematics',
    'Artificial Intelligence',
    'General Elective',
  ];

  late String _selectedSubject;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  @override
  void initState() {
    super.initState();
    _selectedSubject = _subjects.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// Open Flutter date picker
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryAccent,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Validate and submit assignment back to caller
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newAssignment = Assignment(
        title: _titleController.text.trim(),
        subject: _selectedSubject,
        dueDate: _selectedDate,
        completed: false,
      );

      // Return created assignment to caller via Navigator
      Navigator.of(context).pop(newAssignment);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormatter = DateFormat('EEEE, MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Assignment'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form Header Subtitle
                Text(
                  'Add task details and deadline to stay organized.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                  ),
                ),
                const SizedBox(height: 24),

                // 1. Assignment Title Field
                Text(
                  'ASSIGNMENT TITLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Flutter Layout Project',
                    prefixIcon: Icon(Icons.title_rounded, size: 20),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title for the assignment';
                    }
                    if (value.trim().length < 3) {
                      return 'Title must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),

                // 2. Subject Dropdown Field
                Text(
                  'SUBJECT / COURSE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                  ),
                  dropdownColor: isDark ? const Color(0xFF1E2030) : Colors.white,
                  items: _subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : const Color(0xFF22243A),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 22),

                // 3. Due Date Picker
                Text(
                  'DUE DATE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2030) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF292C42) : const Color(0xFFE2E4EC),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event_outlined,
                              size: 20,
                              color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              dateFormatter.format(_selectedDate),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF22243A),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Change',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // 4. Action Buttons (Save & Cancel)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF3B3E5B) : const Color(0xFFD2D5E3),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF9DA2B5) : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Save Assignment'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
