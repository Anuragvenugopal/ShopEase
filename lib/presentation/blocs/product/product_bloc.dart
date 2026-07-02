import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;

  ProductBloc(this._productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadMoreProductsByCategory>(_onLoadMoreProductsByCategory);
    on<LoadProductById>(_onLoadProductById);
    on<SearchProducts>(_onSearchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final paginated = await _productRepository.getProducts(limit: 10);
      emit(ProductsLoaded(
        paginated.products,
        hasReachedMax: paginated.hasReachedMax,
        lastDoc: paginated.lastDoc,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductsLoaded && !currentState.hasReachedMax) {
      try {
        final paginated = await _productRepository.getProducts(
          limit: 10,
          lastDocument: currentState.lastDoc,
        );
        emit(ProductsLoaded(
          currentState.products + paginated.products,
          hasReachedMax: paginated.hasReachedMax,
          lastDoc: paginated.lastDoc,
        ));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final paginated = await _productRepository.getProductsByCategory(
        category: event.category,
        limit: 10,
      );
      emit(ProductsLoaded(
        paginated.products,
        hasReachedMax: paginated.hasReachedMax,
        lastDoc: paginated.lastDoc,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProductsByCategory(
      LoadMoreProductsByCategory event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductsLoaded && !currentState.hasReachedMax) {
      try {
        final paginated = await _productRepository.getProductsByCategory(
          category: event.category,
          limit: 10,
          lastDocument: currentState.lastDoc,
        );
        emit(ProductsLoaded(
          currentState.products + paginated.products,
          hasReachedMax: paginated.hasReachedMax,
          lastDoc: paginated.lastDoc,
        ));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadProductById(
      LoadProductById event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final product = await _productRepository.getProductById(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    if (event.query.trim().isEmpty) {
      emit(const ProductsLoaded([], hasReachedMax: true));
      return;
    }
    emit(ProductLoading());
    try {
      final products = await _productRepository.searchProducts(event.query);
      emit(ProductsLoaded(products, hasReachedMax: true));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.addProduct(event.product);
      final paginated = await _productRepository.getProducts();
      emit(ProductsLoaded(
        paginated.products,
        hasReachedMax: paginated.hasReachedMax,
        lastDoc: paginated.lastDoc,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.updateProduct(event.product);
      final paginated = await _productRepository.getProducts();
      emit(ProductsLoaded(
        paginated.products,
        hasReachedMax: paginated.hasReachedMax,
        lastDoc: paginated.lastDoc,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await _productRepository.deleteProduct(event.id);
      final paginated = await _productRepository.getProducts();
      emit(ProductsLoaded(
        paginated.products,
        hasReachedMax: paginated.hasReachedMax,
        lastDoc: paginated.lastDoc,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
