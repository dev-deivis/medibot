import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  final String id;
  final String name;
  final String genericName;
  final String brand;
  final String dosage;
  final String form; // tablet, capsule, liquid, injection, etc.
  final String? description;
  final List<String> activeIngredients;

  const Medication({
    required this.id,
    required this.name,
    required this.genericName,
    required this.brand,
    required this.dosage,
    required this.form,
    this.description,
    this.activeIngredients = const [],
  });

  factory Medication.fromMap(Map<String, dynamic> map, String id) {
    return Medication(
      id: id,
      name: map['name'] as String? ?? '',
      genericName: map['genericName'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      dosage: map['dosage'] as String? ?? '',
      form: map['form'] as String? ?? '',
      description: map['description'] as String?,
      activeIngredients: List<String>.from(map['activeIngredients'] ?? []),
    );
  }

  factory Medication.fromFirestore(DocumentSnapshot doc) {
    return Medication.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'genericName': genericName,
      'brand': brand,
      'dosage': dosage,
      'form': form,
      'description': description,
      'activeIngredients': activeIngredients,
    };
  }
}
