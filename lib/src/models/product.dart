class Product {
    final int id;
    final String name;
    final String image_url;
    final String brand_name;
    final int price;
    final double rating;

  Product({this.id, this.name, this.image_url, this.brand_name, this.price, this.rating});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      image_url: json['image_url'] as String,
      brand_name: json['brand_name'] as String,
      price: json['price'] as int,
      rating: json['rating'] as double,
    );
  }
}