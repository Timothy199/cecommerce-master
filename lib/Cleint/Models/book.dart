class BookModel {
  String title;
  String isbn;
  String description;
  String uid;
  List<String> urls;
  double price;
  double avarageRating;
  int views;

  BookModel(
      {this.title,
        this.isbn,
        this.description,
        this.uid,
        this.avarageRating,
        this.views,
        this.urls,
        this.price});

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isbn = json['isbn'];
    description = json['description'];
    views = json['views'];
    avarageRating = json['rating'];
    uid = json['uid'];
    urls = json['urls'].cast<String>();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isbn'] = this.isbn;
    data['views']=this.views;
    data['rating'] = this.avarageRating;
    data['description'] = this.description;
    data['uid'] = this.uid;
    data['urls'] = this.urls;
    data['price'] = this.price;
    return data;
  }
}

// Adding views and average rating;