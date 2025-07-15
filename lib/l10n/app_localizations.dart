import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Control'**
  String get homeTitle;

  /// No description provided for @salesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesTitle;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @homeBottomNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeBottomNavigationTitle;

  /// No description provided for @salesBottomNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesBottomNavigationTitle;

  /// No description provided for @productsBottomNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsBottomNavigationTitle;

  /// No description provided for @customersBottomNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersBottomNavigationTitle;

  /// No description provided for @reportsBottomNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsBottomNavigationTitle;

  /// No description provided for @todaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaySummary;

  /// No description provided for @totalSold.
  ///
  /// In en, this message translates to:
  /// **'Total Sold'**
  String get totalSold;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get filterBy;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @newSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSale;

  /// No description provided for @createSale.
  ///
  /// In en, this message translates to:
  /// **'Create Sale'**
  String get createSale;

  /// No description provided for @updateSale.
  ///
  /// In en, this message translates to:
  /// **'Update Sale'**
  String get updateSale;

  /// No description provided for @noSalesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No sales recorded'**
  String get noSalesRecorded;

  /// No description provided for @noSalesFoundWithThisFilter.
  ///
  /// In en, this message translates to:
  /// **'No sales found with this filter'**
  String get noSalesFoundWithThisFilter;

  /// No description provided for @areYouSureYouWantToDeleteThisSale.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this sale?'**
  String get areYouSureYouWantToDeleteThisSale;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @startByRecordingYourFirstSale.
  ///
  /// In en, this message translates to:
  /// **'Start by recording your first sale'**
  String get startByRecordingYourFirstSale;

  /// No description provided for @registerFirstSale.
  ///
  /// In en, this message translates to:
  /// **'Register First Sale'**
  String get registerFirstSale;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'See Details'**
  String get seeDetails;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @noProductsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No products registered'**
  String get noProductsRegistered;

  /// No description provided for @noProductsFoundWithThisFilter.
  ///
  /// In en, this message translates to:
  /// **'No products found with this filter'**
  String get noProductsFoundWithThisFilter;

  /// No description provided for @areYouSureYouWantToDeleteThisProduct.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get areYouSureYouWantToDeleteThisProduct;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get deleteConfirmTitle;

  /// No description provided for @startAddingYourProductsToMakeSellingEasier.
  ///
  /// In en, this message translates to:
  /// **'Start adding your products\nto make selling easier'**
  String get startAddingYourProductsToMakeSellingEasier;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @salesQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get salesQuantity;

  /// No description provided for @customersQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get customersQuantity;

  /// No description provided for @productsQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get productsQuantity;

  /// No description provided for @pendingSales.
  ///
  /// In en, this message translates to:
  /// **'Pending Sales'**
  String get pendingSales;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @pendings.
  ///
  /// In en, this message translates to:
  /// **'Pendings'**
  String get pendings;

  /// No description provided for @paids.
  ///
  /// In en, this message translates to:
  /// **'Paids'**
  String get paids;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get product;

  /// No description provided for @enterTheProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter the product name'**
  String get enterTheProductName;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @selectACustomer.
  ///
  /// In en, this message translates to:
  /// **'Select a Customer'**
  String get selectACustomer;

  /// No description provided for @noRegisteredCustomers.
  ///
  /// In en, this message translates to:
  /// **'No registered customers'**
  String get noRegisteredCustomers;

  /// No description provided for @registerYourCustomersToMakeSales.
  ///
  /// In en, this message translates to:
  /// **'Register your customers to make sales'**
  String get registerYourCustomersToMakeSales;

  /// No description provided for @addFirstCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add First Client'**
  String get addFirstCustomer;

  /// No description provided for @noCustomersFoundWithThisFilter.
  ///
  /// In en, this message translates to:
  /// **'No customers found with this filter'**
  String get noCustomersFoundWithThisFilter;

  /// No description provided for @areYouSureYouWantToDeleteThisClient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this client? All related data will be lost.'**
  String get areYouSureYouWantToDeleteThisClient;

  /// No description provided for @selectADate.
  ///
  /// In en, this message translates to:
  /// **'Select a Date'**
  String get selectADate;

  /// No description provided for @dateOfSale.
  ///
  /// In en, this message translates to:
  /// **'Date of Sale'**
  String get dateOfSale;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @saleItems.
  ///
  /// In en, this message translates to:
  /// **'Sale Items'**
  String get saleItems;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addFirstProduct.
  ///
  /// In en, this message translates to:
  /// **'Add First Product'**
  String get addFirstProduct;

  /// No description provided for @selectAProduct.
  ///
  /// In en, this message translates to:
  /// **'Select a Product'**
  String get selectAProduct;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @totalSale.
  ///
  /// In en, this message translates to:
  /// **'Total Sale'**
  String get totalSale;

  /// No description provided for @saleNotes.
  ///
  /// In en, this message translates to:
  /// **'Sale notes'**
  String get saleNotes;

  /// No description provided for @saleAlreadyPaid.
  ///
  /// In en, this message translates to:
  /// **'Sale Already Paid'**
  String get saleAlreadyPaid;

  /// No description provided for @observations.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get observations;

  /// No description provided for @editSale.
  ///
  /// In en, this message translates to:
  /// **'Edit Sale'**
  String get editSale;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @createProduct.
  ///
  /// In en, this message translates to:
  /// **'Create Product'**
  String get createProduct;

  /// No description provided for @updateProduct.
  ///
  /// In en, this message translates to:
  /// **'Update Product'**
  String get updateProduct;

  /// No description provided for @newProduct.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get newProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @productNote.
  ///
  /// In en, this message translates to:
  /// **'Product Notes'**
  String get productNote;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @newCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @createCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create Customer'**
  String get createCustomer;

  /// No description provided for @updateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Update Customer'**
  String get updateCustomer;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get fullAddress;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @selectAPeriodToGenerateTheReport.
  ///
  /// In en, this message translates to:
  /// **'Select a period to generate the report'**
  String get selectAPeriodToGenerateTheReport;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paidSales.
  ///
  /// In en, this message translates to:
  /// **'Paid Sales'**
  String get paidSales;

  /// No description provided for @averageTicket.
  ///
  /// In en, this message translates to:
  /// **'Average Ticket'**
  String get averageTicket;

  /// No description provided for @bestSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Best Selling Products'**
  String get bestSellingProducts;

  /// No description provided for @noProductsSoldInThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No products sold in this period'**
  String get noProductsSoldInThisPeriod;

  /// No description provided for @noCustomersFoundInThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'No customers found in this period'**
  String get noCustomersFoundInThisPeriod;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @bestCustomers.
  ///
  /// In en, this message translates to:
  /// **'Best Customers'**
  String get bestCustomers;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @totalSpend.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get totalSpend;

  /// No description provided for @selectOneClient.
  ///
  /// In en, this message translates to:
  /// **'Select one client'**
  String get selectOneClient;

  /// No description provided for @addAtLeastOneProduct.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product'**
  String get addAtLeastOneProduct;

  /// No description provided for @productNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameIsRequired;

  /// No description provided for @productPriceIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Product price is required'**
  String get productPriceIsRequired;

  /// No description provided for @productWeightIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Product weight is required'**
  String get productWeightIsRequired;

  /// No description provided for @customerNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameIsRequired;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
