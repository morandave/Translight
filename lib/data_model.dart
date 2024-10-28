
// 数据类
class CollectionListData {
  String imageurl;
  String name;
  String category;
  String period;
  String existingLocation;
  String dimension;
  String introduction;
  String origin;
  double dist;
  double rating;
  int reviews;
  int perNight;

  CollectionListData({
    this.imageurl = '',
    this.name = '',
    this.category = "",
    this.period = "",
    this.existingLocation = '',
    this.dimension = '',
    this.introduction = '',
    this.origin = '',
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'imageurl': imageurl,
      'name': name,
      'category': category,
      'period': period,
      'existingLocation': existingLocation,
      'dimension': dimension,
      'introduction': introduction,
      'origin': origin,
      'dist': dist,
      'rating': rating,
      'reviews': reviews,
      'perNight': perNight,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'CollectionListData{imageurl: $imageurl, category: $category, period: $period, existingLocation: $existingLocation, dimension: $dimension, introduction: $introduction, origin: $origin, dist: $dist, rating: $rating, reviews: $reviews, perNight: $perNight}';
  }
}

