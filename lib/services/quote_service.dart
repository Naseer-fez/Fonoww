import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

/// QuoteService handles fetching motivational quotes from the public API.
/// Demonstrates:
/// - Real REST API integration using the `http` package
/// - Asynchronous programming with async/await and Futures
/// - JSON parsing and validation
/// - In-memory caching to prevent repeated network requests on tab switches
/// - Graceful error handling and offline fallback
class QuoteService {
  static final QuoteService _instance = QuoteService._internal();
  factory QuoteService() => _instance;
  QuoteService._internal();

  static const String _quoteEndpoint = 'https://dummyjson.com/quotes/random';

  // In-memory cache for current session
  Quote? _cachedQuote;

  Quote? get cachedQuote => _cachedQuote;

  /// Fetches a random quote from dummyjson.com
  /// If forceRefresh is false and a cached quote exists, returns the cache.
  Future<Quote> fetchQuote({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedQuote != null) {
      return _cachedQuote!;
    }

    try {
      final response = await http
          .get(Uri.parse(_quoteEndpoint))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final quote = Quote.fromJson(data);
        _cachedQuote = quote;
        return quote;
      } else {
        // Fallback on non-200 HTTP status
        return _cachedQuote ?? Quote.fallback;
      }
    } on TimeoutException {
      print('Quote request timed out, using fallback');
      return _cachedQuote ?? Quote.fallback;
    } catch (e) {
      print('Network error fetching quote: $e, using fallback');
      return _cachedQuote ?? Quote.fallback;
    }
  }
}
