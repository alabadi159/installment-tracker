import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'app_models.dart';

const _appName = 'AuraWelth Pro';
const _storageChannel =
    MethodChannel('com.example.installment_tracker/storage');
const _categories = [
  'Food',
  'Transport',
  'Bills',
  'Shopping',
  'Health',
  'Other'
];

const _arabicStrings = {
  'AuraWelth Pro': 'أورا ويلث برو',
  'Home': 'الرئيسية',
  'Plans': 'الأقساط',
  'Contracts': 'العقود',
  'Vehicles': 'المركبات',
  'Assets': 'الأصول',
  'Budget': 'الميزانية',
  'Add item': 'إضافة عنصر',
  'Settings': 'الإعدادات',
  'Payment reminders': 'تذكيرات الدفع',
  'Contract reminder days': 'أيام التذكير بالعقد',
  'Language': 'اللغة',
  'Appearance': 'المظهر',
  'System': 'حسب النظام',
  'Light': 'فاتح',
  'Dark': 'داكن',
  'Monthly salary': 'الراتب الشهري',
  'Available salary balance': 'رصيد الراتب المتاح',
  'Monthly plans and contracts': 'الأقساط والعقود الشهرية',
  'No payments due today': 'لا توجد دفعات مستحقة اليوم',
  'payments need attention': 'دفعات تحتاج إلى متابعة',
  'Payment shortfalls need attention': 'يرجى مراجعة الدفعات المتعثرة',
  'Local finance tracker · amounts in SAR': 'متتبع مالي محلي · المبالغ بالريال',
  'Set salary and balance': 'تعيين الراتب والرصيد',
  'Add expense': 'إضافة مصروف',
  'Mark paid': 'تسجيل كمدفوع',
  'Recent finance activity': 'أحدث العمليات المالية',
  'View full finance ledger': 'عرض السجل المالي كاملاً',
  'Finance ledger': 'السجل المالي',
  'Close': 'إغلاق',
  'No items yet. Tap Add item to start.':
      'لا توجد عناصر. اضغط إضافة عنصر للبدء.',
  'Plans and installments': 'الخطط والأقساط',
  'Car loans': 'قروض السيارات',
  'Service contracts': 'عقود الخدمات',
  'Device installments': 'أقساط الأجهزة',
  'Gold assets': 'أصول الذهب',
  'Vehicle services': 'خدمات المركبات',
  'Budgets and spending': 'الميزانيات والمصروفات',
  'Food': 'الطعام',
  'Transport': 'المواصلات',
  'Bills': 'الفواتير',
  'Shopping': 'التسوق',
  'Health': 'الصحة',
  'Other': 'أخرى',
  'Add': 'إضافة',
  'months': 'أشهر',
  'days before end date': 'يوماً قبل تاريخ الانتهاء',
  'Edit': 'تعديل',
  'Remove': 'حذف',
  'Add service or request': 'إضافة خدمة أو طلب',
  'Add a car loan to manage vehicle services.':
      'أضف قرض سيارة لإدارة خدمات المركبة.',
  'Refresh spot price or enter a local price per gram':
      'حدّث السعر الفوري أو أدخل السعر المحلي للغرام',
  'Enter a local price per gram': 'أدخل السعر المحلي للغرام',
  'Monthly service fee (SAR)': 'رسوم الخدمة الشهرية (ريال)',
  'Choose contract end date': 'اختيار تاريخ انتهاء العقد',
  'Clear contract end date': 'مسح تاريخ انتهاء العقد',
  'Next payment': 'الدفعة التالية',
  'Next billing date': 'تاريخ الفاتورة التالية',
  'Contract end': 'انتهاء العقد',
  'Reminder': 'تذكير',
  'Clear reminder date': 'مسح تاريخ التذكير',
  'Choose reminder date': 'اختيار تاريخ التذكير',
  'Payment due': 'موعد الدفع',
  'Service': 'الخدمة',
  'estimate': 'تقديري',
  'manual': 'يدوي',
  'Set budget': 'تعيين الميزانية',
  'Cancel': 'إلغاء',
  'Save': 'حفظ',
  'Name': 'الاسم',
  'Provider': 'مقدم الخدمة',
  'Monthly payment (SAR)': 'القسط الشهري (ريال)',
  'Remaining balance (SAR)': 'الرصيد المتبقي (ريال)',
  'Remaining months (1–120)': 'الأشهر المتبقية (١–١٢٠)',
  'Remaining months (2–24)': 'الأشهر المتبقية (٢–٢٤)',
  'SNB FLEX remaining months': 'الأشهر المتبقية في SNB FLEX',
  'SNB FLEX is fixed to four monthly payments.':
      'خطة SNB FLEX ثابتة بأربع دفعات شهرية.',
  'SNB FLEX plans must be four months.':
      'يجب أن تكون مدة خطة SNB FLEX أربعة أشهر.',
  'Tabby and Tamara plans must be 2–24 months.':
      'يجب أن تتراوح مدة خطط تابي وتمارا بين شهرين و٢٤ شهراً.',
  'Contract type': 'نوع العقد',
  'Mobile': 'جوال',
  'Internet': 'إنترنت',
  'Insurance': 'تأمين',
  'Linked service contract': 'عقد الخدمة المرتبط',
  'None': 'لا يوجد',
  'Set gold price manually': 'تعيين سعر الذهب يدوياً',
  'Salary settings': 'إعدادات الراتب',
  'Monthly salary (SAR)': 'الراتب الشهري (ريال)',
  'Payday (day of month)': 'يوم الراتب من الشهر',
  'Current balance (SAR)': 'الرصيد الحالي (ريال)',
  'Spent': 'المصروف',
  'budget': 'الميزانية',
  'not set': 'غير محددة',
  'last month': 'الشهر الماضي',
  'linked devices': 'الأجهزة المرتبطة',
  'Category': 'الفئة',
  'Monthly Food budget': 'ميزانية الطعام الشهرية',
  'Monthly Transport budget': 'ميزانية المواصلات الشهرية',
  'Monthly Bills budget': 'ميزانية الفواتير الشهرية',
  'Monthly Shopping budget': 'ميزانية التسوق الشهرية',
  'Monthly Health budget': 'ميزانية الصحة الشهرية',
  'Monthly Other budget': 'ميزانية الفئات الأخرى',
  '24K price per gram (SAR)': 'سعر غرام الذهب عيار ٢٤ (ريال)',
  'Budget used': 'المستخدم من الميزانية',
  'Saved data could not be loaded. It has not been erased.':
      'تعذر تحميل البيانات المحفوظة. لم يتم حذفها.',
  'Description': 'الوصف',
  'Vehicle service request': 'طلب خدمة مركبة',
  'Service or request': 'الخدمة أو الطلب',
  'Notes': 'ملاحظات',
  'Service fee (SAR)': 'رسوم الخدمة (ريال)',
  'no device': 'لا يوجد جهاز',
  'requested': 'مطلوب',
  'inProgress': 'قيد التنفيذ',
  'completed': 'مكتمل',
  'salary': 'راتب',
  'income': 'دخل',
  'payment': 'دفعة',
  'expense': 'مصروف',
  'transfer': 'تحويل',
  'deposit': 'إيداع',
  'openingBalance': 'رصيد افتتاحي',
  'withdrawal': 'سحب',
  'adjustment': 'تسوية',
  'shortfall': 'عجز',
  'buy': 'شراء',
  'sell': 'بيع',
  'Tabby': 'تابي',
  'Tamara': 'تمارا',
  'SnbFlex': 'SNB FLEX',
  'SNB FLEX': 'SNB FLEX',
  'Bird': 'BIRD',
  'BIRD': 'BIRD',
  'CarLoan': 'قرض سيارة',
  'Device': 'جهاز',
  'Dismiss': 'إغلاق',
  'Try again': 'إعادة المحاولة',
  'Finance analysis': 'التحليل المالي',
  'Savings accounts': 'حسابات التوفير',
  'Cash flow · last 6 months': 'التدفق النقدي · آخر ٦ أشهر',
  'Income': 'الدخل',
  'Expenses': 'المصروفات',
  'Installments paid': 'الأقساط المدفوعة',
  'Budget vs spending · this month': 'الميزانية مقابل الإنفاق · هذا الشهر',
  'No financial activity for this period.': 'لا توجد حركة مالية لهذه الفترة.',
  'No budgets set yet. Set category budgets to compare spending.':
      'لم يتم تعيين ميزانيات. أضف ميزانيات للفئات لمقارنة الإنفاق.',
  'Create savings account': 'إنشاء حساب توفير',
  'Account name': 'اسم الحساب',
  'Add account': 'إضافة حساب',
  'No savings accounts yet.': 'لا توجد حسابات توفير بعد.',
  'Deposit': 'إيداع',
  'Add existing savings': 'إضافة مدخرات موجودة',
  'Opening balance': 'رصيد افتتاحي',
  'Withdraw': 'سحب',
  'Transfer': 'تحويل',
  'Transaction history': 'سجل العمليات',
  'Amount (SAR)': 'المبلغ (ريال)',
  'Note (optional)': 'ملاحظة (اختيارية)',
  'From account': 'من الحساب',
  'To account': 'إلى الحساب',
  'Available cash is too low for this deposit.':
      'الرصيد النقدي المتاح لا يكفي لهذا الإيداع.',
  'Save transaction': 'حفظ العملية',
  'Gold Vault (Live Internet 24K)': 'خزنة الذهب (سعر مباشر عيار ٢٤)',
  'Live price': 'السعر المباشر',
  'Cached price': 'السعر المحفوظ',
  'Live Price': 'السعر المباشر',
  'Gold value': 'قيمة الذهب',
  'Buy': 'شراء',
  'Sell': 'بيع',
  'Grams': 'غرام',
  'Enter grams': 'أدخل الوزن بالغرام',
  'Gold purchase': 'شراء ذهب',
  'Gold sale': 'بيع ذهب',
  'Gold transaction history': 'سجل عمليات الذهب',
  'Started': 'تاريخ البداية',
  'Expires': 'تاريخ الانتهاء',
  'Choose expiration date': 'اختيار تاريخ الانتهاء',
  'Expiration date cannot be before the start date.':
      'لا يمكن أن يسبق تاريخ الانتهاء تاريخ البداية.',
  'Savings account balance': 'رصيد حساب التوفير',
  'Account-to-account transfer': 'تحويل بين الحسابات',
  'Savings transaction recorded': 'تم تسجيل عملية التوفير',
  'Quote updated': 'تم تحديث السعر',
  'As of': 'حتى',
  'Last update': 'آخر تحديث',
  'Refresh': 'تحديث',
  'No gold trades yet.': 'لا توجد عمليات ذهب بعد.',
  'Total held': 'إجمالي الذهب',
  'Monthly cash flow': 'التدفق النقدي الشهري',
  'Category budgets': 'ميزانيات الفئات',
  'Transaction date': 'تاريخ العملية',
  'Service contract': 'عقد الخدمة',
  'Expense': 'مصروف',
  'Monthly budget': 'الميزانية الشهرية',
  'Spent amount': 'المبلغ المصروف',
  'To': 'إلى',
  'Source': 'المصدر',
  'Trend': 'الاتجاه',
  'Available cash': 'النقد المتاح',
  'Enter grams greater than zero.': 'أدخل وزناً أكبر من صفر غرام.',
  'You cannot sell more gold than is held.':
      'لا يمكن بيع كمية أكبر من الذهب المتوفر.',
  'Available salary balance is too low for this purchase.':
      'رصيد الراتب المتاح لا يكفي لهذا الشراء.',
  'Enter an amount greater than zero.': 'أدخل مبلغاً أكبر من صفر.',
  'Existing savings can only be recorded once before account activity.':
      'يمكن تسجيل المدخرات الموجودة مرة واحدة قبل بدء نشاط الحساب.',
  'Record only the current unpaid balance for a plan. Previous paid installments are not counted again.':
      'سجّل الرصيد غير المدفوع فقط للخطة. لن تُحتسب الأقساط المدفوعة سابقاً مرة أخرى.',
  'Set the next payment date to the next unpaid installment.':
      'عيّن تاريخ الدفعة التالية للقسط غير المدفوع التالي.',
  'Choose a destination account.': 'اختر الحساب المستهدف.',
  'Enter a unique savings account name.': 'أدخل اسماً فريداً لحساب التوفير.',
  'Savings account was not found.': 'لم يتم العثور على حساب التوفير.',
  'Choose a different destination savings account.':
      'اختر حساب توفير مستهدفاً مختلفاً.',
  'Only account transfers have a destination account.':
      'التحويل بين الحسابات فقط يحتاج إلى حساب مستهدف.',
  'Savings account balance is too low.': 'رصيد حساب التوفير غير كافٍ.',
  'Choose an expiration date.': 'اختر تاريخ انتهاء.',
  'A valid gold price is required to trade.':
      'يلزم سعر ذهب صالح لإجراء العملية.',
  'Enter a grams amount greater than zero.': 'أدخل كمية بالغرام أكبر من صفر.',
};

String _tr(BuildContext context, String value) =>
    Localizations.localeOf(context).languageCode == 'ar'
        ? _arabicStrings[value] ?? value
        : value;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AuraWelthApp());
}

class TrackerStore extends ChangeNotifier {
  AppData data = const AppData();
  bool ready = false;
  String? error;
  String? actionError;
  bool goldRefreshing = false;
  DateTime? lastGoldRefreshAttempt;
  int _idCounter = 0;

  String _newId(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  Future<void> load() async {
    try {
      final saved = await _storageChannel.invokeMethod<String>('loadAppData');
      if (saved != null && saved.isNotEmpty) {
        data = decodeAppData(saved);
      } else {
        final legacy = await _storageChannel.invokeMethod<String>('loadPlans');
        if (legacy != null) {
          final decoded = jsonDecode(legacy);
          if (decoded is! List) {
            throw const FormatException('Saved payment plans are invalid.');
          }
          data = data.copyWith(
            items: decoded.map((entry) {
              if (entry is! Map) {
                throw const FormatException(
                    'A saved payment plan record is invalid.');
              }
              return TrackedItem.fromJson(Map<String, dynamic>.from(entry));
            }).toList(),
          );
        }
      }
      data = _reconcile(data, DateTime.now());
      await _persist();
      ready = true;
      error = null;
      await _scheduleReminders();
    } on PlatformException catch (exception) {
      error = exception.message ?? exception.code;
    } on FormatException catch (exception) {
      error = exception.message;
    } on ArgumentError catch (exception) {
      error = exception.message?.toString() ?? 'Saved app data is invalid.';
    } on TypeError catch (exception) {
      error = exception.toString();
    } finally {
      notifyListeners();
    }
  }

  AppData _reconcile(AppData current, DateTime now) {
    var items = [...current.items];
    var entries = [...current.entries];
    var nextPayday = current.nextPayday ??
        (current.income > 0
            ? _nextPayday(DateUtils.dateOnly(now), current.payday)
            : null);
    final seen = entries.map((entry) => entry.id).toSet();
    final balance =
        () => entries.fold<double>(0, (sum, entry) => sum + entry.balanceDelta);
    var count = 0;
    while (count++ < 4096) {
      final due = items.where((item) {
        return item.isActive &&
            item.kind != ItemKind.gold &&
            item.monthlyTotal > 0 &&
            item.nextDue != null &&
            !DateUtils.dateOnly(item.nextDue!).isAfter(DateUtils.dateOnly(now));
      }).toList()
        ..sort((a, b) => a.nextDue!.compareTo(b.nextDue!));
      final plan = due.isEmpty ? null : due.first;
      final paydayToApply = nextPayday;
      final salaryIsDue = paydayToApply != null &&
          !DateUtils.dateOnly(paydayToApply).isAfter(DateUtils.dateOnly(now));
      if (paydayToApply != null &&
          salaryIsDue &&
          (plan == null ||
              !DateUtils.dateOnly(paydayToApply).isAfter(
                DateUtils.dateOnly(plan.nextDue!),
              ))) {
        final id = 'salary-${paydayToApply.year}-${paydayToApply.month}';
        if (current.income > 0 && seen.add(id)) {
          entries.add(FinanceEntry(
            id: id,
            type: FinanceType.salary,
            amount: current.income,
            balanceDelta: current.income,
            date: now,
            description: 'Monthly salary',
          ));
        }
        nextPayday = _nextPayday(paydayToApply, current.payday);
        continue;
      }
      if (plan == null) break;
      final amount = plan.monthlyTotal;
      final paymentId = 'payment-${plan.id}-${plan.nextDue!.toIso8601String()}';
      if (balance() >= amount && seen.add(paymentId)) {
        entries.add(FinanceEntry(
          id: paymentId,
          type: FinanceType.payment,
          amount: amount,
          balanceDelta: -amount,
          date: now,
          description: plan.name,
          itemId: plan.id,
        ));
        items = items
            .map((item) => item.id == plan.id ? item.afterPayment() : item)
            .toList();
      } else {
        if (seen.add(paymentId)) {
          entries.add(FinanceEntry(
            id: 'shortfall-$paymentId',
            type: FinanceType.shortfall,
            amount: amount,
            balanceDelta: 0,
            date: now,
            description: plan.name,
            itemId: plan.id,
          ));
        }
        items = items
            .map((item) => item.id == plan.id
                ? item.copyWith(nextDue: _addMonths(plan.nextDue!, 1))
                : item)
            .toList();
      }
    }
    return current.copyWith(
      items: items,
      entries: entries,
      nextPayday: nextPayday,
    );
  }

  Future<void> save(AppData next) async {
    try {
      await _persist(next);
      data = next;
      actionError = null;
      await _scheduleReminders();
    } on PlatformException catch (exception) {
      actionError = exception.message ?? exception.code;
    } catch (exception) {
      actionError = exception.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _persist([AppData? target]) async {
    await _storageChannel.invokeMethod<void>(
        'saveAppData', encodeAppData(target ?? data));
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    if (enabled) {
      try {
        await _storageChannel
            .invokeMethod<bool>('requestNotificationPermission');
      } on PlatformException catch (exception) {
        actionError = exception.message ?? exception.code;
        notifyListeners();
        return;
      }
    }
    await save(data.copyWith(remindersEnabled: enabled));
  }

  Future<void> _scheduleReminders() async {
    final reminders = <Map<String, Object>>[];
    if (data.remindersEnabled) {
      for (final item in data.items.where((item) => item.isActive)) {
        final due = item.nextDue;
        if (item.kind != ItemKind.gold && due != null) {
          final amount = item.monthlyTotal;
          if (amount > 0) {
            reminders.add(_reminder(
              'payment-${item.id}',
              DateTime.utc(due.year, due.month, due.day, 6),
              'Payment due: ${item.name}',
              'A payment of ${_money(amount)} is due today.',
            ));
          }
        }
        if (item.kind == ItemKind.serviceContract && item.contractEnd != null) {
          final renewal =
              item.contractEnd!.subtract(Duration(days: data.renewalDays));
          reminders.add(_reminder(
            'contract-${item.id}',
            DateTime.utc(renewal.year, renewal.month, renewal.day, 6),
            'Contract renewal: ${item.name}',
            'Your contract ends ${_date(item.contractEnd)}.',
          ));
        }
      }
      for (final service in data.services) {
        if (service.reminder != null &&
            service.status != VehicleServiceStatus.completed) {
          reminders.add(_reminder(
            'service-${service.id}',
            DateTime.utc(service.reminder!.year, service.reminder!.month,
                service.reminder!.day, 6),
            'Vehicle service: ${service.title}',
            'A vehicle service is scheduled for ${_date(service.reminder)}.',
          ));
        }
      }
    }
    try {
      await _storageChannel.invokeMethod<void>('scheduleReminders', reminders);
    } on PlatformException catch (exception) {
      actionError = exception.message ?? exception.code;
    }
  }

  Map<String, Object> _reminder(
          String key, DateTime at, String title, String message) =>
      {
        'id': _stableReminderId(key),
        'at': at.millisecondsSinceEpoch,
        'title': title,
        'message': message,
      };

  int _stableReminderId(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash = ((hash ^ unit) * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  Future<void> refreshGoldPrice() async {
    lastGoldRefreshAttempt = DateTime.now();
    goldRefreshing = true;
    actionError = null;
    notifyListeners();
    try {
      final response =
          await _storageChannel.invokeMethod<String>('getGoldSpot');
      if (response == null) {
        throw const FormatException('Gold price response was empty.');
      }

      final decoded = jsonDecode(response);
      if (decoded is! Map<String, dynamic> || decoded['price'] is! num) {
        throw const FormatException('Gold price response was invalid.');
      }
      final usdPerOunce = (decoded['price'] as num).toDouble();
      if (!usdPerOunce.isFinite || usdPerOunce <= 0) {
        throw const FormatException('Gold spot price must be positive.');
      }
      final updated = DateTime.tryParse(decoded['updatedAt'] as String? ??
              decoded['timestamp'] as String? ??
              '') ??
          DateTime.now();
      await save(data.copyWith(
        goldPrice: usdPerOunce * 3.75 / 31.1034768,
        goldManual: false,
        goldUpdatedAt: updated,
      ));
    } on PlatformException catch (exception) {
      actionError = exception.message ?? exception.code;
    } on FormatException catch (exception) {
      actionError = exception.message;
    } finally {
      goldRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> addSavingsAccount(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty ||
        data.savingsAccounts.any(
            (account) => account.name.toLowerCase() == trimmed.toLowerCase())) {
      throw ArgumentError('Enter a unique savings account name.');
    }
    await save(data.copyWith(savingsAccounts: [
      ...data.savingsAccounts,
      SavingsAccount(
        id: _newId('savings-account'),
        name: trimmed,
        createdAt: DateTime.now(),
      ),
    ]));
  }

  Future<void> recordSavingsTransaction({
    required SavingsTransactionType type,
    required String accountId,
    required double amount,
    String? destinationAccountId,
    String note = '',
  }) async {
    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError('Enter an amount greater than zero.');
    }
    final source = data.savingsAccounts
        .where((account) => account.id == accountId)
        .firstOrNull;
    if (source == null) throw ArgumentError('Savings account was not found.');
    final destination = destinationAccountId == null
        ? null
        : data.savingsAccounts
            .where((account) => account.id == destinationAccountId)
            .firstOrNull;
    if (type == SavingsTransactionType.transfer &&
        (destination == null || destination.id == source.id)) {
      throw ArgumentError('Choose a different destination savings account.');
    }
    if (type != SavingsTransactionType.transfer &&
        destinationAccountId != null) {
      throw ArgumentError('Only account transfers have a destination account.');
    }
    if (type == SavingsTransactionType.openingBalance &&
        data.savingsTransactions.any((transaction) =>
            transaction.accountId == accountId ||
            transaction.destinationAccountId == accountId)) {
      throw ArgumentError(
          'Existing savings can only be recorded once before account activity.');
    }
    if (type == SavingsTransactionType.deposit &&
        data.salaryBalance + 0.000001 < amount) {
      throw ArgumentError(
          'Available salary balance is too low for this deposit.');
    }
    if (type == SavingsTransactionType.withdrawal ||
        type == SavingsTransactionType.transfer) {
      if (data.savingsBalance(accountId) + 0.000001 < amount) {
        throw ArgumentError('Savings account balance is too low.');
      }
    }

    final now = DateTime.now();
    final transaction = SavingsTransaction(
      id: _newId('savings-transaction'),
      type: type,
      amount: amount,
      date: now,
      accountId: accountId,
      destinationAccountId: destinationAccountId,
      note: note.trim(),
    );
    final entries = [...data.entries];
    if (type == SavingsTransactionType.deposit ||
        type == SavingsTransactionType.withdrawal) {
      final isDeposit = type == SavingsTransactionType.deposit;
      entries.add(FinanceEntry(
        id: 'savings-${transaction.id}',
        type: FinanceType.transfer,
        amount: amount,
        balanceDelta: isDeposit ? -amount : amount,
        date: now,
        description:
            '${isDeposit ? 'Deposit to' : 'Withdrawal from'} ${source.name}',
      ));
    }
    await save(data.copyWith(
      savingsTransactions: [...data.savingsTransactions, transaction],
      entries: entries,
    ));
  }

  Future<void> tradeGold({
    required GoldTradeType type,
    required double grams,
  }) async {
    final price = data.goldPrice;
    if (price == null || !price.isFinite || price <= 0) {
      throw ArgumentError('A valid gold price is required to trade.');
    }
    if (!grams.isFinite || grams <= 0) {
      throw ArgumentError('Enter a grams amount greater than zero.');
    }
    if (type == GoldTradeType.sell && grams > data.totalGoldGrams) {
      throw ArgumentError('You cannot sell more gold than is held.');
    }
    final now = DateTime.now();
    final trade = GoldTrade(
      id: _newId('gold-trade'),
      type: type,
      grams: grams,
      pricePerGram: price,
      date: now,
    );
    final purchase = type == GoldTradeType.buy;
    if (purchase && data.salaryBalance + 0.000001 < trade.total) {
      throw ArgumentError(
          'Available salary balance is too low for this purchase.');
    }
    final entries = [
      ...data.entries,
      FinanceEntry(
        id: 'gold-${trade.id}',
        type: purchase ? FinanceType.expense : FinanceType.income,
        amount: trade.total,
        balanceDelta: purchase ? -trade.total : trade.total,
        date: now,
        description: '${purchase ? 'Gold purchase' : 'Gold sale'} · $grams g',
        category: purchase ? 'Other' : null,
        itemId: 'gold-vault',
      ),
    ];
    await save(data.copyWith(
      goldTrades: [...data.goldTrades, trade],
      entries: entries,
    ));
  }

  void clearActionError() {
    actionError = null;
    notifyListeners();
  }

  void showActionError(String message) {
    actionError = message;
    notifyListeners();
  }

  Future<void> addExpense(
      String description, String category, double amount) async {
    if (description.trim().isEmpty ||
        !_categories.contains(category) ||
        !amount.isFinite ||
        amount <= 0) {
      throw ArgumentError('Expense details are invalid.');
    }
    final now = DateTime.now();
    await save(data.copyWith(entries: [
      ...data.entries,
      FinanceEntry(
        id: 'expense-${now.microsecondsSinceEpoch}',
        type: FinanceType.expense,
        amount: amount,
        balanceDelta: -amount,
        date: now,
        description: description.trim(),
        category: category,
      ),
    ]));
  }

  Future<void> setSalary(double income, int payday, double balance) async {
    if (!income.isFinite ||
        income < 0 ||
        !balance.isFinite ||
        payday < 1 ||
        payday > 31) {
      throw ArgumentError('Salary details are invalid.');
    }
    final difference = balance - data.salaryBalance;
    final entries = [...data.entries];
    if (difference.abs() > 0.000001) {
      entries.add(FinanceEntry(
        id: 'adjustment-${DateTime.now().microsecondsSinceEpoch}',
        type: FinanceType.adjustment,
        amount: difference.abs(),
        balanceDelta: difference,
        date: DateTime.now(),
        description: 'Balance adjustment',
      ));
    }
    await save(data.copyWith(
      income: income,
      payday: payday,
      nextPayday: income > 0
          ? _nextPayday(DateUtils.dateOnly(DateTime.now()), payday)
          : null,
      clearNextPayday: income == 0,
      entries: entries,
    ));
  }

  double spent(String category, DateTime month) => data.entries
      .where((entry) =>
          entry.type == FinanceType.expense &&
          entry.category == category &&
          entry.date.year == month.year &&
          entry.date.month == month.month)
      .fold(0, (sum, entry) => sum + entry.amount);
}

DateTime _nextPayday(DateTime after, int day) {
  final candidate = _dateInMonth(after.year, after.month, day);
  return candidate.isAfter(after)
      ? candidate
      : _dateInMonth(after.year, after.month + 1, day);
}

DateTime _dateInMonth(int year, int month, int day) {
  final first = DateTime(year, month, 1);
  final last = DateTime(first.year, first.month + 1, 0).day;
  return DateTime(first.year, first.month, day.clamp(1, last));
}

DateTime _addMonths(DateTime date, int months) =>
    _dateInMonth(date.year, date.month + months, date.day);

String _money(double amount) => '${amount.toStringAsFixed(2)} SAR';
String _date(DateTime? date) => date == null
    ? 'Not set'
    : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class AuraWelthApp extends StatefulWidget {
  const AuraWelthApp({super.key});
  @override
  State<AuraWelthApp> createState() => _AuraWelthAppState();
}

class _AuraWelthAppState extends State<AuraWelthApp> {
  final store = TrackerStore();
  @override
  void initState() {
    super.initState();
    unawaited(store.load());
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => MaterialApp(
          title: _appName,
          debugShowCheckedModeBanner: false,
          locale: Locale(store.data.locale),
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: switch (store.data.theme) {
            'light' => ThemeMode.light,
            'dark' => ThemeMode.dark,
            _ => ThemeMode.system,
          },
          theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF159A72)),
            scaffoldBackgroundColor: const Color(0xFFF5F7FB),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF159A72),
              brightness: Brightness.dark,
            ),
          ),
          builder: (context, child) => Directionality(
            textDirection: store.data.locale == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(_tr(context, _appName)),
                actions: [
                  IconButton(
                    tooltip: _tr(context, 'Settings'),
                    onPressed: () => _settings(context, store),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              body: !store.ready
                  ? Center(
                      child: store.error == null
                          ? const CircularProgressIndicator()
                          : _LoadError(
                              error: store.error!,
                              retry: () => unawaited(store.load()),
                            ),
                    )
                  : _Home(store: store),
            ),
          ),
        ),
      );
}

class _Home extends StatefulWidget {
  const _Home({required this.store});
  final TrackerStore store;
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> with WidgetsBindingObserver {
  int tab = 0;
  Timer? _goldRefreshTimer;
  TrackerStore get store => widget.store;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    store.addListener(_refreshGoldQuoteIfStale);
    if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      _startGoldRefreshTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startGoldRefreshTimer();
    } else {
      _goldRefreshTimer?.cancel();
      _goldRefreshTimer = null;
    }
  }

  void _startGoldRefreshTimer() {
    _goldRefreshTimer ??= Timer.periodic(
      const Duration(minutes: 5),
      (_) => _refreshGoldQuoteIfStale(force: true),
    );
    _refreshGoldQuoteIfStale();
  }

  void _refreshGoldQuoteIfStale({bool force = false}) {
    if (!store.ready || store.goldRefreshing) return;
    if (!force && store.data.goldManual) return;
    final lastAttempt = store.lastGoldRefreshAttempt;
    if (!force &&
        lastAttempt != null &&
        DateTime.now().difference(lastAttempt) < const Duration(minutes: 5)) {
      return;
    }
    final updatedAt = store.data.goldUpdatedAt;
    if (!force &&
        updatedAt != null &&
        DateTime.now().difference(updatedAt).abs() <
            const Duration(minutes: 5)) {
      return;
    }
    unawaited(store.refreshGoldPrice());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    store.removeListener(_refreshGoldQuoteIfStale);
    _goldRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _dashboard(context),
      _items(ItemKind.installment),
      _items(ItemKind.serviceContract),
      _vehicles(),
      _items(ItemKind.gold),
      _budget(context),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (store.actionError != null)
              MaterialBanner(
                content: Text(store.actionError!),
                leading: const Icon(Icons.error_outline),
                actions: [
                  TextButton(
                    onPressed: store.clearActionError,
                    child: Text(_tr(context, 'Dismiss')),
                  ),
                ],
              ),
            Expanded(child: screens[tab]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addItem(context, _kindForTab(tab)),
        icon: const Icon(Icons.add),
        label: Text(_tr(context, 'Add item')),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              label: _tr(context, 'Home')),
          NavigationDestination(
              icon: Icon(Icons.receipt_long), label: _tr(context, 'Plans')),
          NavigationDestination(
              icon: Icon(Icons.router_outlined),
              label: _tr(context, 'Contracts')),
          NavigationDestination(
              icon: Icon(Icons.directions_car),
              label: _tr(context, 'Vehicles')),
          NavigationDestination(
              icon: Icon(Icons.savings_outlined),
              label: _tr(context, 'Assets')),
          NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              label: _tr(context, 'Budget')),
        ],
      ),
    );
  }

  ItemKind _kindForTab(int index) => switch (index) {
        2 => ItemKind.serviceContract,
        3 => ItemKind.carLoan,
        4 => ItemKind.gold,
        _ => ItemKind.installment,
      };

  Widget _dashboard(BuildContext context) {
    final active = store.data.items
        .where((item) => item.isActive && item.kind != ItemKind.gold);
    final total =
        active.fold<double>(0, (sum, item) => sum + item.monthlyTotal);
    final due = active
        .where((item) =>
            item.nextDue != null &&
            !DateUtils.dateOnly(item.nextDue!)
                .isAfter(DateUtils.dateOnly(DateTime.now())))
        .toList();
    final balance = store.data.salaryBalance;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _metric(_tr(context, 'Monthly salary'), _money(store.data.income)),
        _metric(_tr(context, 'Available salary balance'), _money(balance)),
        _metric(_tr(context, 'Monthly plans and contracts'), _money(total)),
        _metric(
          _tr(context, 'Gold value'),
          _money(store.data.totalGoldGrams * (store.data.goldPrice ?? 0)),
        ),
        if (store.data.entries
            .any((entry) => entry.type == FinanceType.shortfall))
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              leading: const Icon(Icons.warning_amber),
              title: Text(_tr(context, 'Payment shortfalls need attention')),
              subtitle: Text(
                '${store.data.entries.where((entry) => entry.type == FinanceType.shortfall).length} payment(s) were deferred because the available balance was insufficient.',
              ),
            ),
          ),
        Card(
          child: ListTile(
            title: Text(due.isEmpty
                ? _tr(context, 'No payments due today')
                : '${due.length} ${_tr(context, 'payments need attention')}'),
            subtitle:
                Text(_tr(context, 'Local finance tracker · amounts in SAR')),
            leading: Icon(due.isEmpty
                ? Icons.check_circle_outline
                : Icons.notifications_active_outlined),
          ),
        ),
        FilledButton.icon(
          onPressed: () => _salaryDialog(context),
          icon: const Icon(Icons.payments_outlined),
          label: Text(_tr(context, 'Set salary and balance')),
        ),
        OutlinedButton.icon(
          onPressed: () => _expenseDialog(context),
          icon: const Icon(Icons.add_shopping_cart),
          label: Text(_tr(context, 'Add expense')),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: Text(_tr(context, 'Finance analysis')),
            subtitle: Text(_tr(context, 'Monthly cash flow')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => _AnalyticsScreen(store: store),
            )),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.savings_outlined),
            title: Text(_tr(context, 'Savings accounts')),
            subtitle: Text(
                '${store.data.savingsAccounts.length} · ${_money(store.data.savingsAccounts.fold<double>(0, (sum, account) => sum + store.data.savingsBalance(account.id)))}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => _SavingsScreen(store: store),
            )),
          ),
        ),
        if (due.isNotEmpty)
          for (final item in due)
            Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                    'Due ${_date(item.nextDue)} · ${_money(item.monthlyTotal)}'),
                trailing: TextButton(
                  onPressed: () => _markPaid(item),
                  child: Text(_tr(context, 'Mark paid')),
                ),
              ),
            ),
        const Divider(),
        Text(_tr(context, 'Recent finance activity'),
            style: Theme.of(context).textTheme.titleMedium),
        for (final entry in store.data.entries.reversed.take(5))
          ListTile(
            title: Text(entry.description),
            subtitle: Text('${entry.type.name} · ${_date(entry.date)}'),
            trailing: Text(
              '${entry.balanceDelta > 0 ? '+' : ''}${_money(entry.balanceDelta)}',
            ),
          ),
        TextButton.icon(
          onPressed: () => _financeLedgerDialog(context),
          icon: const Icon(Icons.receipt_long),
          label: Text(_tr(context, 'View full finance ledger')),
        ),
      ],
    );
  }

  Widget _metric(String label, String value) => Card(
        child: ListTile(title: Text(label), trailing: Text(value)),
      );

  Widget _goldVaultCard(BuildContext context) {
    final price = store.data.goldPrice ?? 0;
    final grams = store.data.totalGoldGrams;
    final quoteAt = store.data.goldUpdatedAt;
    final isLive = !store.data.goldManual &&
        quoteAt != null &&
        DateTime.now().difference(quoteAt).abs() <= const Duration(minutes: 6);
    final quoteStatus = store.data.goldManual
        ? _tr(context, 'manual')
        : isLive
            ? _tr(context, 'Live price')
            : _tr(context, 'Cached price');
    final foreground = Theme.of(context).colorScheme.onPrimaryContainer;
    return Card(
      color: const Color(0xFF111827),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _tr(context, 'Gold Vault (Live Internet 24K)'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFFBBF24),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                IconButton(
                  tooltip: _tr(context, 'Refresh'),
                  onPressed: store.goldRefreshing
                      ? null
                      : () => unawaited(store.refreshGoldPrice()),
                  color: Colors.white70,
                  icon: store.goldRefreshing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: _tr(context, 'Set gold price manually'),
                  onPressed: () => _goldPriceDialog(context),
                  color: Colors.white70,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        grams.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(_tr(context, 'Grams'),
                            style: const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_tr(context, quoteStatus)} · ${_money(price)}/g',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    if (quoteAt != null)
                      Text(
                        '${_tr(context, 'Last update')}: ${_date(quoteAt)}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 11),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${_money(grams * price)} SAR',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: price > 0
                        ? () => _goldTradeDialog(GoldTradeType.sell)
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: foreground,
                      side: const BorderSide(color: Colors.white30),
                    ),
                    child: Text(_tr(context, 'Sell')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: price > 0
                        ? () => _goldTradeDialog(GoldTradeType.buy)
                        : null,
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black),
                    child: Text(_tr(context, 'Buy')),
                  ),
                ),
              ],
            ),
            if (store.data.goldTrades.isNotEmpty) ...[
              const Divider(color: Colors.white24, height: 26),
              Text(_tr(context, 'Gold transaction history'),
                  style: const TextStyle(color: Colors.white70)),
              for (final trade in store.data.goldTrades.reversed)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${_tr(context, trade.type.name)} · ${trade.grams.toStringAsFixed(2)} g',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                      '${_date(trade.date)} · ${_money(trade.pricePerGram)}/g',
                      style: const TextStyle(color: Colors.white60)),
                  trailing: Text(_money(trade.total),
                      style: const TextStyle(color: Colors.white)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _goldTradeDialog(GoldTradeType type) async {
    final grams = await showDialog<double>(
      context: context,
      builder: (context) => _GoldTradeDialog(
        type: type,
        pricePerGram: store.data.goldPrice!,
        availableGrams: store.data.totalGoldGrams,
        availableCash: store.data.salaryBalance,
      ),
    );
    if (grams != null) {
      try {
        await store.tradeGold(type: type, grams: grams);
      } on ArgumentError catch (error) {
        store.showActionError(error.message.toString());
      }
    }
  }

  Widget _items(ItemKind kind) {
    final items = store.data.items
        .where((item) => switch (kind) {
              ItemKind.installment => item.kind == ItemKind.installment ||
                  item.kind == ItemKind.carLoan ||
                  item.kind == ItemKind.device,
              _ => item.kind == kind,
            })
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_tr(context, _kindTitle(kind)),
            style: Theme.of(context).textTheme.headlineSmall),
        if (kind == ItemKind.gold) _goldVaultCard(context),
        if (items.isEmpty &&
            !(kind == ItemKind.gold && store.data.goldTrades.isNotEmpty))
          Card(
              child: ListTile(
                  title: Text(
                      _tr(context, 'No items yet. Tap Add item to start.')))),
        for (final item in items)
          Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(_itemSubtitle(item)),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (choice) {
                  if (choice == 'paid') _markPaid(item);
                  if (choice == 'edit')
                    _addItem(context, item.kind, existing: item);
                  if (choice == 'remove') _removeItem(item);
                },
                itemBuilder: (context) => [
                  if (item.kind != ItemKind.gold && item.monthlyTotal > 0)
                    PopupMenuItem(
                        value: 'paid', child: Text(_tr(context, 'Mark paid'))),
                  PopupMenuItem(
                      value: 'edit', child: Text(_tr(context, 'Edit'))),
                  PopupMenuItem(
                      value: 'remove', child: Text(_tr(context, 'Remove'))),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _itemSubtitle(TrackedItem item) {
    if (item.kind == ItemKind.gold) {
      return '${item.goldGrams} g · ${_money(item.goldGrams * (store.data.goldPrice ?? 0))}';
    }
    if (item.kind == ItemKind.serviceContract) {
      final linkedDevices = store.data.items
          .where((candidate) => candidate.linkedContractId == item.id)
          .map((device) =>
              device.deviceModel.isEmpty ? device.name : device.deviceModel)
          .join(', ');
      return '${_tr(context, item.contractType)} · ${_tr(context, 'service')} ${_money(item.serviceFee)}/mo · ${item.deviceModel.isEmpty ? _tr(context, 'no device') : item.deviceModel} · device ${_money(item.devicePayment)}/mo'
          '${linkedDevices.isEmpty ? '' : ' · ${_tr(context, 'linked devices')}: $linkedDevices'}'
          ' · bills ${_date(item.nextDue)} · ends ${_date(item.contractEnd)}';
    }
    final link = item.linkedContractId == null
        ? ''
        : ' · contract ${store.data.items.where((candidate) => candidate.id == item.linkedContractId).firstOrNull?.name ?? 'unlinked'}';
    return '${_tr(context, _providerTitle(item.provider))}${item.deviceModel.isEmpty ? '' : ' · ${item.deviceModel}'}$link · ${_money(item.payment)}/mo · balance ${_money(item.balance)} · ${item.remainingMonths} months · ${_tr(context, 'Started')} ${_date(item.startDate)} · ${_tr(context, 'Expires')} ${_date(item.expiresOn)} · due ${_date(item.nextDue)}';
  }

  Widget _vehicles() {
    final cars =
        store.data.items.where((item) => item.kind == ItemKind.carLoan);
    final services = store.data.services;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_tr(context, 'Vehicle services'),
            style: Theme.of(context).textTheme.headlineSmall),
        for (final car in cars)
          Card(
            child: ExpansionTile(
              title: Text(car.name),
              subtitle: Text(_itemSubtitle(car)),
              children: [
                for (final service in services.where((s) => s.carId == car.id))
                  ListTile(
                    title: Text(service.title),
                    subtitle: Text(
                      '${_tr(context, service.status.name)} · fee ${_money(service.fee)}'
                      '${service.reminder == null ? '' : ' · reminder ${_date(service.reminder)}'}'
                      '${service.notes.isEmpty ? '' : ' · ${service.notes}'}',
                    ),
                    trailing: PopupMenuButton<VehicleServiceStatus>(
                      onSelected: (status) => _updateService(service, status),
                      itemBuilder: (context) => VehicleServiceStatus.values
                          .map((status) => PopupMenuItem(
                              value: status, child: Text(status.name)))
                          .toList(),
                    ),
                  ),
                TextButton.icon(
                  onPressed: () => _serviceDialog(context, car),
                  icon: const Icon(Icons.add),
                  label: Text(_tr(context, 'Add service or request')),
                ),
              ],
            ),
          ),
        if (cars.isEmpty)
          Card(
              child: ListTile(
                  title: Text(_tr(
                      context, 'Add a car loan to manage vehicle services.')))),
      ],
    );
  }

  Widget _budget(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_tr(context, 'Budgets and spending'),
              style: Theme.of(context).textTheme.headlineSmall),
          for (final category in _categories)
            Builder(builder: (context) {
              final budget =
                  store.data.budgets.where((b) => b.category == category);
              final limit = budget.isEmpty ? 0.0 : budget.first.limit;
              final currentMonth = DateTime.now();
              final spent = store.spent(category, currentMonth);
              final lastMonth =
                  DateTime(currentMonth.year, currentMonth.month - 1);
              final previousSpent = store.spent(category, lastMonth);
              return Card(
                child: ListTile(
                  title: Text(_tr(context, category)),
                  subtitle: Text(
                      '${_tr(context, 'Spent')} ${_money(spent)} · ${_tr(context, 'last month')} ${_money(previousSpent)} · ${_tr(context, 'budget')} ${limit == 0 ? _tr(context, 'not set') : _money(limit)}'),
                  trailing: limit > 0
                      ? SizedBox(
                          width: 52,
                          child: CircularProgressIndicator(
                            value: (spent / limit).clamp(0, 1).toDouble(),
                            color: spent > limit
                                ? Theme.of(context).colorScheme.error
                                : null,
                            semanticsLabel: 'Budget used',
                          ),
                        )
                      : IconButton(
                          tooltip: _tr(context, 'Set budget'),
                          onPressed: () => _budgetDialog(context, category),
                          icon: const Icon(Icons.edit),
                        ),
                ),
              );
            }),
          const Divider(),
          for (final expense in store.data.entries
              .where((e) => e.type == FinanceType.expense)
              .toList()
              .reversed)
            ListTile(
              title: Text(expense.description),
              subtitle: Text(
                  '${_tr(context, expense.category ?? 'Other')} · ${_date(expense.date)}'),
              trailing: Text(_money(expense.amount)),
            ),
        ],
      );

  Future<void> _addItem(BuildContext context, ItemKind kind,
      {TrackedItem? existing}) async {
    final item = await showDialog<TrackedItem>(
      context: context,
      builder: (context) => _ItemDialog(
        kind: kind,
        existing: existing,
        goldPrice: store.data.goldPrice,
        contracts: store.data.items
            .where((item) => item.kind == ItemKind.serviceContract)
            .toList(),
      ),
    );
    if (item == null) return;
    final items = [...store.data.items.where((old) => old.id != item.id), item];
    await store.save(store.data.copyWith(items: items));
  }

  Future<void> _markPaid(TrackedItem item) async {
    final amount = item.monthlyTotal;
    if (amount <= 0) return;
    final entries = [...store.data.entries];
    final updatedItems = store.data.items.map((current) {
      if (current.id != item.id) return current;
      entries.add(FinanceEntry(
        id: 'manual-${item.id}-${DateTime.now().microsecondsSinceEpoch}',
        type: FinanceType.payment,
        amount: amount,
        balanceDelta: -amount,
        date: DateTime.now(),
        description: item.name,
        itemId: item.id,
      ));
      return current.afterPayment();
    }).toList();
    await store
        .save(store.data.copyWith(items: updatedItems, entries: entries));
  }

  Future<void> _removeItem(TrackedItem item) async {
    await store.save(store.data.copyWith(
      items: store.data.items
          .where((i) => i.id != item.id && i.linkedContractId != item.id)
          .toList(),
      services: store.data.services.where((s) => s.carId != item.id).toList(),
    ));
  }

  Future<void> _salaryDialog(BuildContext context) async {
    final result = await showDialog<(double, int, double)>(
      context: context,
      builder: (context) => _SalaryDialog(data: store.data),
    );
    if (result != null) await store.setSalary(result.$1, result.$2, result.$3);
  }

  Future<void> _financeLedgerDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_tr(context, 'Finance ledger')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final entry in store.data.entries.reversed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(entry.description),
                    subtitle: Text(
                      '${_tr(context, entry.type.name)} · ${_date(entry.date)}'
                      '${entry.category == null ? '' : ' · ${_tr(context, entry.category!)}'}',
                    ),
                    trailing: Text(
                      '${entry.balanceDelta > 0 ? '+' : ''}${_money(entry.balanceDelta)}',
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Close')),
            ),
          ],
        ),
      );

  Future<void> _expenseDialog(BuildContext context) async {
    final result = await showDialog<(String, String, double)>(
      context: context,
      builder: (context) => const _ExpenseDialog(),
    );
    if (result != null) await store.addExpense(result.$1, result.$2, result.$3);
  }

  Future<void> _budgetDialog(BuildContext context, String category) async {
    final current = store.data.budgets.where((b) => b.category == category);
    final value = await _numberDialog(context, 'Monthly $category budget',
        initial: current.isEmpty ? '' : current.first.limit.toString());
    if (value == null || value <= 0) return;
    await store.save(store.data.copyWith(budgets: [
      ...store.data.budgets.where((b) => b.category != category),
      Budget(category: category, limit: value),
    ]));
  }

  Future<void> _goldPriceDialog(BuildContext context) async {
    final value = await _numberDialog(context, '24K price per gram (SAR)',
        initial: store.data.goldPrice?.toString() ?? '');
    if (value == null || value <= 0) return;
    await store.save(store.data.copyWith(
      goldPrice: value,
      goldManual: true,
      goldUpdatedAt: DateTime.now(),
    ));
  }

  Future<double?> _numberDialog(BuildContext context, String title,
      {String initial = ''}) async {
    final controller = TextEditingController(text: initial);
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr(context, title)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Cancel'))),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              Navigator.pop(
                  context, value != null && value.isFinite ? value : null);
            },
            child: Text(_tr(context, 'Save')),
          ),
        ],
      ),
    );
  }

  Future<void> _serviceDialog(BuildContext context, TrackedItem car) async {
    final service = await showDialog<VehicleService>(
      context: context,
      builder: (context) => _ServiceDialog(car: car),
    );
    if (service != null) {
      await store.save(
          store.data.copyWith(services: [...store.data.services, service]));
    }
  }

  Future<void> _updateService(
      VehicleService service, VehicleServiceStatus status) async {
    final entries = [...store.data.entries];
    final serviceEntryId = 'vehicle-service-${service.id}';
    if (status == VehicleServiceStatus.completed &&
        service.status != VehicleServiceStatus.completed &&
        service.fee > 0 &&
        !entries.any((entry) => entry.id == serviceEntryId)) {
      entries.add(FinanceEntry(
        id: serviceEntryId,
        type: FinanceType.expense,
        amount: service.fee,
        balanceDelta: -service.fee,
        date: DateTime.now(),
        description: service.title,
        category: 'Transport',
      ));
    }
    await store.save(store.data.copyWith(services: [
      for (final current in store.data.services)
        if (current.id == service.id)
          VehicleService(
            id: current.id,
            carId: current.carId,
            title: current.title,
            status: status,
            fee: current.fee,
            notes: current.notes,
            reminder: current.reminder,
          )
        else
          current,
    ], entries: entries));
  }
}

class _AnalyticsScreen extends StatelessWidget {
  const _AnalyticsScreen({required this.store});
  final TrackerStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final now = DateTime.now();
          final months = List.generate(
            6,
            (index) => DateTime(now.year, now.month - 5 + index),
          );
          final monthNames = months
              .map((month) => MaterialLocalizations.of(context)
                  .formatMonthYear(DateTime(month.year, month.month)))
              .toList();
          final cashGroups = months.map((month) {
            double total(FinanceType type) => store.data.entries
                .where((entry) =>
                    entry.type == type &&
                    entry.date.year == month.year &&
                    entry.date.month == month.month)
                .fold(0, (sum, entry) => sum + entry.amount);
            final incoming = store.data.entries
                .where((entry) =>
                    (entry.type == FinanceType.salary ||
                        entry.type == FinanceType.income) &&
                    entry.date.year == month.year &&
                    entry.date.month == month.month)
                .fold(0.0, (sum, entry) => sum + entry.amount);
            return _ChartGroup(
              monthNames[months.indexOf(month)],
              [
                incoming,
                total(FinanceType.expense),
                total(FinanceType.payment)
              ],
            );
          }).toList();
          final categories = _categories;
          final budgetGroups = categories.map((category) {
            final spent = store.data.entries
                .where((entry) =>
                    entry.type == FinanceType.expense &&
                    entry.category == category &&
                    entry.date.year == now.year &&
                    entry.date.month == now.month)
                .fold(0.0, (sum, entry) => sum + entry.amount);
            final budget = store.data.budgets
                .where((item) => item.category == category)
                .firstOrNull
                ?.limit;
            return _ChartGroup(
              _tr(context, category),
              [budget ?? 0, spent],
            );
          }).toList();
          final firstMonth = months.first;
          final hasCashFlow = store.data.entries.any((entry) =>
              !DateTime(entry.date.year, entry.date.month)
                  .isBefore(firstMonth) &&
              (entry.type == FinanceType.salary ||
                  entry.type == FinanceType.income ||
                  entry.type == FinanceType.expense ||
                  entry.type == FinanceType.payment));
          final hasBudgets = store.data.budgets.isNotEmpty;
          return Scaffold(
            appBar: AppBar(title: Text(_tr(context, 'Finance analysis'))),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(_tr(context, 'Cash flow · last 6 months'),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (!hasCashFlow)
                  _emptyAnalysis(
                      context, 'No financial activity for this period.')
                else
                  _ChartCard(
                    groups: cashGroups,
                    series: [
                      _ChartSeries(
                          _tr(context, 'Income'), const Color(0xFF16A34A)),
                      _ChartSeries(
                          _tr(context, 'Expenses'), const Color(0xFFEF4444)),
                      _ChartSeries(_tr(context, 'Installments paid'),
                          const Color(0xFF3B82F6)),
                    ],
                  ),
                const SizedBox(height: 24),
                Text(_tr(context, 'Budget vs spending · this month'),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (!hasBudgets)
                  _emptyAnalysis(context,
                      'No budgets set yet. Set category budgets to compare spending.')
                else
                  _ChartCard(
                    groups: budgetGroups,
                    series: [
                      _ChartSeries(_tr(context, 'Monthly budget'),
                          const Color(0xFF64748B)),
                      _ChartSeries(_tr(context, 'Spent amount'),
                          const Color(0xFFF59E0B)),
                    ],
                  ),
              ],
            ),
          );
        },
      );

  Widget _emptyAnalysis(BuildContext context, String message) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(_tr(context, message)),
        ),
      );
}

class _ChartSeries {
  const _ChartSeries(this.name, this.color);
  final String name;
  final Color color;
}

class _ChartGroup {
  const _ChartGroup(this.label, this.values);
  final String label;
  final List<double> values;
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.groups, required this.series});
  final List<_ChartGroup> groups;
  final List<_ChartSeries> series;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final item in series)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(item.name, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 210,
                width: double.infinity,
                child: CustomPaint(
                  painter: _GroupedBarChartPainter(
                    groups: groups,
                    series: series,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    gridColor: Theme.of(context).dividerColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _GroupedBarChartPainter extends CustomPainter {
  const _GroupedBarChartPainter({
    required this.groups,
    required this.series,
    required this.textColor,
    required this.gridColor,
  });

  final List<_ChartGroup> groups;
  final List<_ChartSeries> series;
  final Color textColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 44.0;
    const right = 6.0;
    const top = 8.0;
    const bottom = 35.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;
    final maxValue = groups
        .expand((group) => group.values)
        .fold<double>(0, (maximum, value) => value > maximum ? value : maximum);
    final scaleMax = maxValue <= 0 ? 1.0 : maxValue * 1.15;
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    final axisText = TextStyle(color: textColor, fontSize: 9);
    for (var line = 0; line <= 4; line++) {
      final y = top + chartHeight * line / 4;
      canvas.drawLine(
          Offset(left, y), Offset(size.width - right, y), gridPaint);
      final value = scaleMax * (4 - line) / 4;
      _drawLabel(canvas, _shortValue(value), Offset(0, y - 6), axisText,
          maxWidth: left - 5, alignRight: true);
    }
    if (groups.isEmpty || series.isEmpty) return;
    final groupWidth = chartWidth / groups.length;
    final barWidth = (groupWidth * 0.68 / series.length).clamp(3.0, 24.0);
    for (var groupIndex = 0; groupIndex < groups.length; groupIndex++) {
      final group = groups[groupIndex];
      final groupCenter = left + groupWidth * (groupIndex + 0.5);
      for (var seriesIndex = 0;
          seriesIndex < series.length && seriesIndex < group.values.length;
          seriesIndex++) {
        final value = group.values[seriesIndex];
        final barHeight = chartHeight * value / scaleMax;
        final x = groupCenter +
            (seriesIndex - (series.length - 1) / 2) * barWidth -
            barWidth / 2;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, top + chartHeight - barHeight, barWidth,
                barHeight.clamp(0, chartHeight)),
            const Radius.circular(3),
          ),
          Paint()..color = series[seriesIndex].color,
        );
      }
      _drawLabel(
        canvas,
        group.label,
        Offset(groupCenter - groupWidth / 2, top + chartHeight + 8),
        axisText,
        maxWidth: groupWidth,
      );
    }
  }

  String _shortValue(double value) => value >= 1000000
      ? '${(value / 1000000).toStringAsFixed(1)}m'
      : value >= 1000
          ? '${(value / 1000).toStringAsFixed(0)}k'
          : value.toStringAsFixed(0);

  void _drawLabel(
    Canvas canvas,
    String label,
    Offset offset,
    TextStyle style, {
    required double maxWidth,
    bool alignRight = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
      textAlign: alignRight ? TextAlign.right : TextAlign.center,
    )..layout(maxWidth: maxWidth);
    painter.paint(
      canvas,
      Offset(
        alignRight ? offset.dx + maxWidth - painter.width : offset.dx,
        offset.dy,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _GroupedBarChartPainter oldDelegate) =>
      oldDelegate.groups != groups ||
      oldDelegate.series != series ||
      oldDelegate.textColor != textColor ||
      oldDelegate.gridColor != gridColor;
}

class _SavingsScreen extends StatefulWidget {
  const _SavingsScreen({required this.store});
  final TrackerStore store;

  @override
  State<_SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<_SavingsScreen> {
  TrackerStore get store => widget.store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(_tr(context, 'Savings accounts'))),
          body: Column(
            children: [
              if (store.actionError != null)
                MaterialBanner(
                  content: Text(store.actionError!),
                  actions: [
                    TextButton(
                      onPressed: store.clearActionError,
                      child: Text(_tr(context, 'Dismiss')),
                    ),
                  ],
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _metric(
                      _tr(context, 'Savings account balance'),
                      _money(store.data.savingsAccounts.fold<double>(
                        0,
                        (sum, account) =>
                            sum + store.data.savingsBalance(account.id),
                      )),
                    ),
                    FilledButton.icon(
                      onPressed: _addAccount,
                      icon: const Icon(Icons.add),
                      label: Text(_tr(context, 'Add account')),
                    ),
                    if (store.data.savingsAccounts.isEmpty)
                      Card(
                        child: ListTile(
                          title: Text(_tr(context, 'No savings accounts yet.')),
                        ),
                      ),
                    for (final account in store.data.savingsAccounts)
                      Card(
                        child: ExpansionTile(
                          title: Text(account.name),
                          subtitle: Text(
                              _money(store.data.savingsBalance(account.id))),
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                if (!store.data.savingsTransactions.any(
                                  (transaction) =>
                                      transaction.accountId == account.id ||
                                      transaction.destinationAccountId ==
                                          account.id,
                                ))
                                  TextButton.icon(
                                    onPressed: () => _addTransaction(
                                      account,
                                      SavingsTransactionType.openingBalance,
                                    ),
                                    icon: const Icon(Icons.account_balance),
                                    label: Text(
                                        _tr(context, 'Add existing savings')),
                                  ),
                                TextButton.icon(
                                  onPressed: () => _addTransaction(
                                    account,
                                    SavingsTransactionType.deposit,
                                  ),
                                  icon: const Icon(Icons.south_west),
                                  label: Text(_tr(context, 'Deposit')),
                                ),
                                TextButton.icon(
                                  onPressed: () => _addTransaction(
                                    account,
                                    SavingsTransactionType.withdrawal,
                                  ),
                                  icon: const Icon(Icons.north_east),
                                  label: Text(_tr(context, 'Withdraw')),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      store.data.savingsAccounts.length < 2
                                          ? null
                                          : () => _addTransaction(
                                                account,
                                                SavingsTransactionType.transfer,
                                              ),
                                  icon: const Icon(Icons.swap_horiz),
                                  label: Text(_tr(context, 'Transfer')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    if (store.data.savingsTransactions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(_tr(context, 'Transaction history'),
                          style: Theme.of(context).textTheme.titleLarge),
                      for (final transaction
                          in store.data.savingsTransactions.reversed)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${_tr(context, transaction.type.name)} · ${_money(transaction.amount)}',
                          ),
                          subtitle: Text(
                            '${store.data.savingsAccounts.where((account) => account.id == transaction.accountId).firstOrNull?.name ?? ''}'
                            '${transaction.destinationAccountId == null ? '' : ' → ${store.data.savingsAccounts.where((account) => account.id == transaction.destinationAccountId).firstOrNull?.name ?? ''}'}'
                            ' · ${_date(transaction.date)}'
                            '${transaction.note.isEmpty ? '' : ' · ${transaction.note}'}',
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _metric(String label, String value) =>
      Card(child: ListTile(title: Text(label), trailing: Text(value)));

  Future<void> _addAccount() async {
    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _SavingsAccountDialog(),
    );
    if (name == null) return;
    try {
      await store.addSavingsAccount(name);
    } on ArgumentError catch (error) {
      store.showActionError(error.message.toString());
    }
  }

  Future<void> _addTransaction(
    SavingsAccount account,
    SavingsTransactionType type,
  ) async {
    final result = await showDialog<_SavingsAction>(
      context: context,
      builder: (context) => _SavingsTransactionDialog(
        account: account,
        accounts: store.data.savingsAccounts,
        type: type,
      ),
    );
    if (result == null) return;
    try {
      await store.recordSavingsTransaction(
        type: type,
        accountId: result.accountId,
        destinationAccountId: result.destinationAccountId,
        amount: result.amount,
        note: result.note,
      );
    } on ArgumentError catch (error) {
      store.showActionError(error.message.toString());
    }
  }
}

class _SavingsAccountDialog extends StatefulWidget {
  const _SavingsAccountDialog();

  @override
  State<_SavingsAccountDialog> createState() => _SavingsAccountDialogState();
}

class _SavingsAccountDialogState extends State<_SavingsAccountDialog> {
  final name = TextEditingController();
  String? error;

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(_tr(context, 'Create savings account')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration:
                  InputDecoration(labelText: _tr(context, 'Account name')),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() => error = null),
            ),
            if (error != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  _tr(context, error!),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_tr(context, 'Cancel')),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = name.text.trim();
              if (trimmed.isEmpty) {
                setState(() => error = 'Enter a unique savings account name.');
                return;
              }
              Navigator.pop(context, trimmed);
            },
            child: Text(_tr(context, 'Add account')),
          ),
        ],
      );
}

typedef _SavingsAction = ({
  String accountId,
  String? destinationAccountId,
  double amount,
  String note,
});

class _SavingsTransactionDialog extends StatefulWidget {
  const _SavingsTransactionDialog({
    required this.account,
    required this.accounts,
    required this.type,
  });

  final SavingsAccount account;
  final List<SavingsAccount> accounts;
  final SavingsTransactionType type;

  @override
  State<_SavingsTransactionDialog> createState() =>
      _SavingsTransactionDialogState();
}

class _SavingsTransactionDialogState extends State<_SavingsTransactionDialog> {
  final amount = TextEditingController();
  final note = TextEditingController();
  String? destinationId;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTransfer = widget.type == SavingsTransactionType.transfer;
    final label = switch (widget.type) {
      SavingsTransactionType.openingBalance => 'Add existing savings',
      SavingsTransactionType.deposit => 'Deposit',
      SavingsTransactionType.withdrawal => 'Withdraw',
      SavingsTransactionType.transfer => 'Transfer',
    };
    final destinations = widget.accounts
        .where((account) => account.id != widget.account.id)
        .toList();
    destinationId ??= destinations.firstOrNull?.id;
    return AlertDialog(
      title: Text('${_tr(context, label)} · ${widget.account.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amount,
              decoration:
                  InputDecoration(labelText: _tr(context, 'Amount (SAR)')),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() => error = null),
            ),
            if (isTransfer)
              DropdownButtonFormField<String>(
                initialValue: destinationId,
                decoration:
                    InputDecoration(labelText: _tr(context, 'To account')),
                items: destinations
                    .map((account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => destinationId = value),
              ),
            TextField(
              controller: note,
              decoration:
                  InputDecoration(labelText: _tr(context, 'Note (optional)')),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_tr(context, 'Cancel')),
        ),
        FilledButton(
          onPressed: () {
            final parsed = double.tryParse(amount.text);
            if (parsed == null || !parsed.isFinite || parsed <= 0) {
              setState(() => error = 'Enter an amount greater than zero.');
              return;
            }
            if (isTransfer && destinationId == null) {
              setState(() => error = 'Choose a destination account.');
              return;
            }
            Navigator.pop(
              context,
              (
                accountId: widget.account.id,
                destinationAccountId: destinationId,
                amount: parsed,
                note: note.text.trim(),
              ),
            );
          },
          child: Text(_tr(context, 'Save transaction')),
        ),
      ],
    );
  }
}

class _GoldTradeDialog extends StatefulWidget {
  const _GoldTradeDialog({
    required this.type,
    required this.pricePerGram,
    required this.availableGrams,
    required this.availableCash,
  });

  final GoldTradeType type;
  final double pricePerGram;
  final double availableGrams;
  final double availableCash;

  @override
  State<_GoldTradeDialog> createState() => _GoldTradeDialogState();
}

class _GoldTradeDialogState extends State<_GoldTradeDialog> {
  final grams = TextEditingController();
  String? error;

  @override
  void dispose() {
    grams.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = widget.type == GoldTradeType.buy;
    final enteredGrams = double.tryParse(grams.text) ?? 0;
    final total = enteredGrams * widget.pricePerGram;
    return AlertDialog(
      title: Text(_tr(context, isBuy ? 'Buy' : 'Sell')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: grams,
            decoration: InputDecoration(labelText: _tr(context, 'Enter grams')),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() => error = null),
          ),
          const SizedBox(height: 8),
          Text('${_money(widget.pricePerGram)}/g · ${_money(total)}'),
          if (isBuy)
            Text(
                '${_tr(context, 'Available cash')}: ${_money(widget.availableCash)}'),
          if (!isBuy)
            Text(
                '${_tr(context, 'Total held')}: ${widget.availableGrams.toStringAsFixed(2)} g'),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _tr(context, error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_tr(context, 'Cancel')),
        ),
        FilledButton(
          onPressed: () {
            if (!enteredGrams.isFinite || enteredGrams <= 0) {
              setState(() => error = 'Enter grams greater than zero.');
              return;
            }
            if (!isBuy && enteredGrams > widget.availableGrams) {
              setState(() => error = 'You cannot sell more gold than is held.');
              return;
            }
            if (isBuy && total > widget.availableCash) {
              setState(() => error =
                  'Available salary balance is too low for this purchase.');
              return;
            }
            Navigator.pop(context, enteredGrams);
          },
          child: Text(_tr(context, isBuy ? 'Buy' : 'Sell')),
        ),
      ],
    );
  }
}

String _kindTitle(ItemKind kind) => switch (kind) {
      ItemKind.installment => 'Plans and installments',
      ItemKind.carLoan => 'Car loans',
      ItemKind.serviceContract => 'Service contracts',
      ItemKind.device => 'Device installments',
      ItemKind.gold => 'Gold assets',
    };

String _providerTitle(Provider provider) => switch (provider) {
      Provider.tabby => 'Tabby',
      Provider.tamara => 'Tamara',
      Provider.snbFlex => 'SNB FLEX',
      Provider.bird => 'BIRD',
      Provider.other => 'Other',
      Provider.carLoan => 'CarLoan',
      Provider.device => 'Device',
    };

Future<void> _settings(BuildContext context, TrackerStore store) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(_tr(context, 'Settings'))),
          SwitchListTile(
            title: Text(_tr(context, 'Payment reminders')),
            value: store.data.remindersEnabled,
            onChanged: store.setRemindersEnabled,
          ),
          ListTile(
            title: Text(_tr(context, 'Contract reminder days')),
            subtitle: Text(
                '${store.data.renewalDays} ${_tr(context, 'days before end date')}'),
            trailing: DropdownButton<int>(
              value: store.data.renewalDays,
              items: const [7, 14, 30]
                  .map((day) =>
                      DropdownMenuItem(value: day, child: Text('$day')))
                  .toList(),
              onChanged: (value) {
                if (value != null)
                  store.save(store.data.copyWith(renewalDays: value));
              },
            ),
          ),
          ListTile(
            title: Text(_tr(context, 'Language')),
            trailing: DropdownButton<String>(
              value: store.data.locale,
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value != null)
                  store.save(store.data.copyWith(locale: value));
              },
            ),
          ),
          ListTile(
            title: Text(_tr(context, 'Appearance')),
            trailing: DropdownButton<String>(
              value: store.data.theme,
              items: [
                DropdownMenuItem(
                    value: 'system', child: Text(_tr(context, 'System'))),
                DropdownMenuItem(
                    value: 'light', child: Text(_tr(context, 'Light'))),
                DropdownMenuItem(
                    value: 'dark', child: Text(_tr(context, 'Dark'))),
              ],
              onChanged: (value) {
                if (value != null)
                  store.save(store.data.copyWith(theme: value));
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _ItemDialog extends StatefulWidget {
  const _ItemDialog({
    required this.kind,
    required this.contracts,
    this.existing,
    this.goldPrice,
  });
  final ItemKind kind;
  final TrackedItem? existing;
  final double? goldPrice;
  final List<TrackedItem> contracts;
  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  late final name = TextEditingController(text: widget.existing?.name ?? '');
  late final payment =
      TextEditingController(text: widget.existing?.payment.toString() ?? '');
  late final balance =
      TextEditingController(text: widget.existing?.balance.toString() ?? '');
  late final months = TextEditingController(
      text: widget.existing?.remainingMonths.toString() ?? '12');
  late final grams =
      TextEditingController(text: widget.existing?.goldGrams.toString() ?? '');
  late final service =
      TextEditingController(text: widget.existing?.serviceFee.toString() ?? '');
  late final device = TextEditingController(
      text: widget.existing?.devicePayment.toString() ?? '');
  late final deviceBalance = TextEditingController(
      text: widget.existing?.deviceBalance.toString() ?? '');
  late final deviceModel =
      TextEditingController(text: widget.existing?.deviceModel ?? '');
  Provider provider = Provider.other;
  DateTime due = _addMonths(DateUtils.dateOnly(DateTime.now()), 1);
  DateTime? contractEnd;
  String contractType = 'Mobile';
  String? linkedContractId;
  String? formError;
  late DateTime startDate;
  DateTime? expiresOn;

  @override
  void initState() {
    super.initState();
    provider = widget.existing?.provider ?? _providerFor(widget.kind);
    due = widget.existing?.nextDue ??
        _addMonths(DateUtils.dateOnly(DateTime.now()), 1);
    startDate =
        widget.existing?.startDate ?? DateUtils.dateOnly(DateTime.now());
    expiresOn = widget.existing?.expiresOn ??
        (widget.kind == ItemKind.serviceContract || widget.kind == ItemKind.gold
            ? null
            : _addMonths(
                startDate, widget.existing?.termMonths ?? _int(months)));
    contractEnd = widget.existing?.contractEnd;
    contractType = widget.existing?.contractType ?? 'Mobile';
    linkedContractId = widget.existing?.linkedContractId;
    if (widget.existing == null && provider == Provider.snbFlex) {
      months.text = '4';
    }
    if (provider == Provider.snbFlex) {
      payment.text = (_value(balance) / _snbPaymentPeriods).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      name,
      payment,
      balance,
      months,
      grams,
      service,
      device,
      deviceBalance,
      deviceModel,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double _value(TextEditingController controller) =>
      double.tryParse(controller.text) ?? 0;
  int _int(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  int get _snbPaymentPeriods => _int(months) > 0 ? _int(months) : 4;

  bool get _hasOptionalProviderTerm =>
      provider == Provider.tabby || provider == Provider.tamara;

  List<Provider> get _providers => switch (widget.kind) {
        ItemKind.carLoan => const [Provider.carLoan],
        ItemKind.device => const [Provider.device],
        _ => const [
            Provider.tabby,
            Provider.tamara,
            Provider.snbFlex,
            Provider.bird,
            Provider.other,
          ],
      };

  bool _isValid() {
    final nameIsValid = name.text.trim().isNotEmpty;
    final gramsValue = _value(grams);
    final serviceValue = _value(service);
    final devicePaymentValue = _value(device);
    final deviceBalanceValue = _value(deviceBalance);
    final balanceValue = _value(balance);
    final paymentValue = provider == Provider.snbFlex
        ? balanceValue / _snbPaymentPeriods
        : _value(payment);
    final term = _int(months);
    final minimumTerm =
        _hasOptionalProviderTerm && widget.existing == null ? 2 : 1;
    final maximumTerm = _hasOptionalProviderTerm ? 24 : 120;
    final validTerm = provider == Provider.snbFlex
        ? widget.existing == null
            ? term == 4
            : term >= 1 && term <= 4
        : term >= minimumTerm && term <= maximumTerm;
    final validMoney = [
      gramsValue,
      serviceValue,
      devicePaymentValue,
      deviceBalanceValue,
      balanceValue,
      paymentValue,
    ].every((value) => value.isFinite && value >= 0);

    if (!nameIsValid) {
      formError = 'Enter a name.';
    } else if (!validMoney) {
      formError = 'Amounts must be valid non-negative numbers.';
    } else if (widget.kind == ItemKind.gold && gramsValue <= 0) {
      formError = 'Gold weight must be greater than zero.';
    } else if (widget.kind == ItemKind.serviceContract &&
        serviceValue <= 0 &&
        deviceBalanceValue <= 0) {
      formError = 'Add a service fee or a bundled device balance.';
    } else if (widget.kind == ItemKind.serviceContract &&
        deviceBalanceValue > 0 &&
        (devicePaymentValue <= 0 || _int(months) < 1 || _int(months) > 120)) {
      formError = 'A bundled device balance needs a monthly payment.';
    } else if (widget.kind == ItemKind.serviceContract &&
        deviceBalanceValue == 0 &&
        devicePaymentValue > 0) {
      formError = 'A bundled device payment needs a remaining balance.';
    } else if (widget.kind != ItemKind.gold &&
        widget.kind != ItemKind.serviceContract &&
        (balanceValue <= 0 || paymentValue <= 0 || !validTerm)) {
      formError = provider == Provider.snbFlex
          ? 'SNB FLEX plans must be four months.'
          : _hasOptionalProviderTerm
              ? 'Tabby and Tamara plans must be 2–24 months.'
              : 'Enter a positive balance, payment, and term (1–120 months).';
    } else if (widget.kind != ItemKind.gold &&
        widget.kind != ItemKind.serviceContract &&
        expiresOn == null) {
      formError = 'Choose an expiration date.';
    } else if (widget.kind != ItemKind.gold &&
        widget.kind != ItemKind.serviceContract &&
        DateUtils.dateOnly(expiresOn!)
            .isBefore(DateUtils.dateOnly(startDate))) {
      formError = 'Expiration date cannot be before the start date.';
    } else {
      formError = null;
    }
    return formError == null;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null
            ? '${_tr(context, 'Add')} ${_tr(context, _kindTitle(widget.kind))}'
            : 'Edit ${widget.existing!.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: _tr(context, 'Name'))),
              if (widget.kind != ItemKind.gold &&
                  widget.kind != ItemKind.serviceContract) ...[
                DropdownButtonFormField<Provider>(
                  initialValue: provider,
                  decoration:
                      InputDecoration(labelText: _tr(context, 'Provider')),
                  items: _providers
                      .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(_tr(context, _providerTitle(p)))))
                      .toList(),
                  onChanged: (value) => setState(() {
                    final previousProvider = provider;
                    provider = value ?? provider;
                    if (provider == Provider.snbFlex) {
                      if (widget.existing == null) months.text = '4';
                      payment.text = (_value(balance) / _snbPaymentPeriods)
                          .toStringAsFixed(2);
                    } else if (previousProvider == Provider.snbFlex &&
                        widget.existing == null) {
                      months.text = '4';
                    }
                  }),
                ),
                _field(payment, 'Monthly payment (SAR)',
                    readOnly: provider == Provider.snbFlex),
                _field(balance, 'Remaining balance (SAR)',
                    onChanged: provider == Provider.snbFlex
                        ? (value) {
                            final amount = double.tryParse(value);
                            payment.text = amount == null
                                ? ''
                                : (amount / _snbPaymentPeriods)
                                    .toStringAsFixed(2);
                          }
                        : null),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${_tr(context, 'Record only the current unpaid balance for a plan. Previous paid installments are not counted again.')} '
                    '${_tr(context, 'Set the next payment date to the next unpaid installment.')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                _field(
                  months,
                  _hasOptionalProviderTerm
                      ? 'Remaining months (2–24)'
                      : provider == Provider.snbFlex
                          ? 'SNB FLEX remaining months'
                          : 'Remaining months (1–120)',
                  numeric: true,
                  readOnly: provider == Provider.snbFlex,
                ),
                if (provider == Provider.snbFlex)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_tr(context,
                        'SNB FLEX is fixed to four monthly payments.')),
                  ),
                ListTile(
                    title:
                        Text('${_tr(context, 'Next payment')}: ${_date(due)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                          context: context,
                          initialDate: due,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (picked != null) setState(() => due = picked);
                    }),
                ListTile(
                  title:
                      Text('${_tr(context, 'Started')}: ${_date(startDate)}'),
                  trailing: const Icon(Icons.event_available),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                ),
                ListTile(
                  title:
                      Text('${_tr(context, 'Expires')}: ${_date(expiresOn)}'),
                  trailing: IconButton(
                    tooltip: _tr(context, 'Choose expiration date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            expiresOn ?? _addMonths(startDate, _int(months)),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => expiresOn = picked);
                    },
                    icon: const Icon(Icons.event_busy),
                  ),
                ),
              ],
              if (widget.kind == ItemKind.serviceContract) ...[
                DropdownButtonFormField<String>(
                  initialValue: contractType,
                  decoration:
                      InputDecoration(labelText: _tr(context, 'Contract type')),
                  items: ['Mobile', 'Internet', 'Insurance', 'Other']
                      .map((type) => DropdownMenuItem(
                          value: type, child: Text(_tr(context, type))))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => contractType = value ?? contractType),
                ),
                _field(service, 'Monthly service fee (SAR)'),
                _field(deviceModel, 'Bundled device model', text: true),
                _field(device, 'Bundled device payment (SAR)'),
                _field(deviceBalance, 'Bundled device balance (SAR)'),
                _field(months, 'Device months remaining', numeric: true),
                ListTile(
                  title: Text(
                      '${_tr(context, 'Next billing date')}: ${_date(due)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: due,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => due = picked);
                  },
                ),
                ListTile(
                  title: Text(
                      '${_tr(context, 'Contract end')}: ${_date(contractEnd)}'),
                  trailing: Wrap(
                    children: [
                      if (contractEnd != null)
                        IconButton(
                          tooltip: _tr(context, 'Clear contract end date'),
                          onPressed: () => setState(() => contractEnd = null),
                          icon: const Icon(Icons.clear),
                        ),
                      IconButton(
                        tooltip: _tr(context, 'Choose contract end date'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: contractEnd == null ||
                                    !DateUtils.dateOnly(contractEnd!).isBefore(
                                        DateUtils.dateOnly(DateTime.now()))
                                ? contractEnd ?? due
                                : DateUtils.dateOnly(DateTime.now()),
                            firstDate: DateUtils.dateOnly(DateTime.now()),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => contractEnd = picked);
                          }
                        },
                        icon: const Icon(Icons.event),
                      ),
                    ],
                  ),
                ),
              ],
              if (widget.kind == ItemKind.device) ...[
                _field(deviceModel, 'Device model', text: true),
                DropdownButtonFormField<String?>(
                  initialValue: linkedContractId,
                  decoration: InputDecoration(
                    labelText: _tr(context, 'Linked service contract'),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(_tr(context, 'None')),
                    ),
                    ...widget.contracts
                        .where((contract) =>
                            contract.deviceBalance <= 0 ||
                            contract.id == linkedContractId)
                        .map((contract) => DropdownMenuItem<String?>(
                              value: contract.id,
                              child: Text(contract.name),
                            )),
                  ],
                  onChanged: (value) =>
                      setState(() => linkedContractId = value),
                ),
              ],
              if (widget.kind == ItemKind.gold)
                _field(grams, 'Gold weight (grams)'),
              if (formError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _tr(context, formError!),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Cancel'))),
          FilledButton(
            onPressed: () {
              if (!_isValid()) {
                setState(() {});
                return;
              }
              final old = widget.existing;
              Navigator.pop(
                  context,
                  TrackedItem(
                    id: old?.id ??
                        DateTime.now().microsecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    kind: widget.kind,
                    provider: provider,
                    payment: provider == Provider.snbFlex
                        ? _value(balance) / _snbPaymentPeriods
                        : _value(payment),
                    balance: widget.kind == ItemKind.gold ? 0 : _value(balance),
                    remainingMonths: _int(months),
                    nextDue: due,
                    serviceFee: _value(service),
                    devicePayment: _value(device),
                    deviceBalance: _value(deviceBalance),
                    contractEnd: widget.kind == ItemKind.serviceContract
                        ? contractEnd
                        : old?.contractEnd,
                    contractType: contractType,
                    startDate: startDate,
                    expiresOn: expiresOn,
                    linkedContractId: widget.kind == ItemKind.device
                        ? linkedContractId
                        : old?.linkedContractId,
                    deviceModel: deviceModel.text.trim(),
                    goldGrams: _value(grams),
                    termMonths: _int(months),
                  ));
            },
            child: Text(_tr(context, 'Save')),
          ),
        ],
      );

  Widget _field(TextEditingController controller, String label,
          {bool numeric = false,
          bool text = false,
          bool readOnly = false,
          ValueChanged<String>? onChanged}) =>
      TextField(
        controller: controller,
        decoration: InputDecoration(labelText: _tr(context, label)),
        readOnly: readOnly,
        onChanged: onChanged,
        keyboardType: text
            ? TextInputType.text
            : numeric
                ? TextInputType.number
                : const TextInputType.numberWithOptions(decimal: true),
      );
}

Provider _providerFor(ItemKind kind) => switch (kind) {
      ItemKind.carLoan => Provider.carLoan,
      ItemKind.device => Provider.device,
      _ => Provider.other,
    };

class _SalaryDialog extends StatefulWidget {
  const _SalaryDialog({required this.data});
  final AppData data;
  @override
  State<_SalaryDialog> createState() => _SalaryDialogState();
}

class _SalaryDialogState extends State<_SalaryDialog> {
  late final income =
      TextEditingController(text: widget.data.income.toString());
  late final payday =
      TextEditingController(text: widget.data.payday.toString());
  late final balance =
      TextEditingController(text: widget.data.salaryBalance.toString());
  @override
  void dispose() {
    income.dispose();
    payday.dispose();
    balance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(_tr(context, 'Salary settings')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: income,
                decoration: InputDecoration(
                    labelText: _tr(context, 'Monthly salary (SAR)')),
                keyboardType: TextInputType.number),
            TextField(
                controller: payday,
                decoration: InputDecoration(
                    labelText: _tr(context, 'Payday (day of month)')),
                keyboardType: TextInputType.number),
            TextField(
                controller: balance,
                decoration: InputDecoration(
                    labelText: _tr(context, 'Current balance (SAR)')),
                keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Cancel'))),
          FilledButton(
              onPressed: () {
                final amount = double.tryParse(income.text) ?? double.nan;
                final day = int.tryParse(payday.text) ?? 0;
                final currentBalance =
                    double.tryParse(balance.text) ?? double.nan;
                if (amount.isFinite &&
                    amount >= 0 &&
                    currentBalance.isFinite &&
                    day >= 1 &&
                    day <= 31) {
                  Navigator.pop(context, (amount, day, currentBalance));
                }
              },
              child: Text(_tr(context, 'Save'))),
        ],
      );
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog();
  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  final description = TextEditingController();
  final amount = TextEditingController();
  String category = _categories.first;
  @override
  void dispose() {
    description.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(_tr(context, 'Add expense')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: description,
                decoration:
                    InputDecoration(labelText: _tr(context, 'Description'))),
            TextField(
                controller: amount,
                decoration:
                    InputDecoration(labelText: _tr(context, 'Amount (SAR)')),
                keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
                initialValue: category,
                decoration:
                    InputDecoration(labelText: _tr(context, 'Category')),
                items: _categories
                    .map((c) => DropdownMenuItem(
                        value: c, child: Text(_tr(context, c))))
                    .toList(),
                onChanged: (value) =>
                    setState(() => category = value ?? category)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Cancel'))),
          FilledButton(
              onPressed: () {
                final parsed = double.tryParse(amount.text);
                if (description.text.trim().isNotEmpty &&
                    parsed != null &&
                    parsed > 0) {
                  Navigator.pop(
                      context, (description.text.trim(), category, parsed));
                }
              },
              child: Text(_tr(context, 'Save'))),
        ],
      );
}

class _ServiceDialog extends StatefulWidget {
  const _ServiceDialog({required this.car});
  final TrackedItem car;
  @override
  State<_ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<_ServiceDialog> {
  final title = TextEditingController();
  final notes = TextEditingController();
  final fee = TextEditingController();
  DateTime? reminder;
  @override
  void dispose() {
    title.dispose();
    notes.dispose();
    fee.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(_tr(context, 'Vehicle service request')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: title,
              decoration: InputDecoration(
                  labelText: _tr(context, 'Service or request'))),
          TextField(
              controller: notes,
              decoration: InputDecoration(labelText: _tr(context, 'Notes'))),
          TextField(
            controller: fee,
            decoration:
                InputDecoration(labelText: _tr(context, 'Service fee (SAR)')),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('${_tr(context, 'Reminder')}: ${_date(reminder)}'),
            trailing: Wrap(
              children: [
                if (reminder != null)
                  IconButton(
                    tooltip: _tr(context, 'Clear reminder date'),
                    onPressed: () => setState(() => reminder = null),
                    icon: const Icon(Icons.clear),
                  ),
                IconButton(
                  tooltip: _tr(context, 'Choose reminder date'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: reminder ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => reminder = picked);
                  },
                  icon: const Icon(Icons.event),
                ),
              ],
            ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_tr(context, 'Cancel'))),
          FilledButton(
              onPressed: () {
                if (title.text.trim().isNotEmpty) {
                  final serviceFee = double.tryParse(fee.text) ?? 0;
                  if (!serviceFee.isFinite || serviceFee < 0) return;
                  Navigator.pop(
                      context,
                      VehicleService(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        carId: widget.car.id,
                        title: title.text.trim(),
                        status: VehicleServiceStatus.requested,
                        fee: serviceFee,
                        notes: notes.text.trim(),
                        reminder: reminder,
                      ));
                }
              },
              child: Text(_tr(context, 'Save'))),
        ],
      );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.retry});
  final String error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_tr(context,
                'Saved data could not be loaded. It has not been erased.')),
            SelectableText(error),
            FilledButton(
                onPressed: retry, child: Text(_tr(context, 'Try again'))),
          ],
        ),
      );
}
