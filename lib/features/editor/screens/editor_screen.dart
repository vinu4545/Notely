import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../core/utils/validators.dart';
import '../../../features/notes/models/note_model.dart';
import '../../../features/notes/providers/note_provider.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/glass_card.dart';

class EditorScreen extends StatefulWidget {
  final Note? note;

  const EditorScreen({super.key, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  bool _previewMode = false;
  String _category = 'Work';
  bool _isPinned = false;
  bool _isFavorite = false;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _contentController.addListener(() {
      setState(() {});
    });
    _category = widget.note?.category ?? 'Work';
    _isPinned = widget.note?.isPinned ?? false;
    _isFavorite = widget.note?.isFavorite ?? false;
    _isArchived = widget.note?.isArchived ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _category,
      isPinned: _isPinned,
      isFavorite: _isFavorite,
      isArchived: _isArchived,
      isDeleted: widget.note?.isDeleted ?? false,
      createdAt: widget.note?.createdAt,
      updatedAt: DateTime.now(),
    );

    await context.read<NoteProvider>().saveNote(note);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _togglePreview() {
    setState(() {
      _previewMode = !_previewMode;
    });
  }

  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleArchive() {
    setState(() {
      _isArchived = !_isArchived;
    });
  }

  Future<void> _showCategoryDialog(BuildContext context) async {
    final provider = context.read<NoteProvider>();
    final controller = TextEditingController();
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 32,
          ),
          child: StatefulBuilder(
            builder: (_, setDialogState) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(17, 19, 24, 0.12),
                      blurRadius: 24,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Manage categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Choose a category or add your own.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceWhite,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: controller,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Add category',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              final newCategory = controller.text.trim();
                              if (newCategory.isEmpty) return;
                              await provider.addCategory(newCategory);
                              controller.clear();
                              setDialogState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Add category'),
                          ),
                          const SizedBox(height: 18),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 280),
                            child: SingleChildScrollView(
                              child: Column(
                                children: provider.availableCategories.map((
                                  category,
                                ) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceWhite,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () => Navigator.of(
                                        dialogContext,
                                      ).pop(category),
                                      title: Text(
                                        category,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          await provider.removeCategory(
                                            category,
                                          );
                                          if (_category == category) {
                                            setState(() {
                                              _category =
                                                  provider
                                                      .availableCategories
                                                      .isNotEmpty
                                                  ? provider
                                                        .availableCategories
                                                        .first
                                                  : NoteProvider
                                                        .defaultCategories
                                                        .first;
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text(
                              'Close',
                              style: TextStyle(color: AppColors.primaryPink),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (selected != null) {
      setState(() {
        _category = selected;
      });
    }
  }

  int _getWordCount() {
    if (_contentController.text.isEmpty) return 0;
    return _contentController.text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  int _getCharacterCount() {
    return _contentController.text.length;
  }

  int _getReadingTime() {
    final wordCount = _getWordCount();
    return (wordCount / 180).ceil().clamp(1, 999);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.xl,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.06),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Capture your next idea',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Markdown support, live preview, stats, and smooth interaction.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          validator: Validators.validateTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: 'Start with a memorable headline',
                          ),
                        ),
                        const SizedBox(height: 18),
                        GestureDetector(
                          onTap: () => _showCategoryDialog(context),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: AppColors.surfaceWhite,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _togglePreview,
                                icon: Icon(
                                  _previewMode ? Icons.edit : Icons.visibility,
                                ),
                                label: Text(_previewMode ? 'Edit' : 'Preview'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.pill,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton.outlined(
                              onPressed: _togglePin,
                              icon: Icon(
                                _isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                              ),
                              tooltip: _isPinned ? 'Unpin note' : 'Pin note',
                            ),
                            IconButton.outlined(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                              ),
                              tooltip: _isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                            ),
                            IconButton.outlined(
                              onPressed: _toggleArchive,
                              icon: Icon(
                                _isArchived
                                    ? Icons.unarchive
                                    : Icons.archive_outlined,
                              ),
                              tooltip: _isArchived
                                  ? 'Unarchive note'
                                  : 'Archive note',
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 340,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.lg,
                          ),
                          child: _previewMode
                              ? MarkdownBody(
                                  data: _contentController.text.isEmpty
                                      ? 'Nothing to preview yet. Start typing to see your note come alive.'
                                      : _contentController.text,
                                )
                              : TextFormField(
                                  controller: _contentController,
                                  maxLines: null,
                                  minLines: 10,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Write your note here. Use markdown formatting and checklists.',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _EditorBadge(label: 'Words', value: '${_getWordCount()}'),
                      _EditorBadge(
                        label: 'Characters',
                        value: '${_getCharacterCount()}',
                      ),
                      _EditorBadge(
                        label: 'Read',
                        value: '${_getReadingTime()} min',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GradientButton(
                    title: widget.note == null ? 'Save note' : 'Update note',
                    onPressed: _saveNote,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      if (widget.note != null) {
                        context.read<NoteProvider>().deleteNote(widget.note!);
                      }
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.pill,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorBadge extends StatelessWidget {
  final String label;
  final String value;

  const _EditorBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
