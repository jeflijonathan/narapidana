import 'package:firebase_database/firebase_database.dart';
import '../models/narapidana_model.dart';

class NarapidanaService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("narapidana");

  Future<void> tambahData(Narapidana data) async {
    await _db.push().set(data.toMap());
  }

  // Stream<List<Narapidana>> getData() {
  //   return _db.onValue.map((event) {
  //     final data = event.snapshot.value as Map?;
  //     if (data == null) return [];

  //     List<Narapidana> list = [];
  //     data.forEach((key, value) {
  //       // Abaikan data jika bentuknya rusaknya (ex: value cuma berisi tulisan String)
  //       if (value is Map) {
  //         list.add(Narapidana.fromMap(key.toString(), Map<String, dynamic>.from(value)));
  //       }
  //     });
  //     return list;
  //   });
  // }
  Stream<List<Narapidana>> getData() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      if (data == null) return [];

      return data.entries.map((e) {
        return Narapidana.fromMap(e.key, Map<String, dynamic>.from(e.value));
      }).toList();
    });
  }
}
