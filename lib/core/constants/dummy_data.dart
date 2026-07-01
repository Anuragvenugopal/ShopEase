import 'package:flutter/material.dart';

class DummyCategory {
  final String id;
  final String title;
  final String imageUrl;

  const DummyCategory({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
}

class DummyProduct {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String category;
  final String sku;
  final String barcode;
  int stock;
  int quantity; // helper for cart

  DummyProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.category,
    required this.sku,
    required this.barcode,
    required this.stock,
    this.quantity = 1,
  });
}

class DummyData {
  DummyData._();

  // In-memory collections to support real-time state changes during testing
  static final List<DummyCategory> categories = [
    const DummyCategory(
      id: 'cat1',
      title: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat2',
      title: 'Electronics',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat3',
      title: 'Home Decor',
      imageUrl: 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat4',
      title: 'Beauty',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat5',
      title: 'Sports',
      imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=200&q=80',
    ),
  ];

  static final List<DummyProduct> products = [
    DummyProduct(
      id: 'p1',
      title: 'Wireless Noise-Cancelling Headphones',
      description: 'Experience pure sonic bliss with our state-of-the-art wireless headphones. Featuring hybrid active noise cancellation, ambient awareness modes, and an impressive 40-hour battery life. Designed with memory foam cushions for supreme comfort during extended listening sessions.',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
      price: 199.99,
      originalPrice: 249.99,
      rating: 4.8,
      reviewsCount: 142,
      category: 'Electronics',
      sku: 'ELE-HP-092',
      barcode: '880942351221',
      stock: 12,
    ),
    DummyProduct(
      id: 'p2',
      title: 'Premium Handcrafted Leather Jacket',
      description: 'Timeless style meets rugged durability. Tailored from 100% full-grain cowhide leather, this jacket features premium YKK zippers, a soft breathable inner lining, and four zipper pockets. Matures beautifully with age, developing a unique vintage patina.',
      imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=600&q=80',
      price: 129.50,
      originalPrice: 180.00,
      rating: 4.7,
      reviewsCount: 88,
      category: 'Fashion',
      sku: 'FAS-LJ-381',
      barcode: '712950381042',
      stock: 4, // Low stock category
    ),
    DummyProduct(
      id: 'p3',
      title: 'Minimalist Matte Ceramic Vase',
      description: 'Enrich your home space with this classic textured vase. Handcrafted by local artisans from premium earthenware clay, it sports a matte white surface that complements modern, brutalist, and Scandinavian interior spaces.',
      imageUrl: 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?auto=format&fit=crop&w=600&q=80',
      price: 34.00,
      rating: 4.3,
      reviewsCount: 29,
      category: 'Home Decor',
      sku: 'HOM-VS-041',
      barcode: '634000411293',
      stock: 35,
    ),
    DummyProduct(
      id: 'p4',
      title: 'Smart Fitness Sports Watch GPS',
      description: 'Your ultimate wellness tracker. Monitor heart rates, active sleep stages, blood oxygen, and outdoor routes with precise built-in GPS. Featuring a vibrant 1.4-inch AMOLED display, water resistance up to 50 meters, and a 14-day battery run.',
      imageUrl: 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?auto=format&fit=crop&w=600&q=80',
      price: 89.00,
      originalPrice: 119.99,
      rating: 4.5,
      reviewsCount: 215,
      category: 'Electronics',
      sku: 'ELE-SW-512',
      barcode: '889000512192',
      stock: 2, // Low stock
    ),
    DummyProduct(
      id: 'p5',
      title: 'Hydrating Face Serum with Niacinamide',
      description: 'Restore your natural radiant glow. Formulated with 10% pure Niacinamide and 2% Hyaluronic acid to deeply hydrate, minimize pores, and smooth uneven textures. 100% vegan, cruelty-free, and suitable for all sensitive skin profiles.',
      imageUrl: 'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?auto=format&fit=crop&w=600&q=80',
      price: 28.00,
      rating: 4.6,
      reviewsCount: 74,
      category: 'Beauty',
      sku: 'BEU-FS-742',
      barcode: '528000742118',
      stock: 50,
    ),
    DummyProduct(
      id: 'p6',
      title: 'Professional Graphite Tennis Racket',
      description: 'Dominate the court with unmatched power and control. Constructed with lightweight carbon graphite composites, this racket offers a wide sweet spot, shock-absorbent frames, and a tacky grip handle for maximum comfort.',
      imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=600&q=80',
      price: 145.00,
      rating: 4.4,
      reviewsCount: 38,
      category: 'Sports',
      sku: 'SPO-TR-182',
      barcode: '914500182471',
      stock: 18,
    ),
    DummyProduct(
      id: 'p7',
      title: 'Classic Heavyweight Cotton Hoodie',
      description: 'Comfort has a new name. Tailored from a premium 400GSM cotton fleece blend, featuring double-stitch seams, a spacious kangaroo pouch, and structured drawstrings. Ideal for cozy loungewear or cold outdoor commutes.',
      imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=600&q=80',
      price: 45.00,
      rating: 4.7,
      reviewsCount: 96,
      category: 'Fashion',
      sku: 'FAS-HD-091',
      barcode: '745000091880',
      stock: 3, // Low stock
    ),
    DummyProduct(
      id: 'p8',
      title: '34" Curved Ultra-Wide Gaming Monitor',
      description: 'Immerse yourself completely in the action. Boasting a QHD resolution, 165Hz refresh rate, 1ms response latency, and AMD FreeSync Premium integration. The 1500R curved display conforms to human visual profiles, reducing eye strains.',
      imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=600&q=80',
      price: 349.99,
      originalPrice: 399.99,
      rating: 4.9,
      reviewsCount: 63,
      category: 'Electronics',
      sku: 'ELE-GM-831',
      barcode: '883499831994',
      stock: 8,
    ),
  ];

  static final List<DummyProduct> cart = [];
  static final List<DummyProduct> wishlist = [];

  // Theme configuration listeners (can be triggered by users)
  static final ValueNotifier<bool> isDarkNotification = ValueNotifier(false);

  // Helper functions to interact with lists
  static void addToCart(DummyProduct product) {
    final index = cart.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      cart[index].quantity++;
    } else {
      product.quantity = 1;
      cart.add(product);
    }
  }

  static void removeFromCart(DummyProduct product) {
    cart.removeWhere((item) => item.id == product.id);
  }

  static void toggleWishlist(DummyProduct product) {
    final index = wishlist.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      wishlist.removeAt(index);
    } else {
      wishlist.add(product);
    }
  }

  static bool isWishlisted(String id) {
    return wishlist.any((item) => item.id == id);
  }

  static double getCartTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
