import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/todo_item_model.dart';
import '../providers/todo_list_provider.dart';
import '../widgets/due_date_picker_widget.dart';

class CreateItemScreen extends ConsumerStatefulWidget {
  final String listId;
  final TodoItemModel? initialItem;

  const CreateItemScreen({super.key, required this.listId, this.initialItem});

  @override
  ConsumerState<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends ConsumerState<CreateItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  bool _isLoading = false;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.initialItem!.title;
      _descController.text = widget.initialItem!.description ?? '';
      _dueDate = widget.initialItem!.dueDate;
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
            .read(todoItemNotifierProvider(widget.listId).notifier)
            .editItem(
              itemId: widget.initialItem!.id,
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              dueDate: _dueDate,
            );
        if (mounted) Navigator.pop(context);
      } else {
        await ref
            .read(todoItemNotifierProvider(widget.listId).notifier)
            .createItem(
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              dueDate: _dueDate,
            );
        if (mounted) Navigator.pop(context);
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
      appBar: AppBar(title: Text(_isEditing ? 'Edit Item' : 'Add Item')),
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
                        labelText: 'Task',
                        hintText: 'e.g. Read pages 45–60',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter a task'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: 16),
                    Text('Due date (optional)',
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
                          : Text(_isEditing ? 'Save Changes' : 'Add Item'),
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
