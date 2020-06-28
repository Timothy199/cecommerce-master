class BookModel {
  String title;
  String isbn;
  String description;
  String uid;
  List<String> urls;
  double price;

  BookModel(
      {this.title,
        this.isbn,
        this.description,
        this.uid,
        this.urls,
        this.price});

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isbn = json['isbn'];
    description = json['description'];
    uid = json['uid'];
    urls = json['urls'].cast<String>();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isbn'] = this.isbn;
    data['description'] = this.description;
    data['uid'] = this.uid;
    data['urls'] = this.urls;
    data['price'] = this.price;
    return data;
  }
}