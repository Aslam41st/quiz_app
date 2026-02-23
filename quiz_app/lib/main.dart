import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home: QuestionPage(questionIndex: 0),
    );
  }
}

// Store answers globally
List<int?> selectedAnswers = [null, null, null];
int bestScore = 0;

// Questions & options
List<String> questions = [
  "What is Flutter?",
  "Which language does Flutter use?",
  "Which widget is used for layouts?"
];

List<List<String>> options = [
  ["Programming Language", "UI Framework", "Database", "Server"],
  ["Java", "Kotlin", "Dart", "Swift"],
  ["Scaffold", "Column", "Text", "Icon"]
];

// Correct answers index
List<int> correctAnswers = [1, 2, 1];

class QuestionPage extends StatefulWidget {
  final int questionIndex;

  const QuestionPage({super.key, required this.questionIndex});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = selectedAnswers[widget.questionIndex];
  }

  void nextPage() {
    selectedAnswers[widget.questionIndex] = selectedOption;

    if (widget.questionIndex < 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuestionPage(questionIndex: widget.questionIndex + 1),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultPage()),
      );
    }
  }

  void previousPage() {
    selectedAnswers[widget.questionIndex] = selectedOption;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${widget.questionIndex + 1}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              questions[widget.questionIndex],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ...List.generate(options[widget.questionIndex].length, (index) {
              return RadioListTile<int>(
                title: Text(options[widget.questionIndex][index]),
                value: index,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              );
            }),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.questionIndex > 0)
                  ElevatedButton(
                    onPressed: previousPage,
                    child: const Text("Back"),
                  ),
                ElevatedButton(
                  onPressed: nextPage,
                  child: Text(widget.questionIndex == 2 ? "Submit" : "Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < 3; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        score++;
      }
    }

    if (score > bestScore) {
      bestScore = score;
    }

    return score;
  }

  @override
  Widget build(BuildContext context) {
    int score = calculateScore();

    return Scaffold(
      appBar: AppBar(
        title: Text("Best Score: $bestScore"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              "$score / 3",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                selectedAnswers = [null, null, null];
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const QuestionPage(questionIndex: 0)),
                  (route) => false,
                );
              },
              child: const Text("Restart Quiz"),
            )
          ],
        ),
      ),
    );
  }
}