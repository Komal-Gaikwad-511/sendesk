class Product {
  String id;
  String name;
  String description;
  double price;
  double mrp_price;
  String image = '';
  int code;
  // Map<String,dynamic> highlights={
  //  "model_number":
  //}
  Product(
    this.id,
    this.name,
    this.description,
    this.price,
    this.mrp_price,
    this.image,
    this.code,
  );

  factory Product.fromMap(Map snapshot, String id) => new Product(
        snapshot["id"],
        snapshot["name"],
        snapshot["description"],
        snapshot["price"],
        snapshot["mrp_price"],
        snapshot["image"],
        snapshot["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "mrp_price": mrp_price,
        "image": image,
        "code": code,
      };
}
