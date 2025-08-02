import 'package:flutter/material.dart';
import 'service_review_item.dart';
import '../../../services/services_api_service.dart';
import '../../../models/service_model.dart';

class ServiceReviewsSection extends StatefulWidget {
  final List<dynamic>? reviews;
  final String serviceId;
  final String cityName;
  final Function(String name, int rating, String comment)? onReviewAdded;

  const ServiceReviewsSection({
    super.key,
    required this.reviews,
    required this.serviceId,
    required this.cityName,
    this.onReviewAdded,
  });

  @override
  State<ServiceReviewsSection> createState() => _ServiceReviewsSectionState();
}

class _ServiceReviewsSectionState extends State<ServiceReviewsSection>
    with SingleTickerProviderStateMixin {
  List<ServiceReview> _localReviews = [];
  bool _showAddReviewForm = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  final ServicesApiService _apiService = ServicesApiService();

  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _loadReviews();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reviews = await _apiService.getReviews(
        widget.serviceId,
        cityName: widget.cityName,
      );
      setState(() {
        _localReviews = reviews;
      });
    } catch (e) {
      print('Sharhlarni yuklashda xatolik: $e');
      if (widget.reviews != null) {
        setState(() {
          _localReviews = widget.reviews!.map((review) {
            return ServiceReview(
              name: review['name'] ?? 'Anonim',
              rating: review['rating'] ?? 0,
              comment: review['comment'] ?? '',
              date: review['date'] ?? DateTime.now().toString(),
            );
          }).toList();
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addReview(String name, int rating, String comment) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final review = ServiceReview(
        name: name,
        rating: rating,
        comment: comment,
        date: DateTime.now().toIso8601String(),
      );

      final success = await _apiService.addReview(
        widget.serviceId,
        review,
        cityName: widget.cityName,
      );

      if (success) {
        final newReview = ServiceReview(
          name: name,
          rating: rating,
          comment: comment,
          date: DateTime.now().toIso8601String(),
        );

        setState(() {
          _localReviews.add(newReview);
        });

        if (widget.onReviewAdded != null) {
          widget.onReviewAdded!(name, rating, comment);
        }

        setState(() {
          _showAddReviewForm = false;
          _nameController.clear();
          _commentController.clear();
          _selectedRating = 5;
        });
        _animationController.reverse();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sharh muvaffaqiyatli qo\'shildi!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Sharh qo\'shish muvaffaqiyatsiz');
      }
    } catch (e) {
      print('Sharh qo\'shishda xatolik: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xatolik: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleReviewForm() {
    setState(() {
      _showAddReviewForm = !_showAddReviewForm;
    });

    if (_showAddReviewForm) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Widget _buildStarSelector() {
    return Row(
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = index + 1;
            });
          },
          child: Icon(
            index < _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 28,
          ),
        );
      }),
    );
  }

  Widget _buildReviewForm() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 50),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sharh qoldiring',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleReviewForm,
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Поле имени
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Ismingiz',
                      hintText: 'Ismingizni kiriting',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Baho bering:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStarSelector(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Sharhingiz',
                      hintText: 'Sharhingizni yozing...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_nameController.text.isNotEmpty &&
                                      _commentController.text.isNotEmpty) {
                                    _addReview(
                                      _nameController.text,
                                      _selectedRating,
                                      _commentController.text,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Jonatish'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _toggleReviewForm,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Bekor qilish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.rate_review,
                    color: Colors.orange,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Sharhlar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add_comment,
                    color: Colors.teal,
                    size: 12,
                  ),
                ),
                TextButton(
                  onPressed: _toggleReviewForm,
                  child: Text(
                    _showAddReviewForm ? 'Yashirish' : 'Sharh qoldirish',
                    style: const TextStyle(color: Colors.teal, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_showAddReviewForm) _buildReviewForm(),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: Colors.teal),
                )
              else if (_localReviews.isNotEmpty)
                ..._localReviews.map<Widget>((review) {
                  int index = _localReviews.indexOf(review);
                  return Column(
                    children: [
                      if (index > 0) const Divider(height: 16),
                      ServiceReviewItem(
                        name: review.name,
                        rating: review.rating,
                        comment: review.comment,
                      ),
                    ],
                  );
                })
              else
                const Text(
                  'Hozircha sharhlar yo\'q',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
