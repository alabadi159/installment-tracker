import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:installment_tracker/app_models.dart';
import 'package:installment_tracker/main.dart';

const storageChannel = MethodChannel('com.example.installment_tracker/storage');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final savedValues = <String, String>{};
  List<dynamic>? lastScheduledReminders;

  setUp(() {
    savedValues.clear();
    lastScheduledReminders = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (call) async {
      switch (call.method) {
        case 'loadAppData':
          return savedValues['app'];
        case 'loadPlans':
          return savedValues['plans'];
        case 'saveAppData':
          savedValues['app'] = call.arguments as String;
          return null;
        case 'savePlans':
          savedValues['plans'] = call.arguments as String;
          return null;
        case 'scheduleReminders':
          lastScheduledReminders = call.arguments as List<dynamic>;
          return null;
        case 'requestNotificationPermission':
          return true;
        case 'getGoldSpot':
          return jsonEncode({
            'price': 2200,
            'updatedAt': '2025-01-01T00:00:00Z',
          });
        default:
          throw PlatformException(code: 'not_implemented');
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
  });

  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('the launch screen renders while local storage responds',
      (tester) async {
    final response = Completer<String?>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (call) {
      if (call.method == 'loadAppData') return response.future;
      return Future<Object?>.value(null);
    });

    await tester.pumpWidget(const AuraWelthApp());
    await tester.pump();

    expect(find.text('AuraWelth Pro'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    response.complete(null);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('a user can add a plan and it is persisted', (tester) async {
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Phone');
    await tester.enterText(
        find.widgetWithText(TextField, 'Monthly payment (SAR)'), '100');
    await tester.enterText(
        find.widgetWithText(TextField, 'Remaining balance (SAR)'), '300');
    await tester.enterText(
        find.widgetWithText(TextField, 'Remaining months (1–120)'), '3');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Phone'), findsOneWidget);
    final data = AppData.fromJson(
        jsonDecode(savedValues['app']!) as Map<String, dynamic>);
    expect(data.items, hasLength(1));
    expect(data.items.single.name, 'Phone');
    expect(data.items.single.monthlyTotal, 100);
    expect(data.items.single.startDate, isNotNull);
    expect(data.items.single.expiresOn, isNotNull);
  });

  testWidgets('Tabby and Tamara allow 2–24 months and SNB FLEX stays at four',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();

    Future<void> addProviderPlan({
      required String provider,
      required String planName,
      required int months,
    }) async {
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<Provider>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(provider).last);
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Name'), planName);
      await tester.enterText(
          find.widgetWithText(TextField, 'Plan total amount (SAR)'), '240');
      final monthsLabel = provider == 'Tabby' || provider == 'Tamara'
          ? 'Remaining months (2–24)'
          : 'SNB FLEX remaining months';
      if (provider != 'SNB FLEX') {
        await tester.enterText(
            find.widgetWithText(TextField, monthsLabel), '$months');
      } else {
        expect(
          tester.widget<TextField>(find.widgetWithText(TextField, monthsLabel)),
          isA<TextField>().having((field) => field.readOnly, 'readOnly', true),
        );
      }
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text(planName), findsOneWidget);
    }

    await addProviderPlan(
        provider: 'Tabby', planName: 'Tabby short', months: 2);
    await addProviderPlan(
        provider: 'Tamara', planName: 'Tamara long', months: 24);
    await addProviderPlan(
        provider: 'SNB FLEX', planName: 'SNB four', months: 4);

    final data = AppData.fromJson(
        jsonDecode(savedValues['app']!) as Map<String, dynamic>);
    final byName = {for (final item in data.items) item.name: item};
    expect(byName['Tabby short']!.provider, Provider.tabby);
    expect(byName['Tabby short']!.termMonths, 2);
    expect(byName['Tabby short']!.payment, 120);
    expect(byName['Tabby short']!.balance, 240);
    expect(byName['Tabby short']!.totalAmount, 240);
    expect(byName['Tabby short']!.autoDistribute, isTrue);
    expect(byName['Tamara long']!.provider, Provider.tamara);
    expect(byName['Tamara long']!.termMonths, 24);
    expect(byName['Tamara long']!.payment, 10);
    expect(byName['SNB four']!.provider, Provider.snbFlex);
    expect(byName['SNB four']!.termMonths, 4);
    expect(byName['SNB four']!.payment, 60);
  });

  testWidgets('a car loan uses 59 fixed payments and a final balloon',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vehicles'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Name'), 'Family car');
    await tester.enterText(
        find.widgetWithText(TextField, 'Loan total amount (SAR)'), '100000');
    await tester.enterText(
        find.widgetWithText(TextField, 'Monthly payment (SAR)'), '1000');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final data = AppData.fromJson(
        jsonDecode(savedValues['app']!) as Map<String, dynamic>);
    final loan = data.items.single;
    expect(loan.kind, ItemKind.carLoan);
    expect(loan.termMonths, 60);
    expect(loan.remainingMonths, 60);
    expect(loan.totalAmount, 100000);
    expect(loan.payment, 1000);
    expect(loan.balloonAmount, 41000);
  });

  testWidgets('an unpaid car balloon can be extended over selected months',
      (tester) async {
    useTallScreen(tester);
    final nextDue = DateTime.now().add(const Duration(days: 30));
    savedValues['app'] = jsonEncode({
      'items': [
        {
          'id': 'car',
          'name': 'Family car',
          'kind': 'carLoan',
          'provider': 'carLoan',
          'monthlyPayment': 1000,
          'balance': 1200,
          'totalAmount': 60000,
          'balloonAmount': 1200,
          'remainingMonths': 1,
          'termMonths': 60,
          'nextDue': nextDue.toIso8601String(),
          'expiresOn': nextDue.toIso8601String(),
        }
      ],
    });

    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plans'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Extend balloon'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Additional months (1–120)'), '6');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final data = AppData.fromJson(
        jsonDecode(savedValues['app']!) as Map<String, dynamic>);
    final loan = data.items.single;
    expect(loan.balloonAmount, 0);
    expect(loan.balance, 1200);
    expect(loan.payment, 200);
    expect(loan.remainingMonths, 6);
  });

  testWidgets('a savings account can be created from the dashboard',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Savings accounts'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add account'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Account name'), 'Emergency fund');
    await tester.tap(find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Add account'),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Emergency fund'), findsOneWidget);
    final data = AppData.fromJson(
        jsonDecode(savedValues['app']!) as Map<String, dynamic>);
    expect(data.savingsAccounts, isNotEmpty, reason: savedValues['app']);
    expect(data.savingsAccounts.single.name, 'Emergency fund');
  });

  testWidgets('finance analysis displays both requested chart sections',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Finance analysis'));
    await tester.pumpAndSettle();

    expect(find.text('Cash flow · last 6 months'), findsOneWidget);
    expect(find.text('Budget vs spending · this month'), findsOneWidget);
  });

  testWidgets('bad stored data is shown without being overwritten',
      (tester) async {
    savedValues['app'] = '{invalid';

    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();

    expect(
        find.textContaining('Saved data could not be loaded'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(savedValues['app'], '{invalid');
  });

  testWidgets('selecting Arabic localizes navigation and uses RTL direction',
      (tester) async {
    await tester.pumpWidget(const AuraWelthApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsOneWidget);
    expect(
      tester
          .widgetList<Directionality>(find.byType(Directionality))
          .any((widget) => widget.textDirection == TextDirection.rtl),
      isTrue,
    );
  });

  test('legacy payment-plan storage migrates to the app data schema', () async {
    final legacy = [
      {
        'id': 'old-plan',
        'name': 'Old phone',
        'payment': 75,
        'balance': 300,
        'remainingMonths': 4,
        'nextDue': DateTime(2099, 1, 1).toIso8601String(),
      }
    ];
    savedValues['plans'] = jsonEncode(legacy);

    final store = TrackerStore();
    await store.load();
    addTearDown(store.dispose);

    expect(store.ready, isTrue);
    expect(store.data.items.single.id, 'old-plan');
    expect(store.data.items.single.payment, 75);
    expect(savedValues['plans'], jsonEncode(legacy));
    expect(jsonDecode(savedValues['app']!)['items'], hasLength(1));
  });

  test('overdue salary and plan payments reconcile once in the ledger',
      () async {
    final now = DateTime.now();
    final due = DateTime(now.year, now.month, now.day - 1);
    savedValues['app'] = jsonEncode({
      'income': 2000,
      'payday': due.day,
      'nextPayday': due.toIso8601String(),
      'entries': [
        {
          'id': 'opening',
          'type': 'adjustment',
          'amount': 1000,
          'balanceDelta': 1000,
          'date': now.toIso8601String(),
          'description': 'Opening balance'
        }
      ],
      'items': [
        {
          'id': 'plan-1',
          'name': 'Phone',
          'kind': 'installment',
          'provider': 'other',
          'monthlyPayment': 100,
          'balance': 500,
          'remainingMonths': 5,
          'nextDue': due.toIso8601String()
        }
      ]
    });

    final store = TrackerStore();
    await store.load();
    addTearDown(store.dispose);

    expect(store.data.salaryBalance, 2900);
    expect(store.data.items.single.balance, 400);
    expect(
      store.data.entries.where((entry) => entry.type == FinanceType.salary),
      hasLength(1),
    );
    expect(
      store.data.entries.where((entry) => entry.type == FinanceType.payment),
      hasLength(1),
    );
  });

  test('reminders are scheduled for the next due payment in Riyadh time',
      () async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final due = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    savedValues['app'] = jsonEncode({
      'remindersEnabled': true,
      'items': [
        {
          'id': 'plan-reminder',
          'name': 'Phone',
          'kind': 'installment',
          'provider': 'other',
          'monthlyPayment': 100,
          'balance': 300,
          'remainingMonths': 3,
          'nextDue': due.toIso8601String()
        }
      ]
    });

    final store = TrackerStore();
    await store.load();
    addTearDown(store.dispose);

    expect(lastScheduledReminders, hasLength(1));
    final reminder = lastScheduledReminders!.single as Map<Object?, Object?>;
    expect(reminder['title'], 'Payment due: Phone');
    expect(
      reminder['at'],
      DateTime.utc(due.year, due.month, due.day, 6).millisecondsSinceEpoch,
    );
  });

  test('gold spot refresh stores a converted SAR-per-gram quote', () async {
    final store = TrackerStore();
    await store.load();
    await store.refreshGoldPrice();
    addTearDown(store.dispose);

    expect(store.data.goldPrice, closeTo(2200 * 3.75 / 31.1034768, 0.000001));
    expect(store.data.goldManual, isFalse);
    expect(store.data.goldUpdatedAt, DateTime.utc(2025));
    expect(store.actionError, isNull);
  });

  test('savings transactions move cash and account balances correctly',
      () async {
    final store = TrackerStore();
    await store.load();
    await store.save(store.data.copyWith(entries: [
      FinanceEntry(
        id: 'opening',
        type: FinanceType.adjustment,
        amount: 1000,
        balanceDelta: 1000,
        date: DateTime(2025),
        description: 'Opening balance',
      ),
    ]));
    await store.addSavingsAccount('Main');
    await store.addSavingsAccount('Travel');
    addTearDown(store.dispose);
    final main = store.data.savingsAccounts.first;
    final travel = store.data.savingsAccounts.last;

    await store.recordSavingsTransaction(
      type: SavingsTransactionType.openingBalance,
      accountId: main.id,
      amount: 500,
      note: 'Saved before using the app',
    );
    expect(store.data.savingsBalance(main.id), 500);
    expect(store.data.salaryBalance, 1000);

    await store.recordSavingsTransaction(
      type: SavingsTransactionType.deposit,
      accountId: main.id,
      amount: 300,
    );
    await store.recordSavingsTransaction(
      type: SavingsTransactionType.transfer,
      accountId: main.id,
      destinationAccountId: travel.id,
      amount: 100,
    );
    await store.recordSavingsTransaction(
      type: SavingsTransactionType.withdrawal,
      accountId: travel.id,
      amount: 50,
    );

    expect(store.data.savingsBalance(main.id), 700);
    expect(store.data.savingsBalance(travel.id), 50);
    expect(store.data.salaryBalance, 750);
    expect(
      store.data.entries.where((entry) => entry.type == FinanceType.transfer),
      hasLength(2),
    );
    await expectLater(
      store.recordSavingsTransaction(
        type: SavingsTransactionType.openingBalance,
        accountId: main.id,
        amount: 100,
      ),
      throwsArgumentError,
    );
  });

  test('gold trades update holdings and salary cash balance', () async {
    final store = TrackerStore();
    await store.load();
    await store.save(store.data.copyWith(
      goldPrice: 250,
      entries: [
        FinanceEntry(
          id: 'opening',
          type: FinanceType.adjustment,
          amount: 1000,
          balanceDelta: 1000,
          date: DateTime(2025),
          description: 'Opening balance',
        ),
      ],
    ));
    addTearDown(store.dispose);

    await store.tradeGold(type: GoldTradeType.buy, grams: 2);
    await store.tradeGold(type: GoldTradeType.sell, grams: 0.5);

    expect(store.data.totalGoldGrams, 1.5);
    expect(store.data.salaryBalance, 625);
    expect(
      store.data.entries.where((entry) => entry.type == FinanceType.expense),
      hasLength(1),
    );
    expect(
      store.data.entries.where((entry) => entry.type == FinanceType.income),
      hasLength(1),
    );
  });

  test('gold trades reject overselling and purchases beyond available cash',
      () async {
    final store = TrackerStore();
    await store.load();
    await store.save(store.data.copyWith(
      goldPrice: 250,
      items: const [
        TrackedItem(
          id: 'existing-gold',
          name: 'Existing gold',
          kind: ItemKind.gold,
          goldGrams: 1,
        ),
      ],
      entries: [
        FinanceEntry(
          id: 'opening',
          type: FinanceType.adjustment,
          amount: 100,
          balanceDelta: 100,
          date: DateTime(2025),
          description: 'Opening balance',
        ),
      ],
    ));
    addTearDown(store.dispose);

    await expectLater(
      store.tradeGold(type: GoldTradeType.buy, grams: 1),
      throwsArgumentError,
    );
    await expectLater(
      store.tradeGold(type: GoldTradeType.sell, grams: 2),
      throwsArgumentError,
    );

    expect(store.data.totalGoldGrams, 1);
    expect(store.data.goldTrades, isEmpty);
    expect(store.data.salaryBalance, 100);
  });
}
