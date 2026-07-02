import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<PaginatedProducts> getProducts({int limit = 10, dynamic lastDocument});
  Future<PaginatedProducts> getProductsByCategory({required String category, int limit = 10, dynamic lastDocument});
  Future<ProductEntity> getProductById(String id);
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}
