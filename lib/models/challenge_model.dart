import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String creatorId;
  final String title;
  final List<String> tasks;
  final List<String> participants;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final Map<String, dynamic> progress;
  final List<String> invitations;

  Challenge({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.tasks,
    required this.participants,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.progress,
    this.invitations = const [],
  });

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Challenge(
      id: doc.id,
      creatorId: data['creatorId'],
      title: data['title'],
      tasks: List<String>.from(data['tasks']),
      participants: List<String>.from(data['participants']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'],
      progress: data['progress'],
      invitations: List<String>.from(data['invitations'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatorId': creatorId,
      'title': title,
      'tasks': tasks,
      'participants': participants,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'progress': progress,
      'invitations': invitations,
    };
  }
}