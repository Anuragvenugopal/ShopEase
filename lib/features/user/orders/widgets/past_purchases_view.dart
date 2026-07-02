import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../domain/entities/cart_item_entity.dart';
import '../../../../presentation/blocs/auth/auth_bloc.dart';
import '../../../../presentation/blocs/auth/auth_state.dart';
import '../../../../presentation/blocs/cart/cart_bloc.dart';
import '../../../../presentation/blocs/cart/cart_event.dart';
import '../../../../presentation/blocs/order/order_bloc.dart';
import '../../../../presentation/blocs/order/order_state.dart';
import './order_history_card.dart';

class PastPurchasesView extends StatelessWidget {
  const PastPurchasesView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState is Authenticated ? authState.user.id : '';

    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderError) {
          return Center(child: Text(state.message));
        }
        if (state is OrdersLoaded) {
          final pastOrders = state.pastOrders;
          if (pastOrders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No past purchases.'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pastOrders.length,
            itemBuilder: (context, index) {
              final order = pastOrders[index];
              final firstItem = order.items.first;
              final dateStr =
                  '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

              return OrderHistoryCard(
                orderId: order.id,
                date: dateStr,
                price: order.totalAmount,
                status: order.status.name.toUpperCase(),
                statusStep: 3,
                productTitle: firstItem.title,
                productImageUrl: firstItem.imageUrl,
                canCancel: false,
                onBuyAgain: () {
                  if (userId.isNotEmpty) {
                    context.read<CartBloc>().add(
                          AddToCart(
                            userId,
                            CartItemEntity(
                              productId: firstItem.productId,
                              title: firstItem.title,
                              imageUrl: firstItem.imageUrl,
                              price: firstItem.price,
                              quantity: firstItem.quantity,
                            ),
                          ),
                        );
                    CustomToast.show(
                        context, '${firstItem.title} added to Cart!');
                  }
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
