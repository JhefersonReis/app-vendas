import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zello/src/app/providers/providers.dart';
import 'package:zello/src/features/reports/domain/report_model.dart';
import 'package:zello/src/features/reports/domain/reports_service.dart';

final reportsControllerProvider = StateNotifierProvider<ReportsController, AsyncValue<ReportData?>>((ref) {
  final reportsService = ref.read(reportsServiceProvider);
  return ReportsController(reportsService);
});

class ReportsController extends StateNotifier<AsyncValue<ReportData?>> {
  final ReportsService _service;

  ReportsController(this._service) : super(const AsyncValue.data(null));

  Future<void> getReportData(DateTime startDate, DateTime endDate) async {
    state = const AsyncValue.loading();
    try {
      final data = await _service.getReportData(startDate, endDate);
      state = AsyncValue.data(data);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
