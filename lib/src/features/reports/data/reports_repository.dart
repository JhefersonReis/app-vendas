import 'package:zello/src/features/reports/domain/report_model.dart';

abstract interface class ReportsRepository {
  Future<ReportData> getReportData(DateTime startDate, DateTime endDate);
}
