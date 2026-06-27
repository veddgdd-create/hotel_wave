class Review {
  String? name;
  double? rate;
  String? comment;

  Review({this.name, this.rate, this.comment});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        name: json['name'] as String?,
        rate: json['rate'] as double?,
        comment: json['comment'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'rate': rate,
        'comment': comment,
      };
}
