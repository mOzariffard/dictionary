import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'models/word.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController englishController = TextEditingController();
  final TextEditingController turkishController = TextEditingController();

  Future<List<Word>> fetchWords() async {
    final allWords = await dbHelper.queryAllWords();
    return allWords.map((word) => Word.fromMap(word)).toList();
  }

  void addWord() async {
    final word = Word(
      english: englishController.text,
      turkish: turkishController.text,
    );
    await dbHelper.insertWord(word.toMap());
    setState(() {});
    englishController.clear();
    turkishController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('English-Turkish Dictionary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: englishController,
              decoration: InputDecoration(labelText: 'English'),
            ),
            TextField(
              controller: turkishController,
              decoration: InputDecoration(labelText: 'Turkish'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addWord,
              child: Text('Add Word'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Word>>(
                future: fetchWords(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final words = snapshot.data!;
                  return ListView.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return ListTile(
                        title: Text(word.english),
                        subtitle: Text(word.turkish),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
