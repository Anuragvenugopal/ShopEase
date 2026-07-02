import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/datasources/admin_stats_datasource.dart';
import 'admin_stats_event.dart';
import 'admin_stats_state.dart';

@injectable
class AdminStatsBloc extends Bloc<AdminStatsEvent, AdminStatsState> {
  final AdminStatsDataSource _statsDataSource;

  AdminStatsBloc(this._statsDataSource) : super(AdminStatsInitial()) {
    on<FetchAdminStats>(_onFetchAdminStats);
  }

  Future<void> _onFetchAdminStats(
      FetchAdminStats event, Emitter<AdminStatsState> emit) async {
    emit(AdminStatsLoading());
    try {
      final stats = await _statsDataSource.fetchStats();
      emit(AdminStatsLoaded(stats));
    } catch (e) {
      emit(AdminStatsError(e.toString()));
    }
  }
}
