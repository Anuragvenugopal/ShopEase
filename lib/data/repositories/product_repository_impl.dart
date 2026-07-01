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
  Future<List<ProductEntity>> getProducts() async {
    final models = await _dataSource.getProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String category) async {
    final models = await _dataSource.getProductsByCategory(category);
    return models.map((m) => m.toEntity()).toList();
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
