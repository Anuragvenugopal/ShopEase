import 'package:equatable/equatable.dart';
import '../../../data/datasources/admin_stats_datasource.dart';

abstract class AdminStatsState extends Equatable {
  const AdminStatsState();

  @override
  List<Object?> get props => [];
}

class AdminStatsInitial extends AdminStatsState {}

class AdminStatsLoading extends AdminStatsState {}

class AdminStatsLoaded extends AdminStatsState {
  final AdminDashboardStats stats;

  const AdminStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class AdminStatsError extends AdminStatsState {
  final String message;

  const AdminStatsError(this.message);

  @override
  List<Object?> get props => [message];
}
