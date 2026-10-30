import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:installment_tracker/app_models.dart';

void main() {
  test('an app-data payload round-trips contracts, devices, and settings', () {
    final data = AppData(
      items: [
        const TrackedItem(
          id: 'contract',
          name: 'Mobile line',
          kind: ItemKind.serviceContract,
          serviceFee: 80,
          devicePayment: 40,
          deviceBalance: 120,
          deviceModel: 'Phone',
          contractType: 'Mobile',
          contractEnd: null,
        ),
        const TrackedItem(
          id: 'device',
          name: 'Phone installment',
          kind: ItemKind.device,
          deviceModel: 'Phone',
          linkedContractId: 'contract',
          payment: 50,
          balance: 200,
          remainingMonths: 4,
        ),
      ],
      locale: 'ar',
      theme: 'dark',
      renewalDays: 14,
    );

    final decoded = decodeAppData(encodeAppData(data));

    expect(decoded.items.first.monthlyTotal, 120);
    expect(decoded.items.last.linkedContractId, 'contract');
    expect(decoded.locale, 'ar');
    expect(decoded.theme, 'dark');
    expect(decoded.renewalDays, 14);
  });

  test('monthly totals do not exceed an outstanding balance', () {
    const plan = TrackedItem(
      id: 'plan',
      name: 'Final payment',
      kind: ItemKind.installment,
      payment: 100,
      balance: 35,
    );

    expect(plan.monthlyTotal, 35);
    expect(plan.afterPayment().balance, 0);
  });

  test('the final calculated installment absorbs cent rounding', () {
    var plan = const TrackedItem(
      id: 'tabby',
      name: 'Tabby plan',
      kind: ItemKind.installment,
      provider: Provider.tabby,
      payment: 333.33,
      balance: 1000,
      totalAmount: 1000,
      autoDistribute: true,
      remainingMonths: 3,
      termMonths: 3,
    );

    expect(plan.monthlyTotal, 333.33);
    plan = plan.afterPayment();
    expect(plan.monthlyTotal, 333.33);
    plan = plan.afterPayment();
    expect(plan.monthlyTotal, closeTo(333.34, 0.000001));
    expect(plan.afterPayment().balance, 0);
  });

  test('car loans reserve a final balloon and allow it to be extended', () {
    var loan = const TrackedItem(
      id: 'car',
      name: 'Car loan',
      kind: ItemKind.carLoan,
      provider: Provider.carLoan,
      payment: 1000,
      balance: 100000,
      totalAmount: 100000,
      balloonAmount: 41000,
      remainingMonths: 60,
      termMonths: 60,
    );

    for (var month = 0; month < 59; month++) {
      expect(loan.monthlyTotal, 1000);
      loan = loan.afterPayment();
    }

    expect(loan.remainingMonths, 1);
    expect(loan.balance, 41000);
    expect(loan.monthlyTotal, 41000);

    final extended = loan.copyWith(
      payment: 20500,
      balloonAmount: 0,
      remainingMonths: 2,
    );
    expect(extended.monthlyTotal, 20500);
    expect(extended.afterPayment().balance, 20500);
    expect(extended.afterPayment().afterPayment().balance, 0);

    final decoded = TrackedItem.fromJson(extended.toJson());
    expect(decoded.totalAmount, 100000);
    expect(decoded.balloonAmount, 0);
    expect(decoded.remainingMonths, 2);
  });

  test('ended contracts retain device payments but stop service fees', () {
    final contract = TrackedItem(
      id: 'ended',
      name: 'Ended mobile plan',
      kind: ItemKind.serviceContract,
      serviceFee: 100,
      devicePayment: 40,
      deviceBalance: 80,
      contractEnd: DateTime(2000),
    );

    expect(contract.monthlyTotal, 40);
    expect(contract.isActive, isTrue);
    expect(contract.afterPayment().deviceBalance, 40);
  });

  test('savings accounts, transactions, gold trades, and plan dates round-trip',
      () {
    final start = DateTime(2025, 1, 15);
    final expiry = DateTime(2025, 7, 15);
    final data = AppData(
      items: [
        TrackedItem(
          id: 'plan',
          name: 'Phone',
          kind: ItemKind.installment,
          startDate: start,
          expiresOn: expiry,
          termMonths: 6,
        ),
      ],
      savingsAccounts: const [
        SavingsAccount(id: 'main', name: 'Main'),
        SavingsAccount(id: 'travel', name: 'Travel'),
      ],
      savingsTransactions: [
        SavingsTransaction(
          id: 'deposit',
          type: SavingsTransactionType.deposit,
          amount: 500,
          date: start,
          accountId: 'main',
        ),
        SavingsTransaction(
          id: 'transfer',
          type: SavingsTransactionType.transfer,
          amount: 120,
          date: start,
          accountId: 'main',
          destinationAccountId: 'travel',
        ),
        SavingsTransaction(
          id: 'withdrawal',
          type: SavingsTransactionType.withdrawal,
          amount: 20,
          date: start,
          accountId: 'travel',
        ),
      ],
      goldTrades: [
        GoldTrade(
          id: 'buy',
          type: GoldTradeType.buy,
          grams: 3,
          pricePerGram: 250,
          date: start,
        ),
        GoldTrade(
          id: 'sell',
          type: GoldTradeType.sell,
          grams: 0.5,
          pricePerGram: 260,
          date: expiry,
        ),
      ],
      goldPrice: 260,
    );

    final decoded = decodeAppData(encodeAppData(data));

    expect(decoded.savingsBalance('main'), 380);
    expect(decoded.savingsBalance('travel'), 100);
    expect(decoded.totalGoldGrams, 2.5);
    expect(decoded.items.single.startDate, start);
    expect(decoded.items.single.expiresOn, expiry);
  });

  test('legacy plan records derive an expiration from their term', () {
    final decoded = decodeAppData(jsonEncode({
      'items': [
        {
          'id': 'legacy',
          'name': 'Legacy plan',
          'kind': 'installment',
          'termMonths': 4,
          'startDate': '2025-01-31T00:00:00.000',
        }
      ],
    }));

    expect(decoded.items.single.expiresOn, DateTime(2025, 5, 31));
  });

  test('saved savings transfers must reference distinct existing accounts', () {
    expect(
      () => decodeAppData(jsonEncode({
        'savingsAccounts': [
          {'id': 'main', 'name': 'Main'}
        ],
        'savingsTransactions': [
          {
            'id': 'invalid-transfer',
            'type': 'transfer',
            'amount': 10,
            'date': '2025-01-01T00:00:00.000',
            'accountId': 'main',
            'destinationAccountId': 'missing',
          }
        ],
      })),
      throwsFormatException,
    );
  });
}
