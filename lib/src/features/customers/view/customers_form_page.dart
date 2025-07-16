import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/app/helpers/toast_helper.dart';
import 'package:zello/src/features/customers/controller/customers_controller.dart';

class CustomersFormPage extends ConsumerStatefulWidget {
  final String? id;

  const CustomersFormPage({super.key, this.id});

  @override
  ConsumerState<CustomersFormPage> createState() => _CustomersFormPageState();
}

class _CustomersFormPageState extends ConsumerState<CustomersFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _observationController = TextEditingController();
  String countryISOCode = 'BR';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCustomer(int.parse(widget.id!));
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomer(int id) async {
    final customer = await ref.read(customerByIdProvider(id).future);
    _nameController.text = customer.name;
    _phoneController.text = customer.phone ?? '';
    countryISOCode = customer.countryISOCode;
    _addressController.text = customer.address ?? '';
    _observationController.text = customer.observation ?? '';
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveCustomer() async {
    final localization = AppLocalizations.of(context)!;

    if (_nameController.text.isEmpty) {
      ToastHelper.showError(context, localization.customerNameIsRequired);
      return;
    }

    if (widget.id != null) {
      final customer = await ref.read(customerByIdProvider(int.parse(widget.id!)).future);

      await ref
          .read(customersControllerProvider.notifier)
          .updateCustomer(
            id: int.parse(widget.id!),
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            countryISOCode: countryISOCode,
            observation: _observationController.text,
            createdAt: customer.createdAt,
          );
      ref.invalidate(customerByIdProvider(int.parse(widget.id!)));
    } else {
      await ref
          .read(customersControllerProvider.notifier)
          .addCustomer(
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            countryISOCode: countryISOCode,
            observation: _observationController.text,
          );
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? localization.editCustomer : localization.newCustomer,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: localization.customerName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: localization.fullName,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      text: localization.phone,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    initialCountryCode: countryISOCode,
                    keyboardType: TextInputType.phone,
                    invalidNumberMessage: localization.invalidPhoneNumber,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    onCountryChanged: (value) {
                      log(value.code);
                      countryISOCode = value.code;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: localization.fullAddress,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      text: localization.observations,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  TextField(
                    controller: _observationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 3,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF248f3d),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _saveCustomer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          widget.id == null ? localization.createCustomer : localization.updateCustomer,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
