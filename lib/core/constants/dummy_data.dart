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
    const DummyCategory(
      id: 'cat6',
      title: 'Accessories',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat7',
      title: 'Shoes',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=200&q=80',
    ),
    const DummyCategory(
      id: 'cat8',
      title: 'Groceries',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=200&q=80',
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
    DummyProduct(
      id: 'p9',
      title: 'Organic Extra Virgin Olive Oil 1L',
      description: 'Cold-pressed from hand-picked Mediterranean olives, this premium olive oil retains its full polyphenol profile and fruity aroma. Perfect for dressings, sautéing, and dipping. Certified organic and non-GMO.',
      imageUrl: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=600&q=80',
      price: 12.99,
      originalPrice: 16.99,
      rating: 4.7,
      reviewsCount: 112,
      category: 'Groceries',
      sku: 'GRO-OO-001',
      barcode: '801234567001',
      stock: 60,
    ),
    DummyProduct(
      id: 'p10',
      title: 'Whole Grain Brown Rice 5kg',
      description: 'Nutrient-rich long-grain brown rice sourced from sustainable paddy farms. High in fibre, naturally gluten-free, and ideal for everyday healthy cooking. Resealable zip-lock pouch keeps it fresh.',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=600&q=80',
      price: 8.49,
      rating: 4.5,
      reviewsCount: 87,
      category: 'Groceries',
      sku: 'GRO-BR-002',
      barcode: '801234567002',
      stock: 45,
    ),
    DummyProduct(
      id: 'p11',
      title: 'Fresh Farm Honey 500g Raw',
      description: 'Unfiltered, unheated raw honey straight from beehives in wild flower meadows. Packed with natural enzymes, antioxidants, and a rich amber sweetness. No additives, no preservatives.',
      imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&w=600&q=80',
      price: 9.99,
      originalPrice: 13.50,
      rating: 4.9,
      reviewsCount: 204,
      category: 'Groceries',
      sku: 'GRO-HN-003',
      barcode: '801234567003',
      stock: 30,
    ),
    DummyProduct(
      id: 'p12',
      title: 'Arabica Ground Coffee Dark Roast 250g',
      description: 'Single-origin 100% Arabica coffee beans, dark roasted to bring out bold chocolaty and caramel tasting notes. Ground to medium-fine for filter, French press, and espresso brewing.',
      imageUrl: 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=600&q=80',
      price: 11.25,
      rating: 4.8,
      reviewsCount: 158,
      category: 'Groceries',
      sku: 'GRO-CF-004',
      barcode: '801234567004',
      stock: 55,
    ),
    DummyProduct(
      id: 'p13',
      title: 'Mixed Nuts & Dry Fruits Pack 400g',
      description: 'A premium blend of roasted almonds, cashews, walnuts, pistachios, and sun-dried raisins. Lightly salted with zero added oils. Great as a protein-packed snack on the go.',
      imageUrl: 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?auto=format&fit=crop&w=600&q=80',
      price: 14.50,
      originalPrice: 18.00,
      rating: 4.6,
      reviewsCount: 73,
      category: 'Groceries',
      sku: 'GRO-NF-005',
      barcode: '801234567005',
      stock: 40,
    ),
    DummyProduct(
      id: 'p14',
      title: 'Greek Full-Fat Yogurt 1kg Tub',
      description: 'Thick, creamy Greek-style strained yogurt made from whole cow\'s milk. High in protein (10g per 100g), probiotic-rich, and naturally low in sugar. Perfect with granola, honey, or eaten plain.',
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=600&q=80',
      price: 6.75,
      rating: 4.4,
      reviewsCount: 61,
      category: 'Groceries',
      sku: 'GRO-YG-006',
      barcode: '801234567006',
      stock: 25,
    ),
    // Accessories products
    DummyProduct(
      id: 'p15',
      title: 'Genuine Leather Bifold Wallet',
      description: 'A slim, minimalist bifold wallet handcrafted from full-grain vegetable-tanned leather. Features 6 card slots, a clear ID window, and a central cash compartment. Ages gracefully with a rich natural patina.',
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=600&q=80',
      price: 39.99,
      originalPrice: 54.99,
      rating: 4.7,
      reviewsCount: 134,
      category: 'Accessories',
      sku: 'ACC-WL-001',
      barcode: '901234567001',
      stock: 50,
    ),
    DummyProduct(
      id: 'p16',
      title: 'Polarised Aviator Sunglasses',
      description: 'Timeless aviator frame crafted from lightweight stainless steel with anti-corrosion coating. Polarised UV400 lenses eliminate road and water glare. Includes a hard case and microfibre cloth.',
      imageUrl: 'https://images.unsplash.com/photo-1577803645773-f96470509666?auto=format&fit=crop&w=600&q=80',
      price: 49.00,
      originalPrice: 69.00,
      rating: 4.5,
      reviewsCount: 96,
      category: 'Accessories',
      sku: 'ACC-SG-002',
      barcode: '901234567002',
      stock: 35,
    ),
    DummyProduct(
      id: 'p17',
      title: 'Canvas Weekend Travel Duffel Bag',
      description: 'Rugged waxed canvas duffel bag with a spacious 40L capacity. Twin carry handles, a padded detachable shoulder strap, and multiple zippered pockets. Water-resistant and built for weekend getaways.',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=600&q=80',
      price: 74.99,
      rating: 4.6,
      reviewsCount: 52,
      category: 'Accessories',
      sku: 'ACC-BG-003',
      barcode: '901234567003',
      stock: 20,
    ),
    DummyProduct(
      id: 'p18',
      title: 'Stainless Steel Link Bracelet',
      description: 'Polished 316L surgical-grade stainless steel link bracelet with a secure fold-over clasp. Hypoallergenic, tarnish-resistant, and adjustable to most wrist sizes. Suitable for both casual and formal wear.',
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?auto=format&fit=crop&w=600&q=80',
      price: 29.50,
      originalPrice: 42.00,
      rating: 4.3,
      reviewsCount: 48,
      category: 'Accessories',
      sku: 'ACC-BR-004',
      barcode: '901234567004',
      stock: 65,
    ),
    DummyProduct(
      id: 'p19',
      title: 'Cashmere Blend Winter Scarf',
      description: 'Luxuriously soft scarf woven from a premium blend of 70% cashmere and 30% merino wool. Generously sized at 200×70cm with fringed ends. Lightweight yet incredibly warm — a wardrobe essential for cold months.',
      imageUrl: 'https://images.unsplash.com/photo-1520903920243-00d872a2d1c9?auto=format&fit=crop&w=600&q=80',
      price: 55.00,
      rating: 4.8,
      reviewsCount: 77,
      category: 'Accessories',
      sku: 'ACC-SC-005',
      barcode: '901234567005',
      stock: 28,
    ),
    DummyProduct(
      id: 'p20',
      title: 'Slim Minimalist Card Holder',
      description: 'Ultra-thin aluminium RFID-blocking card holder holds up to 8 cards with a thumb-slide mechanism for quick access. Anodised matte finish in brushed silver. Fits perfectly in any trouser pocket.',
      imageUrl: 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=600&q=80',
      price: 19.99,
      originalPrice: 27.00,
      rating: 4.4,
      reviewsCount: 119,
      category: 'Accessories',
      sku: 'ACC-CH-006',
      barcode: '901234567006',
      stock: 80,
    ),

    // ── Shoes ─────────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p21',
      title: 'Men\'s Classic Running Sneakers',
      description: 'Lightweight mesh upper with responsive foam midsole and durable rubber outsole. Engineered for daily runs and casual street wear. Available in multiple colorways with reflective heel tab for low-light visibility.',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
      price: 79.99,
      originalPrice: 109.99,
      rating: 4.6,
      reviewsCount: 231,
      category: 'Shoes',
      sku: 'SHO-RS-001',
      barcode: '701234568001',
      stock: 40,
    ),
    DummyProduct(
      id: 'p22',
      title: 'Women\'s Slip-On Canvas Loafers',
      description: 'Effortlessly chic slip-on loafers crafted from premium washed canvas. Featuring a memory foam insole, flexible rubber sole, and classic espadrille weave trim. Perfect for beach holidays and weekend brunches.',
      imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=600&q=80',
      price: 44.99,
      originalPrice: 59.99,
      rating: 4.5,
      reviewsCount: 108,
      category: 'Shoes',
      sku: 'SHO-LF-002',
      barcode: '701234568002',
      stock: 55,
    ),
    DummyProduct(
      id: 'p23',
      title: 'Leather Chelsea Ankle Boots',
      description: 'Sophisticated Chelsea boots crafted from full-grain calfskin leather with elastic side gussets for easy slip-on/off. Block heel provides extra stability. Welt-stitched construction for long-term durability.',
      imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?auto=format&fit=crop&w=600&q=80',
      price: 119.00,
      originalPrice: 159.00,
      rating: 4.8,
      reviewsCount: 76,
      category: 'Shoes',
      sku: 'SHO-CB-003',
      barcode: '701234568003',
      stock: 22,
    ),
    DummyProduct(
      id: 'p24',
      title: 'Trail Hiking Boots Waterproof',
      description: 'Conquer any terrain with these rugged waterproof hiking boots. Features a Gore-Tex membrane lining, Vibram outsole, cushioned ankle collar, and a padded tongue for all-day trail comfort.',
      imageUrl: 'https://images.unsplash.com/photo-1591633197541-b15f3ff4ff8c?auto=format&fit=crop&w=600&q=80',
      price: 139.99,
      rating: 4.7,
      reviewsCount: 143,
      category: 'Shoes',
      sku: 'SHO-HB-004',
      barcode: '701234568004',
      stock: 18,
    ),

    // ── Fashion ───────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p25',
      title: 'Slim-Fit Chino Trousers',
      description: 'Modern slim-fit chinos tailored from premium stretch cotton twill. Featuring a flat-front waistband, two side pockets, and two back welt pockets. Versatile enough for the office or weekend outings.',
      imageUrl: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?auto=format&fit=crop&w=600&q=80',
      price: 52.00,
      originalPrice: 69.00,
      rating: 4.5,
      reviewsCount: 184,
      category: 'Fashion',
      sku: 'FAS-CH-101',
      barcode: '712950381102',
      stock: 60,
    ),
    DummyProduct(
      id: 'p26',
      title: 'Oversized Linen Summer Shirt',
      description: 'Breathable 100% Belgian linen shirt with a relaxed oversized silhouette, mother-of-pearl buttons, and a split hem. The perfect warm-weather staple that pairs with shorts, chinos, or linen trousers.',
      imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&w=600&q=80',
      price: 38.50,
      rating: 4.4,
      reviewsCount: 91,
      category: 'Fashion',
      sku: 'FAS-LS-102',
      barcode: '712950381103',
      stock: 45,
    ),
    DummyProduct(
      id: 'p27',
      title: 'Women\'s Floral Wrap Midi Dress',
      description: 'Elegant wrap-style midi dress in a flowing viscose blend with an allover floral print. V-neckline, self-tie belt, and flutter sleeves create a flattering silhouette for any occasion from garden parties to office looks.',
      imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&w=600&q=80',
      price: 65.00,
      originalPrice: 89.00,
      rating: 4.7,
      reviewsCount: 207,
      category: 'Fashion',
      sku: 'FAS-WD-103',
      barcode: '712950381104',
      stock: 30,
    ),
    DummyProduct(
      id: 'p28',
      title: 'Quilted Puffer Jacket',
      description: 'Warm and lightweight quilted puffer jacket filled with recycled down alternative. Water-resistant shell fabric, packable design, two-way zip, and bungee-cord hem. Ideal for winter commutes and weekend adventures.',
      imageUrl: 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=600&q=80',
      price: 98.00,
      originalPrice: 130.00,
      rating: 4.6,
      reviewsCount: 153,
      category: 'Fashion',
      sku: 'FAS-PJ-104',
      barcode: '712950381105',
      stock: 25,
    ),

    // ── Electronics ───────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p29',
      title: 'True Wireless Earbuds ANC Pro',
      description: 'Next-gen true wireless earbuds featuring hybrid active noise cancellation, transparency mode, and custom-tuned 10mm dynamic drivers. IPX5 water resistance, 8-hour playtime (32hr with case), and a fast-charge USB-C case.',
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=600&q=80',
      price: 149.99,
      originalPrice: 199.99,
      rating: 4.7,
      reviewsCount: 318,
      category: 'Electronics',
      sku: 'ELE-TW-201',
      barcode: '880942351222',
      stock: 50,
    ),
    DummyProduct(
      id: 'p30',
      title: '65" 4K OLED Smart TV',
      description: 'Experience cinematic excellence with a 65-inch OLED panel delivering infinite contrast, 120Hz refresh rate, HDMI 2.1, and Dolby Vision HDR. Built-in smart OS with Netflix, Disney+, and voice remote.',
      imageUrl: 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=600&q=80',
      price: 1299.00,
      originalPrice: 1599.00,
      rating: 4.9,
      reviewsCount: 88,
      category: 'Electronics',
      sku: 'ELE-TV-202',
      barcode: '880942351223',
      stock: 10,
    ),
    DummyProduct(
      id: 'p31',
      title: 'Portable Bluetooth Speaker Waterproof',
      description: '360° surround sound portable speaker with dual passive radiators. IPX7 fully waterproof, 24-hour battery, built-in power bank, and a rugged rubberised shell. Perfect for outdoor adventures and beach days.',
      imageUrl: 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=600&q=80',
      price: 69.99,
      originalPrice: 89.99,
      rating: 4.6,
      reviewsCount: 274,
      category: 'Electronics',
      sku: 'ELE-BS-203',
      barcode: '880942351224',
      stock: 35,
    ),
    DummyProduct(
      id: 'p32',
      title: 'Mechanical Gaming Keyboard RGB',
      description: 'Full-size mechanical keyboard with Cherry MX Red switches, per-key RGB backlighting, N-key rollover, and an aircraft-grade aluminium top plate. USB-C detachable cable and magnetic wrist rest included.',
      imageUrl: 'https://images.unsplash.com/photo-1595044426077-d36d9236d54a?auto=format&fit=crop&w=600&q=80',
      price: 119.00,
      originalPrice: 149.00,
      rating: 4.8,
      reviewsCount: 196,
      category: 'Electronics',
      sku: 'ELE-KB-204',
      barcode: '880942351225',
      stock: 28,
    ),
    DummyProduct(
      id: 'p33',
      title: 'USB-C 100W Laptop Power Bank',
      description: '26800mAh high-capacity power bank with dual USB-C ports (100W + 18W) and dual USB-A ports. Supports pass-through charging, has an LED display for battery percentage, and fits most laptops, tablets, and phones.',
      imageUrl: 'https://images.unsplash.com/photo-1609592806596-4e6b61a07d4e?auto=format&fit=crop&w=600&q=80',
      price: 59.99,
      rating: 4.5,
      reviewsCount: 442,
      category: 'Electronics',
      sku: 'ELE-PB-205',
      barcode: '880942351226',
      stock: 80,
    ),

    // ── Beauty ────────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p34',
      title: 'Vitamin C Brightening Moisturiser',
      description: 'Lightweight daily moisturiser enriched with 15% L-Ascorbic Acid, Vitamin E, and Ferulic Acid. Brightens dull skin, fades dark spots, and provides broad-spectrum SPF 30 protection. Fragrance-free and dermatologist-tested.',
      imageUrl: 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?auto=format&fit=crop&w=600&q=80',
      price: 32.00,
      originalPrice: 45.00,
      rating: 4.7,
      reviewsCount: 189,
      category: 'Beauty',
      sku: 'BEU-VM-301',
      barcode: '528000742119',
      stock: 70,
    ),
    DummyProduct(
      id: 'p35',
      title: 'Retinol Anti-Ageing Night Cream',
      description: 'Intensive overnight repair cream with 0.5% encapsulated Retinol, Peptide Complex, and Shea Butter. Visibly reduces fine lines, improves skin texture, and boosts firmness overnight. Suitable for dry to normal skin.',
      imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=600&q=80',
      price: 42.00,
      originalPrice: 58.00,
      rating: 4.6,
      reviewsCount: 134,
      category: 'Beauty',
      sku: 'BEU-NC-302',
      barcode: '528000742120',
      stock: 55,
    ),
    DummyProduct(
      id: 'p36',
      title: 'Argan Oil Hair Treatment Serum',
      description: 'Lightweight Moroccan argan oil serum for frizz control, shine, and heat protection up to 230°C. A few drops tames flyaways, adds mirror-like gloss, and deeply conditions split ends without greasy residue.',
      imageUrl: 'https://images.unsplash.com/photo-1585751119414-ef2636f8aede?auto=format&fit=crop&w=600&q=80',
      price: 24.99,
      rating: 4.8,
      reviewsCount: 302,
      category: 'Beauty',
      sku: 'BEU-HS-303',
      barcode: '528000742121',
      stock: 90,
    ),

    // ── Sports ────────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p37',
      title: 'Adjustable Dumbbell Set 5–25kg',
      description: 'Space-saving adjustable dumbbells that replace 10 pairs of traditional weights. Dial-select mechanism lets you switch from 5kg to 25kg in seconds. Durable resin housing with steel internals and ergonomic grip handles.',
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=600&q=80',
      price: 229.99,
      originalPrice: 299.99,
      rating: 4.8,
      reviewsCount: 167,
      category: 'Sports',
      sku: 'SPO-DB-401',
      barcode: '914500182472',
      stock: 15,
    ),
    DummyProduct(
      id: 'p38',
      title: 'Yoga Mat Non-Slip 6mm Extra Thick',
      description: 'Premium 6mm thick TPE yoga mat with double-layer non-slip surface and moisture-wicking top coat. Alignment guide lines printed with eco-friendly inks. Lightweight, odour-resistant, and comes with a carry strap.',
      imageUrl: 'https://images.unsplash.com/photo-1601925228099-ae5b3cf85571?auto=format&fit=crop&w=600&q=80',
      price: 35.00,
      originalPrice: 49.00,
      rating: 4.7,
      reviewsCount: 289,
      category: 'Sports',
      sku: 'SPO-YM-402',
      barcode: '914500182473',
      stock: 85,
    ),
    DummyProduct(
      id: 'p39',
      title: 'Stainless Steel Insulated Water Bottle 1L',
      description: 'Double-wall vacuum-insulated stainless steel bottle that keeps drinks cold for 24 hours and hot for 12 hours. BPA-free, leak-proof screw cap, and durable powder-coated exterior. Fits most standard cup holders.',
      imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?auto=format&fit=crop&w=600&q=80',
      price: 26.99,
      originalPrice: 34.99,
      rating: 4.9,
      reviewsCount: 521,
      category: 'Sports',
      sku: 'SPO-WB-403',
      barcode: '914500182474',
      stock: 110,
    ),
    DummyProduct(
      id: 'p40',
      title: 'Pro Cycling Helmet MIPS',
      description: 'Aerodynamic road cycling helmet featuring MIPS brain protection system, 28 strategically placed vents, an adjustable retention system, and a lightweight EPS+polycarbonate shell. CE EN 1078 certified.',
      imageUrl: 'https://images.unsplash.com/photo-1507035895480-2b3156c31fc8?auto=format&fit=crop&w=600&q=80',
      price: 89.00,
      originalPrice: 119.00,
      rating: 4.6,
      reviewsCount: 94,
      category: 'Sports',
      sku: 'SPO-CH-404',
      barcode: '914500182475',
      stock: 30,
    ),

    // ── Home Decor ────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p41',
      title: 'Nordic Rattan Pendant Light',
      description: 'Hand-woven natural rattan pendant lamp with a warm Edison bulb included. Boho-inspired design perfect for dining rooms, bedrooms, and reading nooks. Adjustable cord length and compatible with standard E27 fittings.',
      imageUrl: 'https://images.unsplash.com/photo-1565814636199-ae8133055c1c?auto=format&fit=crop&w=600&q=80',
      price: 54.00,
      originalPrice: 72.00,
      rating: 4.6,
      reviewsCount: 68,
      category: 'Home Decor',
      sku: 'HOM-PL-501',
      barcode: '634000411294',
      stock: 40,
    ),
    DummyProduct(
      id: 'p42',
      title: 'Abstract Canvas Wall Art Set (3 Panels)',
      description: 'Gallery-worthy triptych canvas prints featuring bold abstract brushstroke artwork on premium gallery-wrapped canvas. UV-resistant inks, pre-mounted hanging hardware included. Sizes: 60×40cm each.',
      imageUrl: 'https://images.unsplash.com/photo-1579541591970-e5c95fc0d316?auto=format&fit=crop&w=600&q=80',
      price: 79.00,
      originalPrice: 105.00,
      rating: 4.5,
      reviewsCount: 53,
      category: 'Home Decor',
      sku: 'HOM-CA-502',
      barcode: '634000411295',
      stock: 25,
    ),
    DummyProduct(
      id: 'p43',
      title: 'Scented Soy Wax Candle Set (3-Pack)',
      description: 'Hand-poured 100% natural soy wax candles in three complementary fragrances: Cedarwood & Vetiver, Lavender & Chamomile, and Wild Jasmine. Cotton wicks, 45-hour burn time each. Presented in a luxury gift box.',
      imageUrl: 'https://images.unsplash.com/photo-1602178506571-8a73f24c1a7b?auto=format&fit=crop&w=600&q=80',
      price: 36.00,
      rating: 4.8,
      reviewsCount: 211,
      category: 'Home Decor',
      sku: 'HOM-SC-503',
      barcode: '634000411296',
      stock: 65,
    ),

    // ── Groceries ─────────────────────────────────────────────────────────────
    DummyProduct(
      id: 'p44',
      title: 'Cold-Pressed Green Juice Blend 6-Pack',
      description: 'Six 350ml bottles of cold-pressed juice blended from fresh spinach, cucumber, celery, green apple, lemon, and ginger. High-pressure processed (HPP) to preserve maximum nutrients. No added sugar, preservatives, or concentrates.',
      imageUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?auto=format&fit=crop&w=600&q=80',
      price: 22.99,
      originalPrice: 29.99,
      rating: 4.7,
      reviewsCount: 145,
      category: 'Groceries',
      sku: 'GRO-GJ-007',
      barcode: '801234567007',
      stock: 48,
    ),
    DummyProduct(
      id: 'p45',
      title: 'Dark Chocolate 85% Cacao 200g',
      description: 'Single-origin 85% cacao dark chocolate bar sourced from ethically farmed cacao estates in Ecuador. Intense, complex flavour notes of dark berry, tobacco, and toasted hazelnut. Vegan, gluten-free, and Fairtrade certified.',
      imageUrl: 'https://images.unsplash.com/photo-1548907040-4baa42d10919?auto=format&fit=crop&w=600&q=80',
      price: 7.50,
      rating: 4.9,
      reviewsCount: 388,
      category: 'Groceries',
      sku: 'GRO-DC-008',
      barcode: '801234567008',
      stock: 120,
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