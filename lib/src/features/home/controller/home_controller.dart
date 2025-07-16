import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zello/src/features/home/controller/home_state.dart';
import 'package:zello/src/app/providers/providers.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref);
});

class HomeController extends StateNotifier<HomeState> {
  final Ref _ref;
  HomeController(this._ref) : super(HomeState());

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reportsRepository = _ref.read(reportsRepositoryProvider);
    final customersRepository = _ref.read(customersRepositoryProvider);
    final salesRepository = _ref.read(salesRepositoryProvider);
    final productsRepository = _ref.read(productRepositoryProvider);

    final reportData = await reportsRepository.getReportData(today, now);
    final allCustomers = await customersRepository.findAll();
    final allSales = await salesRepository.findAll();
    final products = await productsRepository.findAll();

    state = state.copyWith(
      totalSoldToday: reportData.totalRevenue,
      todayOrders: reportData.totalSales,
      totalSales: allSales.length,
      totalCustomers: allCustomers.length,
      totalProducts: products.length,
      pendingSales: allSales.where((sale) => !sale.isPaid).length,
      isLoading: false,
    );
  }
}
