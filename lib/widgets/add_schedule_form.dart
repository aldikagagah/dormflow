import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/schedule_service.dart';

class AddScheduleForm extends StatefulWidget {

  const AddScheduleForm({
    super.key,
    this.existingSchedule,
    this.onSaved,
  });
  final Map<String, dynamic>? existingSchedule;
  final VoidCallback? onSaved;

  @override
  State<AddScheduleForm> createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  final ScheduleService _service = ScheduleService();
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _memberNameController = TextEditingController(); // Manual input

  String _selectedCategory = 'Piket';
  DateTime _selectedDate = DateTime.now();
  String? _selectedMemberId;
  String? _selectedMemberName;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;
  bool _isLoadingMembers = true; // Track loading state

  final List<String> _categories = ['Piket', 'Ngaji', 'Pemateri'];

  @override
  void initState() {
    super.initState();
    _loadMembers();

    // If editing existing schedule
    if (widget.existingSchedule != null) {
      final data = widget.existingSchedule!;
      _taskNameController.text = (data['taskName'] as String?) ?? '';
      _selectedCategory = (data['category'] as String?) ?? 'Piket';
      _selectedDate = (data['date'] as DateTime?) ?? DateTime.now();
      _selectedMemberId = data['assignedMemberId'] as String?;
      _selectedMemberName = data['assignedMemberName'] as String?;
    }
  }

  Future<void> _loadMembers() async {
    final members = await _service.getMembers();
    if (!mounted) return;
    setState(() {
      _isLoadingMembers = false;
      _members = members;
      // If no existing member selected and we have members, select first
      if (_selectedMemberId == null && members.isNotEmpty) {
        _selectedMemberId = members.first['id'] as String?;
        _selectedMemberName = members.first['name'] as String?;
      }
      // If editing and members list is empty, use manual input
      if (_members.isEmpty && _selectedMemberName != null) {
        _memberNameController.text = _selectedMemberName!;
      }
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Handle manual input mode
    if (_members.isEmpty) {
      final manualName = _memberNameController.text.trim();
      if (manualName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nama petugas tidak boleh kosong'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      _selectedMemberName = manualName;
      _selectedMemberId = 'manual_${DateTime.now().millisecondsSinceEpoch}';
    } else if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih anggota asrama terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String result;
    if (widget.existingSchedule != null) {
      // Update existing
      result = await _service.updateSchedule(
        (widget.existingSchedule!['id'] as String?) ?? '',
        {
          'taskName': _taskNameController.text.trim(),
          'category': _selectedCategory,
          'assignedMemberId': _selectedMemberId,
          'assignedMemberName': _selectedMemberName,
          'date': _selectedDate,
          'dateString': DateFormat('yyyy-MM-dd').format(_selectedDate),
        },
      );
    } else {
      // Create new
      result = await _service.addSchedule(
        taskName: _taskNameController.text.trim(),
        category: _selectedCategory,
        assignedMemberId: _selectedMemberId!,
        assignedMemberName: _selectedMemberName!,
        date: _selectedDate,
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == 'success') {
      widget.onSaved?.call();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingSchedule != null
              ? 'Jadwal berhasil diperbarui'
              : 'Jadwal berhasil ditambahkan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _memberNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingSchedule != null;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEditing ? 'Edit Jadwal' : 'Tambah Jadwal Baru',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 24),

              // Task Name Field
              TextFormField(
                controller: _taskNameController,
                decoration: InputDecoration(
                  labelText: 'Nama Tugas',
                  hintText: 'e.g., Piket Kamar A, Ngaji Juz 1',
                  prefixIcon: const Icon(Icons.task_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tugas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Selector
              Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                      }
                    },
                    selectedColor: Colors.indigo.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.indigo : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    avatar: Icon(
                      cat == 'Piket'
                          ? Icons.cleaning_services_outlined
                          : cat == 'Ngaji'
                              ? Icons.menu_book_outlined
                              : Icons.mic_outlined,
                      size: 18,
                      color: isSelected ? Colors.indigo : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Date Picker
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.indigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Member Section - Dropdown or Manual Input
              if (_isLoadingMembers)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Memuat data anggota...'),
                    ],
                  ),
                )
              else if (_members.isEmpty)
                // Manual Text Input when no members in database
                TextFormField(
                  controller: _memberNameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Petugas',
                    hintText: 'Ketik nama anggota asrama',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    helperText: 'Data anggota belum ada, silakan ketik manual',
                    helperStyle: TextStyle(color: Colors.orange[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama petugas tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _selectedMemberName = value.trim();
                    _selectedMemberId = 'manual_${DateTime.now().millisecondsSinceEpoch}';
                  },
                )
              else
                // Dropdown when members exist
                DropdownButtonFormField<String>(
                  initialValue: _selectedMemberId,
                  decoration: InputDecoration(
                    labelText: 'Pilih Anggota Asrama',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  items: _members.map((m) {
                    return DropdownMenuItem(
                      value: m['id'] as String,
                      child: Text(m['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final member = _members.firstWhere(
                      (m) => m['id'] == value,
                      orElse: () => {'id': '', 'name': ''},
                    );
                    setState(() {
                      _selectedMemberId = value;
                      _selectedMemberName = member['name'] as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pilih anggota asrama';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isEditing ? 'Simpan Perubahan' : 'Tambah Jadwal',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
