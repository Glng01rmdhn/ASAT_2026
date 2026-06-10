class Car {
  final int id;
  final String brand;
  final String model;
  final String color;
  final int year;
  final String price;
  final bool isAvailable;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.year,
    required this.price,
    required this.isAvailable,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] ?? 0,
      brand: json['car'] ?? 'Unknown',
      model: json['car_model'] ?? '',
      color: json['car_color'] ?? 'N/A',
      year: json['car_model_year'] ?? 0,
      price: json['price'] ?? '\$0.00',
      isAvailable: json['availability'] ?? false, 
    );
  }
}