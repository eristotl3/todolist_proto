import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/todo_list_model.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/due_date_picker_widget.dart';

class CreateListScreen extends ConsumerStatefulWidget {
  final String classId;
  final TodoListModel? initialList;

  const CreateListScreen({super.key, required this.classId, this.initialList});

  @override
  ConsumerState<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends ConsumerState<CreateListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  bool _isLoading = false;

  bool get _isEditing => widget.initialList != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.initialList!.title;
      _descController.text = widget.initialList!.description ?? '';
      _dueDate = widget.initialList!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (_isEditing) {
        await ref
            .read(todoListNotifierProvider(widget.classId).notifier)
            .editList(
              listId: widget.initialList!.id,
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              dueDate: _dueDate,
            );
        if (mounted) Navigator.pop(context);
      } else {
        final newList = await ref
            .read(todoListNotifierProvider(widget.classId).notifier)
            .createList(
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              dueDate: _dueDate,
            );
        if (mounted) Navigator.pop(context, newList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit List' : 'New Todo List')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. Chapter 5 Reading',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter a title'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Add instructions or notes...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    Text('Due date',
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    DueDatePickerWidget(
                      selectedDate: _dueDate,
                      onChanged: (d) => setState(() => _dueDate = d),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Save Changes' : 'Create List'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
