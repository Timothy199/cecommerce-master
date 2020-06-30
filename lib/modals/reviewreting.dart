class ReviewRating {
  double rating;
  String review;
  int time;
  String postedBy;

  ReviewRating({this.rating, this.review, this.time, this.postedBy});

  ReviewRating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    review = json['review'];
    time = json['time'];
    postedBy = json['postedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['time'] = this.time;
    data['postedBy'] = this.postedBy;
    return data;
  }
}

//{
//"rating": 4,
//"review": "Hello",
//"time": 123,
//"postedBy": ""
//}