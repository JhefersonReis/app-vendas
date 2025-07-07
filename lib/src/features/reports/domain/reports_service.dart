import 'package:organik_vendas/src/features/reports/domain/report_model.dart';

abstract interface class ReportsService {
  Future<ReportData> getReportData(DateTime startDate, DateTime endDate);
}
