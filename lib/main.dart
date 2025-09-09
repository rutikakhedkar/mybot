import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Gemini Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'AI Diet Suggestion'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String dietPlan = "Enter your details to get a diet suggestion.";

  Future<void> getDietPlan() async {
    const apiKey = "AIzaSyAsB-wtAiAlppH7p-nnZ_zPUdWIf9TrBLU"; // 🔑 Replace with your Gemini API key
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final height = heightController.text;
    final weight = weightController.text;
    final age = ageController.text;

    final prompt =
        "I am $age years old, my height is $height cm and my weight is $weight kg. "
        "Suggest me a healthy diet plan in simple steps.";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      setState(() {
        dietPlan = response.text ?? "No response from Gemini.";
      });
    } catch (e) {
      setState(() {
        dietPlan = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: heightController,
              decoration: const InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getDietPlan,
              child: const Text("Get Diet Plan"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(dietPlan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
