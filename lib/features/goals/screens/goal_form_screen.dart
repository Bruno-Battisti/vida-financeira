import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/responsive_center.dart';
import '../models/goal.dart';
import '../providers/goals_provider.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({super.key, this.goalId});

  final String? goalId;

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  DateTime? _deadline;
  bool _saving = false;
  bool _loadingInitial = false;

  bool get _isEditing => widget.goalId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadingInitial = true;
      ref.read(goalByIdProvider(widget.goalId!).future).then((item) {
        if (!mounted) return;
        setState(() {
          _nameController.text = item.goal.name;
          _targetController.text =
              item.goal.targetAmount.toStringAsFixed(2).replaceAll('.', ',');
          _deadline = item.goal.deadline;
          _loadingInitial = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final targetAmount =
        double.parse(_targetController.text.trim().replaceAll(',', '.'));
    final repository = ref.read(goalsRepositoryProvider);

    try {
      if (_isEditing) {
        await repository.updateGoal(Goal(
          id: widget.goalId!,
          name: _nameController.text.trim(),
          targetAmount: targetAmount,
          deadline: _deadline,
        ));
      } else {
        await repository.addGoal(
          name: _nameController.text.trim(),
          targetAmount: targetAmount,
          deadline: _deadline,
        );
      }
      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar meta' : 'Nova meta')),
      body: _loadingInitial
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveCenter(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nome da meta'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe um nome.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _targetController,
                      decoration: const InputDecoration(
                          labelText: 'Valor objetivo', prefixText: 'R\$ '),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o valor objetivo.';
                        }
                        final parsed =
                            double.tryParse(value.trim().replaceAll(',', '.'));
                        if (parsed == null) {
                          return 'Valor inválido.';
                        }
                        if (parsed <= 0) {
                          return 'O valor deve ser maior que zero.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Prazo (opcional)'),
                      subtitle: Text(_deadline == null
                          ? 'Sem prazo definido'
                          : formatDate(_deadline!)),
                      trailing: _deadline == null
                          ? const Icon(Icons.calendar_today_outlined)
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: 'Remover prazo',
                              onPressed: () => setState(() => _deadline = null),
                            ),
                      onTap: _pickDeadline,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _saving ? null : _submit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _saving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
