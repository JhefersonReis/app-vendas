import 'package:zello/src/features/reports/data/reports_repository.dart';
import 'package:zello/src/features/reports/domain/report_model.dart';
import 'package:zello/src/features/reports/domain/reports_service.dart';

class ReportsServiceImpl implements ReportsService {
  final ReportsRepository _repository;

  ReportsServiceImpl(this._repository);

  @override
  Future<ReportData> getReportData(DateTime startDate, DateTime endDate) =>
      _repository.getReportData(startDate, endDate);
}
