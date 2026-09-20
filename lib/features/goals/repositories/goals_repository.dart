import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goal.dart';
import '../models/goal_progress.dart';
import '../models/goal_transaction.dart';

class GoalsRepository {
  GoalsRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _goalsCollection =>
      _firestore.collection('users').doc(_uid).collection('goals');

  CollectionReference<Map<String, dynamic>> get _entriesCollection =>
      _firestore.collection('users').doc(_uid).collection('goalEntries');

  /// Firestore não faz join/agregação como o Drift, então os dois streams
  /// (metas e aportes) são combinados manualmente: cada um reemite a lista
  /// combinada sempre que qualquer um dos dois mudar. O primeiro valor só
  /// sai depois que AMBOS já entregaram seu snapshot inicial — do contrário
  /// o primeiro a chegar emitiria com o outro ainda vazio (currentAmount 0).
  Stream<List<GoalProgress>> watchAllWithProgress() {
    late StreamController<List<GoalProgress>> controller;
    var latestGoals = <Goal>[];
    var latestEntries = <GoalTransaction>[];
    var goalsReady = false;
    var entriesReady = false;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? goalsSub;
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? entriesSub;

    void emit() {
      if (!goalsReady || !entriesReady) return;
      if (!controller.isClosed) {
        controller.add(_combine(latestGoals, latestEntries));
      }
    }

    controller = StreamController<List<GoalProgress>>.broadcast(
      onListen: () {
        goalsSub = _goalsCollection.snapshots().listen((snapshot) {
          latestGoals = snapshot.docs.map(_goalFromDoc).toList();
          goalsReady = true;
          emit();
        });
        entriesSub = _entriesCollection.snapshots().listen((snapshot) {
          latestEntries = snapshot.docs.map(_entryFromDoc).toList();
          entriesReady = true;
          emit();
        });
      },
      onCancel: () {
        goalsSub?.cancel();
        entriesSub?.cancel();
      },
    );

    return controller.stream;
  }

  Stream<List<GoalTransaction>> watchEntries(String goalId) {
    return _entriesCollection.where('goalId', isEqualTo: goalId).snapshots().map((snapshot) {
      final entries = snapshot.docs.map(_entryFromDoc).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return entries;
    });
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) {
    return _goalsCollection.add({
      'name': name,
      'targetAmount': targetAmount,
      'deadline': deadline == null ? null : Timestamp.fromDate(deadline),
    });
  }

  Future<void> updateGoal(Goal goal) {
    return _goalsCollection.doc(goal.id).update({
      'name': goal.name,
      'targetAmount': goal.targetAmount,
      'deadline': goal.deadline == null ? null : Timestamp.fromDate(goal.deadline!),
    });
  }

  Future<void> removeGoal(String id) async {
    final batch = _firestore.batch();
    final entriesSnapshot = await _entriesCollection.where('goalId', isEqualTo: id).get();
    for (final doc in entriesSnapshot.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_goalsCollection.doc(id));
    await batch.commit();
  }

  Future<void> addContribution({
    required String goalId,
    required double amount,
    DateTime? date,
  }) {
    return _entriesCollection.add({
      'goalId': goalId,
      'amount': amount,
      'date': Timestamp.fromDate(date ?? DateTime.now()),
    });
  }

  List<GoalProgress> _combine(List<Goal> goals, List<GoalTransaction> entries) {
    final items = goals.map((goal) {
      final currentAmount = entries
          .where((e) => e.goalId == goal.id)
          .fold(0.0, (total, e) => total + e.amount);
      return (
        goal: goal,
        currentAmount: currentAmount,
        progress: computeGoalProgress(currentAmount, goal.targetAmount),
      );
    }).toList();
    items.sort((a, b) => a.goal.id.compareTo(b.goal.id));
    return items;
  }

  Goal _goalFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Goal(
      id: doc.id,
      name: data['name'] as String,
      targetAmount: (data['targetAmount'] as num).toDouble(),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
    );
  }

  GoalTransaction _entryFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return GoalTransaction(
      id: doc.id,
      goalId: data['goalId'] as String,
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
