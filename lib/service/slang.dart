import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SlangProvider {
  static final SlangProvider _instance = SlangProvider._internal();
  factory SlangProvider() => _instance;

  List<String> _slangs = [];
  bool _isLoading = true;

  SlangProvider._internal();

  Future<void> fetchSlangs() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Slangs').get();
      var documents = snapshot.docs;
      _slangs = documents
          .map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['value'] as String?;
          })
          .where((slang) => slang != null)
          .cast<String>()
          .toList();
      _isLoading = false;
    } catch (e) {
      print('Error fetching slangs: $e');
      _isLoading = false;
    }
  }

  String getRandomSlang() {
    if (_slangs.isNotEmpty) {
      return _slangs[Random().nextInt(_slangs.length)];
    }
    return 'No slangs available';
  }

  bool get isLoading => _isLoading;
}
