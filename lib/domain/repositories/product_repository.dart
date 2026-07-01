import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<List<ProductEntity>> getProductsByCategory(String category);
  Future<ProductEntity> getProductById(String id);
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}
