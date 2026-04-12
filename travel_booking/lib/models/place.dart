class Place {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String image;
  final int price;
  List<String> reviews;

  Place({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.image,
    required this.price,
    this.reviews = const [],
  });
}