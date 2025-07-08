class HomeState {
  final double totalSoldToday;
  final int todayOrders;
  final int totalSales;
  final int totalCustomers;
  final int totalProducts;
  final int pendingSales;
  final bool isLoading;

  HomeState({
    this.totalSoldToday = 0.0,
    this.todayOrders = 0,
    this.totalSales = 0,
    this.totalCustomers = 0,
    this.totalProducts = 0,
    this.pendingSales = 0,
    this.isLoading = false,
  });

  HomeState copyWith({
    double? totalSoldToday,
    int? todayOrders,
    int? totalSales,
    int? totalCustomers,
    int? totalProducts,
    int? pendingSales,
    bool? isLoading,
  }) {
    return HomeState(
      totalSoldToday: totalSoldToday ?? this.totalSoldToday,
      todayOrders: todayOrders ?? this.todayOrders,
      totalSales: totalSales ?? this.totalSales,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      totalProducts: totalProducts ?? this.totalProducts,
      pendingSales: pendingSales ?? this.pendingSales,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
