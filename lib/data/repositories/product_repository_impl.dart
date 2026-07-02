import 'package:injectable/injectable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  Future<PaginatedProducts> getProducts({int limit = 10, dynamic lastDocument}) async {
    final response = await _dataSource.getProducts(limit: limit, lastDocument: lastDocument);
    return PaginatedProducts(
      products: response.items.map((m) => m.toEntity()).toList(),
      lastDoc: response.lastDoc,
      hasReachedMax: response.hasReachedMax,
    );
  }

  @override
  Future<PaginatedProducts> getProductsByCategory({
    required String category,
    int limit = 10,
    dynamic lastDocument,
  }) async {
    final response = await _dataSource.getProductsByCategory(
      category: category,
      limit: limit,
      lastDocument: lastDocument,
    );
    return PaginatedProducts(
      products: response.items.map((m) => m.toEntity()).toList(),
      lastDoc: response.lastDoc,
      hasReachedMax: response.hasReachedMax,
    );
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    final model = await _dataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    final models = await _dataSource.searchProducts(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<String>> getCategories() => _dataSource.getCategories();

  @override
  Future<void> addProduct(ProductEntity product) async {
    await _dataSource.addProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await _dataSource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _dataSource.deleteProduct(id);
  }
}
