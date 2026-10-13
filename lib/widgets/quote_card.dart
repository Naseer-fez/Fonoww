import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import '../theme/app_theme.dart';

/// QuoteCard displays an inspiring daily quote fetched from the REST API.
/// Demonstrates:
/// - REST API integration in UI
/// - Async data fetching with FutureBuilder & stateful refresh
/// - Graceful loading and error states
/// - Restrained Material 3 styling with soft pastel touches
class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  final QuoteService _quoteService = QuoteService();
  late Future<Quote> _quoteFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _quoteFuture = _quoteService.fetchQuote();
  }

  void _refreshQuote() {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
      _quoteFuture = _quoteService.fetchQuote(forceRefresh: true).whenComplete(() {
        if (mounted) {
          setState(() {
            _isRefreshing = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF292C42)
              : const Color(0xFFE8EAF2).withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF1E2038).withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<Quote>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          final quote = snapshot.data ?? Quote.fallback;
          final isLoading = snapshot.connectionState == ConnectionState.waiting && !_isRefreshing;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Label & Refresh Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withOpacity(isDark ? 0.25 : 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.format_quote_rounded,
                          size: 16,
                          color: AppTheme.primaryAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'QUOTE OF THE DAY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark
                              ? const Color(0xFF969AB0)
                              : const Color(0xFF85899B),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: _isRefreshing ? null : _refreshQuote,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: _isRefreshing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryAccent,
                              ),
                            )
                          : Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: isDark
                                  ? const Color(0xFF969AB0)
                                  : const Color(0xFF85899B),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quote Body
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryAccent,
                      ),
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${quote.quote}"',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? const Color(0xFFE5E7EB)
                            : const Color(0xFF2E3146),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "— ${quote.author}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppTheme.primaryDarkAccent
                              : AppTheme.primaryAccent,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
