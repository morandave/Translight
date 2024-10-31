// 数据类
class Collection {
  int id;
  String image;
  String name;
  String category;
  String period;
  String existingLocation;
  String dimensions;
  String introduction;
  String collectionSource;
  String artist;
  double dist;
  double rating;
  int reviews;
  int perNight;

  Collection({
    this.id = 0,
    this.image = '',
    this.name = '',
    this.category = "",
    this.period = "",
    this.existingLocation = '',
    this.dimensions = '',
    this.introduction = '',
    this.artist = '',
    this.collectionSource = '',
    this.dist = 1.8,
    this.reviews = 80,
    this.rating = 4.5,
    this.perNight = 180,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'category': category,
      'period': period,
      'existingLocation': existingLocation,
      'dimensions': dimensions,
      'introduction': introduction,
      'artist': artist,
      'collectionSource': collectionSource,
      // 'dist': dist,
      // 'rating': rating,
      // 'reviews': reviews,
      // 'perNight': perNight,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Collection{id: $id, image: $image, name: $name, category: $category, period: $period, existingLocation: $existingLocation, dimensions: $dimensions, introduction: $introduction, artist: $artist, collectionSource: $collectionSource, dist: $dist, rating: $rating, reviews: $reviews, perNight: $perNight}';
  }
}
