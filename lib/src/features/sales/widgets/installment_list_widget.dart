import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/app/helpers/currency_helper.dart';
import 'package:zello/src/features/sales/domain/installment_model.dart';

class InstallmentListWidget extends StatelessWidget {
  final List<InstallmentModel> installments;

  final void Function(InstallmentModel installment) onInstallmentSelected;

  const InstallmentListWidget({super.key, required this.installments, required this.onInstallmentSelected});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: installments.length,
      itemBuilder: (context, index) {
        final installment = installments[index];
        return Card(
          child: ListTile(
            title: Text('${localization.installment} ${installment.installmentNumber}'),
            subtitle: Text('${localization.dueDate}: ${DateFormat('dd/MM/yyyy').format(installment.dueDate)}'),
            trailing: Text(CurrencyHelper.formatCurrency(context, installment.value)),
            leading: Checkbox(
              value: installment.isPaid,
              onChanged: (value) {
                if (value != null) {
                  installment.isPaid = value;
                  onInstallmentSelected(installment);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
