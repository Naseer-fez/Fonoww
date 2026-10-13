/// Quote Model Class
/// Demonstrates:
/// - Parsing REST API JSON responses into strongly-typed Dart objects
/// - Factory constructors for JSON deserialization
/// - Fallback defaults for network resiliency
class Quote {
  final int id;
  final String quote;
  final String author;

  const Quote({
    required this.id,
    required this.quote,
    required this.author,
  });

  /// Factory constructor to parse JSON from https://dummyjson.com/quotes/random
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as int? ?? 1,
      quote: json['quote'] as String? ?? 'Keep coding and learning every single day.',
      author: json['author'] as String? ?? 'Campus Buddy',
    );
  }

  /// Default fallback quote for offline or error situations
  static const Quote fallback = Quote(
    id: 0,
    quote: "Success is the sum of small efforts, repeated day in and day out.",
    author: "Robert Collier",
  );
}
