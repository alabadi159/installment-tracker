import 'dart:convert';

import 'package:flutter/material.dart';

enum ItemKind { installment, carLoan, serviceContract, device, gold }

enum Provider { tabby, tamara, snbFlex, bird, other, carLoan, device }

enum FinanceType {
  salary,
  income,
  payment,
  expense,
  transfer,
  adjustment,
  shortfall
}

enum VehicleServiceStatus { requested, inProgress, completed }

enum SavingsTransactionType { openingBalance, deposit, withdrawal, transfer }

enum GoldTradeType { buy, sell }

class TrackedItem {
  const TrackedItem({
    required this.id,
    required this.name,
    required this.kind,
    this.provider = Provider.other,
    this.payment = 0,
    this.balance = 0,
    this.totalAmount = 0,
    this.autoDistribute = false,
    this.balloonAmount = 0,
    this.remainingMonths = 0,
    this.nextDue,
    this.serviceFee = 0,
    this.devicePayment = 0,
    this.deviceBalance = 0,
    this.deviceModel = '',
    this.contractEnd,
    this.contractType = 'Other',
    this.expiresOn,
    this.linkedContractId,
    this.goldGrams = 0,
    this.startDate,
    this.termMonths = 0,
  });

  final String id;
  final String name;
  final ItemKind kind;
  final Provider provider;
  final double payment;
  final double balance;
  final double totalAmount;
  final bool autoDistribute;
  final double balloonAmount;
  final int remainingMonths;
  final DateTime? nextDue;
  final double serviceFee;
  final double devicePayment;
  final double deviceBalance;
  final String deviceModel;
  final DateTime? contractEnd;
  final String contractType;
  final DateTime? expiresOn;
  final String? linkedContractId;
  final double goldGrams;
  final DateTime? startDate;
  final int termMonths;

  bool get isActive {
    if (kind == ItemKind.gold) return true;
    if (kind == ItemKind.serviceContract) {
      final contractCurrent = contractEnd == null ||
          !DateUtils.dateOnly(contractEnd!)
              .isBefore(DateUtils.dateOnly(DateTime.now()));
      return contractCurrent || deviceBalance > 0;
    }
    return balance > 0;
  }

  double get monthlyTotal {
    if (kind == ItemKind.serviceContract) {
      final contractCurrent = contractEnd == null ||
          !DateUtils.dateOnly(contractEnd!)
              .isBefore(DateUtils.dateOnly(DateTime.now()));
      return (contractCurrent ? serviceFee : 0) +
          (deviceBalance > 0 ? devicePayment.clamp(0, deviceBalance) : 0);
    }
    if (kind == ItemKind.carLoan && balloonAmount > 0 && remainingMonths <= 1) {
      return balloonAmount.clamp(0, balance);
    }
    if (autoDistribute && remainingMonths <= 1) return balance;
    return payment.clamp(0, balance);
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'provider': provider.name,
        'monthlyPayment': payment,
        'balance': balance,
        'totalAmount': totalAmount,
        'autoDistribute': autoDistribute,
        'balloonAmount': balloonAmount,
        'remainingMonths': remainingMonths,
        'nextDue': nextDue?.toIso8601String(),
        'serviceFee': serviceFee,
        'deviceMonthlyPayment': devicePayment,
        'deviceBalance': deviceBalance,
        'deviceModel': deviceModel,
        'contractEnd': contractEnd?.toIso8601String(),
        'contractType': contractType,
        'expiresOn': expiresOn?.toIso8601String(),
        'linkedContractId': linkedContractId,
        'goldGrams': goldGrams,
        'startDate': startDate?.toIso8601String(),
        'termMonths': termMonths,
      };

  factory TrackedItem.fromJson(Map<String, dynamic> json) {
    final oldKind = json['kind'] as String? ?? 'installment';
    final kind = oldKind == 'deviceInstallment' ? 'device' : oldKind;
    final providerName = json['provider'] as String?;
    final name = json['name'] as String? ?? 'Plan';
    final inferredProvider = switch (name.toLowerCase()) {
      final value when value.contains('tabby') => Provider.tabby,
      final value when value.contains('tamara') => Provider.tamara,
      final value when value.contains('bird') => Provider.bird,
      final value when value.contains('snb flex') => Provider.snbFlex,
      _ => kind == 'carLoan' ? Provider.carLoan : Provider.other,
    };
    final nextDueValue = json['nextDue'];
    final nextDue = nextDueValue == null
        ? _addMonths(DateTime.now(), 1)
        : DateTime.parse(nextDueValue as String);
    final providerKey = providerName?.toLowerCase().replaceAll(
          RegExp(r'[^a-z]'),
          '',
        );
    final provider = switch (providerKey) {
      'tabby' => Provider.tabby,
      'tamara' => Provider.tamara,
      'snbflex' => Provider.snbFlex,
      'bird' => Provider.bird,
      'carloan' => Provider.carLoan,
      'device' => Provider.device,
      'other' => Provider.other,
      null => inferredProvider,
      _ =>
        throw FormatException('Unknown saved payment provider: $providerName'),
    };
    final startDate = _date(json['startDate']);
    final termMonths =
        json['termMonths'] as int? ?? json['remainingMonths'] as int? ?? 0;
    final legacyRemainingMonths = json['remainingMonths'] as int? ?? 0;
    final expiresOn = _date(json['expiresOn']) ??
        (kind == 'serviceContract' || kind == 'gold'
            ? null
            : startDate != null && termMonths > 0
                ? _addMonths(startDate, termMonths)
                : legacyRemainingMonths > 0
                    ? _addMonths(nextDue, legacyRemainingMonths - 1)
                    : null);
    final item = TrackedItem(
      id: json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      kind: ItemKind.values.byName(kind),
      provider: provider,
      payment: (json['monthlyPayment'] as num? ?? json['payment'] as num? ?? 0)
          .toDouble(),
      balance: (json['balance'] as num? ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] as num? ?? json['balance'] as num? ?? 0)
          .toDouble(),
      autoDistribute: json['autoDistribute'] as bool? ?? false,
      balloonAmount: (json['balloonAmount'] as num? ?? 0).toDouble(),
      remainingMonths: legacyRemainingMonths,
      nextDue: nextDue,
      serviceFee: (json['serviceFee'] as num? ?? 0).toDouble(),
      devicePayment: (json['deviceMonthlyPayment'] as num? ?? 0).toDouble(),
      deviceBalance: (json['deviceBalance'] as num? ?? 0).toDouble(),
      deviceModel: json['deviceModel'] as String? ?? '',
      contractEnd: _date(json['contractEnd']),
      contractType: json['contractType'] as String? ?? 'Other',
      expiresOn: expiresOn,
      linkedContractId: json['linkedContractId'] as String?,
      goldGrams: (json['goldGrams'] as num? ?? 0).toDouble(),
      startDate: startDate,
      termMonths: termMonths,
    );
    final amounts = [
      item.payment,
      item.balance,
      item.totalAmount,
      item.balloonAmount,
      item.serviceFee,
      item.devicePayment,
      item.deviceBalance,
      item.goldGrams,
    ];
    if (item.id.isEmpty ||
        item.name.trim().isEmpty ||
        amounts.any((amount) => !amount.isFinite || amount < 0) ||
        item.remainingMonths < 0 ||
        item.termMonths < 0) {
      throw const FormatException('A saved payment record is invalid.');
    }
    return item;
  }

  TrackedItem copyWith({
    String? name,
    ItemKind? kind,
    Provider? provider,
    double? payment,
    double? balance,
    double? totalAmount,
    bool? autoDistribute,
    double? balloonAmount,
    int? remainingMonths,
    DateTime? nextDue,
    double? serviceFee,
    double? devicePayment,
    double? deviceBalance,
    double? goldGrams,
    DateTime? contractEnd,
    String? contractType,
    DateTime? startDate,
    DateTime? expiresOn,
    bool clearExpiresOn = false,
    String? linkedContractId,
  }) =>
      TrackedItem(
        id: id,
        name: name ?? this.name,
        kind: kind ?? this.kind,
        provider: provider ?? this.provider,
        payment: payment ?? this.payment,
        balance: balance ?? this.balance,
        totalAmount: totalAmount ?? this.totalAmount,
        autoDistribute: autoDistribute ?? this.autoDistribute,
        balloonAmount: balloonAmount ?? this.balloonAmount,
        remainingMonths: remainingMonths ?? this.remainingMonths,
        nextDue: nextDue ?? this.nextDue,
        serviceFee: serviceFee ?? this.serviceFee,
        devicePayment: devicePayment ?? this.devicePayment,
        deviceBalance: deviceBalance ?? this.deviceBalance,
        deviceModel: deviceModel,
        contractEnd: contractEnd ?? this.contractEnd,
        contractType: contractType ?? this.contractType,
        expiresOn: clearExpiresOn ? null : expiresOn ?? this.expiresOn,
        linkedContractId: linkedContractId ?? this.linkedContractId,
        goldGrams: goldGrams ?? this.goldGrams,
        startDate: startDate ?? this.startDate,
        termMonths: termMonths,
      );

  TrackedItem afterPayment() {
    final isFinalBalloonPayment =
        kind == ItemKind.carLoan && balloonAmount > 0 && remainingMonths <= 1;
    final nextBalance =
        (balance - monthlyTotal).clamp(0, double.infinity).toDouble();
    final nextDeviceBalance =
        (deviceBalance - devicePayment).clamp(0, double.infinity).toDouble();
    return copyWith(
      balance: nextBalance,
      balloonAmount: isFinalBalloonPayment ? 0 : balloonAmount,
      deviceBalance: nextDeviceBalance,
      remainingMonths: remainingMonths > 0 ? remainingMonths - 1 : 0,
      nextDue: _addMonths(nextDue ?? DateTime.now(), 1),
    );
  }
}

class FinanceEntry {
  const FinanceEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceDelta,
    required this.date,
    required this.description,
    this.category,
    this.itemId,
  });

  final String id;
  final FinanceType type;
  final double amount;
  final double balanceDelta;
  final DateTime date;
  final String description;
  final String? category;
  final String? itemId;

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'balanceDelta': balanceDelta,
        'date': date.toIso8601String(),
        'description': description,
        'category': category,
        'itemId': itemId,
      };

  factory FinanceEntry.fromJson(Map<String, dynamic> json) => FinanceEntry(
        id: json['id'] as String,
        type: FinanceType.values.byName(json['type'] as String),
        amount: (json['amount'] as num).toDouble(),
        balanceDelta: (json['balanceDelta'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        description: json['description'] as String,
        category: json['category'] as String?,
        itemId: json['itemId'] as String?,
      );
}

class SavingsAccount {
  const SavingsAccount({
    required this.id,
    required this.name,
    this.createdAt,
  });

  final String id;
  final String name;
  final DateTime? createdAt;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory SavingsAccount.fromJson(Map<String, dynamic> json) => SavingsAccount(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: _date(json['createdAt']),
      );
}

class SavingsTransaction {
  const SavingsTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.accountId,
    this.destinationAccountId,
    this.note = '',
  });

  final String id;
  final SavingsTransactionType type;
  final double amount;
  final DateTime date;
  final String accountId;
  final String? destinationAccountId;
  final String note;

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'date': date.toIso8601String(),
        'accountId': accountId,
        'destinationAccountId': destinationAccountId,
        'note': note,
      };

  factory SavingsTransaction.fromJson(Map<String, dynamic> json) =>
      SavingsTransaction(
        id: json['id'] as String,
        type: SavingsTransactionType.values.byName(json['type'] as String),
        amount: (json['amount'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        accountId: json['accountId'] as String,
        destinationAccountId: json['destinationAccountId'] as String?,
        note: json['note'] as String? ?? '',
      );
}

class GoldTrade {
  const GoldTrade({
    required this.id,
    required this.type,
    required this.grams,
    required this.pricePerGram,
    required this.date,
  });

  final String id;
  final GoldTradeType type;
  final double grams;
  final double pricePerGram;
  final DateTime date;

  double get total => grams * pricePerGram;

  Map<String, Object?> toJson() => {
        'id': id,
        'type': type.name,
        'grams': grams,
        'pricePerGram': pricePerGram,
        'date': date.toIso8601String(),
      };

  factory GoldTrade.fromJson(Map<String, dynamic> json) => GoldTrade(
        id: json['id'] as String,
        type: GoldTradeType.values.byName(json['type'] as String),
        grams: (json['grams'] as num).toDouble(),
        pricePerGram: (json['pricePerGram'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
      );
}

class Budget {
  const Budget({required this.category, required this.limit});
  final String category;
  final double limit;
  Map<String, Object> toJson() => {'category': category, 'limit': limit};
  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
      category: json['category'] as String,
      limit: (json['limit'] as num).toDouble());
}

class VehicleService {
  const VehicleService({
    required this.id,
    required this.carId,
    required this.title,
    required this.status,
    this.fee = 0,
    this.notes = '',
    this.reminder,
  });
  final String id;
  final String carId;
  final String title;
  final VehicleServiceStatus status;
  final double fee;
  final String notes;
  final DateTime? reminder;

  Map<String, Object?> toJson() => {
        'id': id,
        'carId': carId,
        'title': title,
        'status': status.name,
        'fee': fee,
        'notes': notes,
        'reminder': reminder?.toIso8601String(),
      };

  factory VehicleService.fromJson(Map<String, dynamic> json) => VehicleService(
        id: json['id'] as String,
        carId: json['carId'] as String,
        title: json['title'] as String,
        status: VehicleServiceStatus.values.byName(json['status'] as String),
        fee: (json['fee'] as num? ?? 0).toDouble(),
        notes: json['notes'] as String? ?? '',
        reminder: _date(json['reminder']),
      );
}

class AppData {
  const AppData({
    this.items = const [],
    this.entries = const [],
    this.budgets = const [],
    this.services = const [],
    this.savingsAccounts = const [],
    this.savingsTransactions = const [],
    this.goldTrades = const [],
    this.income = 0,
    this.payday = 25,
    this.nextPayday,
    this.remindersEnabled = false,
    this.renewalDays = 30,
    this.goldPrice,
    this.goldManual = false,
    this.goldUpdatedAt,
    this.locale = 'en',
    this.theme = 'system',
  });

  final List<TrackedItem> items;
  final List<FinanceEntry> entries;
  final List<Budget> budgets;
  final List<VehicleService> services;
  final List<SavingsAccount> savingsAccounts;
  final List<SavingsTransaction> savingsTransactions;
  final List<GoldTrade> goldTrades;
  final double income;
  final int payday;
  final DateTime? nextPayday;
  final bool remindersEnabled;
  final int renewalDays;
  final double? goldPrice;
  final bool goldManual;
  final DateTime? goldUpdatedAt;
  final String locale;
  final String theme;

  double get salaryBalance =>
      entries.fold(0, (total, entry) => total + entry.balanceDelta);

  double get totalGoldGrams =>
      items
          .where((item) => item.kind == ItemKind.gold)
          .fold(0.0, (sum, item) => sum + item.goldGrams) +
      goldTrades.fold(
        0.0,
        (sum, trade) =>
            sum +
            (trade.type == GoldTradeType.buy ? trade.grams : -trade.grams),
      );

  double savingsBalance(String accountId) =>
      _savingsBalanceFor(accountId, savingsTransactions);

  Map<String, Object?> toJson() => {
        'version': 2,
        'items': items.map((item) => item.toJson()).toList(),
        'entries': entries.map((entry) => entry.toJson()).toList(),
        'budgets': budgets.map((budget) => budget.toJson()).toList(),
        'services': services.map((service) => service.toJson()).toList(),
        'savingsAccounts':
            savingsAccounts.map((account) => account.toJson()).toList(),
        'savingsTransactions': savingsTransactions
            .map((transaction) => transaction.toJson())
            .toList(),
        'goldTrades': goldTrades.map((trade) => trade.toJson()).toList(),
        'income': income,
        'payday': payday,
        'nextPayday': nextPayday?.toIso8601String(),
        'remindersEnabled': remindersEnabled,
        'renewalDays': renewalDays,
        'goldPrice': goldPrice,
        'goldManual': goldManual,
        'goldUpdatedAt': goldUpdatedAt?.toIso8601String(),
        'locale': locale,
        'theme': theme,
      };

  factory AppData.fromJson(Map<String, dynamic> json) {
    final data = AppData(
      items: _list(json, 'items', TrackedItem.fromJson),
      entries: _list(json, 'entries', FinanceEntry.fromJson),
      budgets: _list(json, 'budgets', Budget.fromJson),
      services: _list(json, 'services', VehicleService.fromJson),
      savingsAccounts: _list(json, 'savingsAccounts', SavingsAccount.fromJson),
      savingsTransactions:
          _list(json, 'savingsTransactions', SavingsTransaction.fromJson),
      goldTrades: _list(json, 'goldTrades', GoldTrade.fromJson),
      income: (json['income'] as num? ?? 0).toDouble(),
      payday: json['payday'] as int? ?? 25,
      nextPayday: _date(json['nextPayday']),
      remindersEnabled: json['remindersEnabled'] as bool? ?? false,
      renewalDays: json['renewalDays'] as int? ?? 30,
      goldPrice: (json['goldPrice'] as num?)?.toDouble(),
      goldManual: json['goldManual'] as bool? ?? false,
      goldUpdatedAt: _date(json['goldUpdatedAt']),
      locale: json['locale'] as String? ?? 'en',
      theme: json['theme'] as String? ?? 'system',
    );
    if (!data.income.isFinite ||
        data.income < 0 ||
        data.payday < 1 ||
        data.payday > 31 ||
        data.renewalDays < 1 ||
        data.renewalDays > 365 ||
        !{'en', 'ar'}.contains(data.locale) ||
        !{'system', 'light', 'dark'}.contains(data.theme) ||
        (data.goldPrice != null &&
            (!data.goldPrice!.isFinite || data.goldPrice! <= 0)) ||
        data.savingsAccounts.any(
            (account) => account.id.isEmpty || account.name.trim().isEmpty) ||
        data.savingsAccounts.map((account) => account.id).toSet().length !=
            data.savingsAccounts.length ||
        data.savingsAccounts
                .map((account) => account.name.toLowerCase())
                .toSet()
                .length !=
            data.savingsAccounts.length ||
        data.savingsTransactions.any((transaction) =>
            transaction.id.isEmpty ||
            !transaction.amount.isFinite ||
            transaction.amount <= 0 ||
            !data.savingsAccounts
                .any((account) => account.id == transaction.accountId) ||
            (transaction.type == SavingsTransactionType.transfer
                ? transaction.destinationAccountId == null ||
                    transaction.destinationAccountId == transaction.accountId ||
                    !data.savingsAccounts.any((account) =>
                        account.id == transaction.destinationAccountId)
                : transaction.destinationAccountId != null)) ||
        data.savingsTransactions
                .where((transaction) =>
                    transaction.type == SavingsTransactionType.openingBalance)
                .map((transaction) => transaction.accountId)
                .toSet()
                .length !=
            data.savingsTransactions
                .where((transaction) =>
                    transaction.type == SavingsTransactionType.openingBalance)
                .length ||
        data.savingsTransactions
                .map((transaction) => transaction.id)
                .toSet()
                .length !=
            data.savingsTransactions.length ||
        data.savingsAccounts.any((account) =>
            _savingsBalanceFor(
              account.id,
              data.savingsTransactions,
            ) <
            -0.000001) ||
        data.goldTrades.any((trade) =>
            trade.id.isEmpty ||
            !trade.grams.isFinite ||
            trade.grams <= 0 ||
            !trade.pricePerGram.isFinite ||
            trade.pricePerGram <= 0 ||
            !trade.total.isFinite) ||
        data.goldTrades.map((trade) => trade.id).toSet().length !=
            data.goldTrades.length ||
        !data.totalGoldGrams.isFinite ||
        data.totalGoldGrams < -0.000001) {
      throw const FormatException('Saved app settings are invalid.');
    }
    return data;
  }

  AppData copyWith({
    List<TrackedItem>? items,
    List<FinanceEntry>? entries,
    List<Budget>? budgets,
    List<VehicleService>? services,
    List<SavingsAccount>? savingsAccounts,
    List<SavingsTransaction>? savingsTransactions,
    List<GoldTrade>? goldTrades,
    double? income,
    int? payday,
    DateTime? nextPayday,
    bool clearNextPayday = false,
    bool? remindersEnabled,
    int? renewalDays,
    double? goldPrice,
    bool? goldManual,
    DateTime? goldUpdatedAt,
    bool clearGoldPrice = false,
    bool clearGoldUpdatedAt = false,
    String? locale,
    String? theme,
  }) =>
      AppData(
        items: items ?? this.items,
        entries: entries ?? this.entries,
        budgets: budgets ?? this.budgets,
        services: services ?? this.services,
        savingsAccounts: savingsAccounts ?? this.savingsAccounts,
        savingsTransactions: savingsTransactions ?? this.savingsTransactions,
        goldTrades: goldTrades ?? this.goldTrades,
        income: income ?? this.income,
        payday: payday ?? this.payday,
        nextPayday: clearNextPayday ? null : nextPayday ?? this.nextPayday,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        renewalDays: renewalDays ?? this.renewalDays,
        goldPrice: clearGoldPrice ? null : goldPrice ?? this.goldPrice,
        goldManual: goldManual ?? this.goldManual,
        goldUpdatedAt:
            clearGoldUpdatedAt ? null : goldUpdatedAt ?? this.goldUpdatedAt,
        locale: locale ?? this.locale,
        theme: theme ?? this.theme,
      );
}

double _savingsBalanceFor(
  String accountId,
  List<SavingsTransaction> transactions,
) {
  var balance = 0.0;
  for (final transaction in transactions) {
    if (transaction.accountId == accountId) {
      balance += switch (transaction.type) {
        SavingsTransactionType.openingBalance ||
        SavingsTransactionType.deposit =>
          transaction.amount,
        SavingsTransactionType.withdrawal ||
        SavingsTransactionType.transfer =>
          -transaction.amount,
      };
    }
    if (transaction.type == SavingsTransactionType.transfer &&
        transaction.destinationAccountId == accountId) {
      balance += transaction.amount;
    }
  }
  return balance;
}

List<T> _list<T>(
  Map<String, dynamic> json,
  String key,
  T Function(Map<String, dynamic>) decode,
) {
  final value = json[key] ?? const [];
  if (value is! List) throw FormatException('Saved $key data is invalid.');
  return value.map((entry) {
    if (entry is! Map<String, dynamic>) {
      throw FormatException('A saved $key record is invalid.');
    }
    return decode(entry);
  }).toList();
}

DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

DateTime _addMonths(DateTime date, int months) {
  final first = DateTime(date.year, date.month + months, 1);
  final last = DateTime(first.year, first.month + 1, 0).day;
  return DateTime(first.year, first.month, date.day.clamp(1, last));
}

String encodeAppData(AppData data) => jsonEncode(data.toJson());

AppData decodeAppData(String json) {
  final decoded = jsonDecode(json);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Saved app data must be an object.');
  }
  final version = decoded['version'];
  if (version is num && version > 2) {
    throw FormatException('Saved app data version $version is not supported.');
  }
  return AppData.fromJson(decoded);
}
