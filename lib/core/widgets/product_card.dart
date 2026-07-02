import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './loading_skeleton.dart';

class ProductCard extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;
  final ValueChanged<int>? onUpdateQuantity;
  final ValueChanged<bool>? onWishlistToggle;
  final bool initialIsWishlisted;
  final int cartQuantity;
  final int? offerPercentage; 

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.onTap,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.onUpdateQuantity,
    this.onWishlistToggle,
    this.initialIsWishlisted = false,
    this.cartQuantity = 0,
    this.offerPercentage,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late bool _isWishlisted;
  late AnimationController _wishlistAnimationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.initialIsWishlisted;
    _wishlistAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _wishlistAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.initialIsWishlisted != widget.initialIsWishlisted) {
      setState(() {
        _isWishlisted = widget.initialIsWishlisted;
      });
    }
  }

  @override
  void dispose() {
    _wishlistAnimationController.dispose();
    super.dispose();
  }

  void _toggleWishlist() {
    
    
    final wasWishlisted = _isWishlisted;
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    widget.onWishlistToggle?.call(wasWishlisted);
    _wishlistAnimationController.forward().then((_) {
      _wishlistAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    
    final discountPercent = widget.offerPercentage ??
        (widget.originalPrice != null
            ? (((widget.originalPrice! - widget.price) / widget.originalPrice!) * 100).round()
            : 0);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            width: 1,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Stack(
              children: [
                Hero(
                  tag: 'product_image_${widget.id}',
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    height: 105,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const LoadingSkeleton(
                      width: double.infinity,
                      height: 105,
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 105,
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.04),
                      child: const Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),

                
                if (discountPercent > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                
                Positioned(
                  top: 6,
                  right: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: isDark
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.8),
                      child: GestureDetector(
                        onTap: _toggleWishlist,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _isWishlisted
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _isWishlisted
                                  ? theme.colorScheme.tertiary
                                  : theme.colorScheme.onSurface.withOpacity(
                                      0.6,
                                    ),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.rating.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '(${widget.reviewsCount})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.originalPrice != null)
                              Text(
                                '₹${widget.originalPrice!.toStringAsFixed(0)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.5),
                                ),
                              ),
                            Text(
                              '₹${widget.price.toStringAsFixed(0)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      
                      if (widget.cartQuantity > 0)
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(
                              0.08,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(
                                0.2,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  onTap: () {
                                    if (widget.cartQuantity == 1) {
                                      widget.onRemoveFromCart?.call();
                                    } else {
                                      widget.onUpdateQuantity?.call(
                                        widget.cartQuantity - 1,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 6.0,
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  widget.cartQuantity.toString(),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  onTap: () {
                                    widget.onUpdateQuantity?.call(
                                      widget.cartQuantity + 1,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 6.0,
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (widget.onAddToCart != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: theme.colorScheme.primary,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: widget.onAddToCart,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.add_shopping_cart_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
