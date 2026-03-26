import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'quiz_provider.dart';
import 'widgets/quiz_question_view.dart';
import 'widgets/quiz_result_view.dart';

class QuizPlayScreen extends ConsumerWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizNotifierProvider);
    
    if (quizState.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('問題がありません')),
      );
    }

    return Stack(
      children: [
        if (quizState.isCompleted)
          QuizResultView(quizState: quizState)
        else
          QuizQuestionView(quizState: quizState),
        
        if (quizState.isSaving)
          Positioned.fill(
            child: Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
