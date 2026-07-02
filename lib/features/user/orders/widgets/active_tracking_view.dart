import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/order_entity.dart';
import '../../../../presentation/blocs/order/order_bloc.dart';
import '../../../../presentation/blocs/order/order_state.dart';
import './order_history_card.dart';

class ActiveTrackingView extends StatelessWidget {
  const ActiveTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderError) {
          return Center(child: Text(state.message));
        }
        if (state is OrdersLoaded) {
          final activeOrders = state.activeOrders;
          if (activeOrders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No active tracking orders.'),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activeOrders.length,
            itemBuilder: (context, index) {
              final order = activeOrders[index];
              final firstItem = order.items.first;
              final dateStr =
                  '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

              return OrderHistoryCard(
                orderId: order.id,
                date: dateStr,
                price: order.totalAmount,
                status: order.status.name.toUpperCase(),
                statusStep: order.status == OrderStatus.pending
                    ? 0
                    : order.status == OrderStatus.confirmed
                        ? 1
                        : 2,
                productTitle: firstItem.title,
                productImageUrl: firstItem.imageUrl,
                canCancel: order.status == OrderStatus.pending,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
