import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationPrice {
  final String medicationId;
  final String medicationName;
  final double price;
  final bool inStock;
  final DateTime updatedAt;

  const MedicationPrice({
    required this.medicationId,
    required this.medicationName,
    required this.price,
    required this.inStock,
    required this.updatedAt,
  });

  factory MedicationPrice.fromMap(Map<String, dynamic> map) {
    return MedicationPrice(
      medicationId: map['medicationId'] as String? ?? '',
      medicationName: map['medicationName'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      inStock: map['inStock'] as bool? ?? false,
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicationId': medicationId,
      'medicationName': medicationName,
      'price': price,
      'inStock': inStock,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final bool isOpen;
  final double? distance; // calculated client-side in km
  final List<MedicationPrice> prices;

  const Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.isOpen = true,
    this.distance,
    this.prices = const [],
  });

  factory Pharmacy.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    final pricesList = (map['prices'] as List<dynamic>? ?? [])
        .map((p) => MedicationPrice.fromMap(p as Map<String, dynamic>))
        .toList();

    return Pharmacy(
      id: doc.id,
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: map['phone'] as String?,
      isOpen: map['isOpen'] as bool? ?? true,
      prices: pricesList,
    );
  }

  Pharmacy copyWith({double? distance}) {
    return Pharmacy(
      id: id,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      phone: phone,
      isOpen: isOpen,
      distance: distance ?? this.distance,
      prices: prices,
    );
  }
}
