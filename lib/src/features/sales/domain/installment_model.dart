class InstallmentModel {
  int id;
  int saleId;
  int installmentNumber;
  double value;
  DateTime dueDate;
  bool isPaid;

  InstallmentModel({
    required this.id,
    required this.saleId,
    required this.installmentNumber,
    required this.value,
    required this.dueDate,
    required this.isPaid,
  });
}