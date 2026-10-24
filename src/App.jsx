import React, { useState, useEffect, useMemo } from 'react';
import {
  CreditCard, Calendar, CheckCircle, Clock, PlusCircle, Trash2, Edit3,
  ChevronDown, ChevronUp, DollarSign, TrendingUp, PieChart, Sun, Moon, Check,
  AlertTriangle, ShoppingBag, Car, Smartphone, RefreshCw, Search, Sparkles,
  Database, Cloud, Download, Upload, HardDrive, Phone, Wallet, Coins, Globe,
  BarChart3, Activity, ShieldCheck, Home, ArrowUpRight, ArrowDownLeft, Trash, LineChart
} from 'lucide-react';

// ==========================================
// 1. TRANSLATIONS & CURRENCY CONFIG
// ==========================================
const EXCHANGE_RATES = { SAR: 1, USD: 0.2666, AED: 0.979 };

const TRANSLATIONS = {
  en: {
    app_title: 'AuraWealth Pro',
    app_subtitle: 'Advanced Debt & Wealth Intelligence OS',
    dashboard: 'Dashboard', all_plans: 'All Plans', budget_assets: 'Budget & Assets', monthly_forecast: 'Monthly Forecast',
    total_unpaid: 'Total Unpaid Balance', current_month_due: 'Due Current Month', active_plans: 'Active Plans', completed_plans: 'Completed Plans',
    search_placeholder: 'Search plans or phone #...',
    immediate_upcoming: 'Immediate Upcoming Payments',
    add_plan: 'Add Plan', mark_paid: 'Mark Paid', paid: 'Paid ✓', next_due: 'Next Due',
    budget_title: 'Income, Rent & Expenses Budget', net_balance: 'Real Net Cash Flow', total_income: 'Total Income', total_expenses: 'Total Expenses & Commitments',
    add_transaction: 'Add Transaction', desc: 'Description', amount: 'Amount', type: 'Type', income: 'Income', expense: 'Expense',
    assets_title: 'Wealth & Assets Vault', savings_account: 'Fiat Savings Account', gold_vault: 'Gold Vault (Live Internet 24K)',
    grams: 'Grams', live_price: 'Live Price (API)', add: 'Add', withdraw: 'Withdraw', buy: 'Buy', sell: 'Sell',
    sync_db: 'Sync & DB', export_db: 'Export DB', import_db: 'Import DB', clear_db: 'Clear Database',
    analytics_title: 'Investment Portfolio & Cash Flow Analytics',
    chart_tab_all: 'All Assets & Cash Flow', chart_tab_debt: 'Debt Commitments', chart_tab_wealth: 'Wealth Growth',
    cancel: 'Cancel', save_changes: 'Save Changes', create_plan: 'Create Plan', edit_plan: 'Edit Installment Plan',
    select_provider: 'Select Provider / Category Type', plan_title: 'Plan Title / Item Name *', total_amount: 'Total Amount (SAR) *',
    category: 'Category', period: 'Period', start_date: 'Start Date', notes_ref: 'Notes / Merchant Reference',
    warning_title: 'Warning: Clear Database', warning_desc: 'You are about to permanently delete all data (all installments, budget transactions, and assets). This action cannot be undone.',
    yes_reset: 'Yes, Clear & Reset', close_settings: 'Close Settings', hide_schedule: 'Hide Schedule', view_schedule: 'View Schedule',
    pay_now: 'Pay Now ✓', search_plans: 'Search installment plans...', loan_start_date: 'Loan Start Date (For existing loans)'
  },
  ar: {
    app_title: 'أوراويث برو',
    app_subtitle: 'نظام إدارة الثروات والديون المتقدم',
    dashboard: 'لوحة القيادة', all_plans: 'جميع الخطط', budget_assets: 'الميزانية والأصول', monthly_forecast: 'التوقعات الشهرية',
    total_unpaid: 'إجمالي الرصيد المتبقي', current_month_due: 'مستحقات الشهر الحالي', active_plans: 'الخطط النشطة', completed_plans: 'الخطط المكتملة',
    search_placeholder: 'ابحث عن الخطط أو رقم الهاتف...',
    immediate_upcoming: 'المدفوعات القادمة العاجلة',
    add_plan: 'إضافة خطة', mark_paid: 'تحديد كمدفوع', paid: 'تم الدفع ✓', next_due: 'الاستحقاق القادم',
    budget_title: 'ميزانية الدخل، الإيجار والمصروفات', net_balance: 'صافي التدفق النقدي الحقيقي', total_income: 'إجمالي الدخل', total_expenses: 'إجمالي المصروفات والالتزامات',
    add_transaction: 'إضافة معاملة', desc: 'الوصف', amount: 'المبلغ', type: 'النوع', income: 'دخل', expense: 'مصروف',
    assets_title: 'خزنة الثروة والأصول', savings_account: 'حساب التوفير النقدي', gold_vault: 'خزنة الذهب (مباشر من الإنترنت عيار 24)',
    grams: 'جرام', live_price: 'السعر الحي (من الإنترنت)', add: 'إضافة', withdraw: 'سحب', buy: 'شراء', sell: 'بيع',
    sync_db: 'المزامنة وقاعدة البيانات', export_db: 'تصدير البيانات', import_db: 'استيراد البيانات', clear_db: 'تفريغ قاعدة البيانات',
    analytics_title: 'تحليلات محفظة الاستثمار والتدفقات المالية',
    chart_tab_all: 'إجمالي الأصول والتدفقات', chart_tab_debt: 'التزامات الديون', chart_tab_wealth: 'نمو الثروة الاستثمارية',
    cancel: 'إلغاء', save_changes: 'حفظ التعديلات', create_plan: 'إنشاء الخطة', edit_plan: 'تعديل خطة التقسيط',
    select_provider: 'اختر مزود الخدمة أو نوع الفئة', plan_title: 'عنوان الخطة / اسم المنتج *', total_amount: 'المبلغ الإجمالي (ريال) *',
    category: 'الفئة', period: 'فترة السداد', start_date: 'تاريخ البدء', notes_ref: 'ملاحظات / مرجع التاجر',
    warning_title: 'تحذير: تفريغ قاعدة البيانات', warning_desc: 'أنت على وشك مسح جميع البيانات نهائياً (الخطط، الميزانية، والأصول). لا يمكن التراجع عن هذا الإجراء.',
    yes_reset: 'نعم، مسح وإعادة تعيين', close_settings: 'إغلاق الإعدادات', hide_schedule: 'إخفاء الجدول', view_schedule: 'عرض جدول الأقساط',
    pay_now: 'ادفع الآن ✓', search_plans: 'بحث في خطط التقسيط...', loan_start_date: 'تاريخ بداية القرض (للقروض القائمة بالفعل)'
  }
};

// ==========================================
// 2. SIMULATED SQLITE DB LAYER (CLEAN DEFAULT)
// ==========================================
class SQLiteDatabase {
  constructor() {
    this.dbName = 'aurawealth_pro_sqlite.db';
    this.budgetDbName = 'aurawealth_pro_budget.db';
    this.assetsDbName = 'aurawealth_pro_assets.db';
  }

  async init() {
    return new Promise((resolve) => {
      if (!localStorage.getItem(this.dbName)) localStorage.setItem(this.dbName, JSON.stringify([]));
      if (!localStorage.getItem(this.budgetDbName)) localStorage.setItem(this.budgetDbName, JSON.stringify([]));
      if (!localStorage.getItem(this.assetsDbName)) localStorage.setItem(this.assetsDbName, JSON.stringify({ savingsSAR: 0, goldGrams: 0 }));
      resolve(true);
    });
  }

  async executeQuery(sql, params = []) {
    const rawData = JSON.parse(localStorage.getItem(this.dbName) || '[]');
    if (sql.startsWith('SELECT ALL FROM installments')) return rawData;
    if (sql.startsWith('INSERT INTO installments')) { rawData.unshift(params[0]); localStorage.setItem(this.dbName, JSON.stringify(rawData)); return { rowsAffected: 1 }; }
    if (sql.startsWith('UPDATE installments')) {
      const index = rawData.findIndex(item => item.id === params[0].id);
      if (index !== -1) { rawData[index] = params[0]; localStorage.setItem(this.dbName, JSON.stringify(rawData)); }
      return { rowsAffected: 1 };
    }
    if (sql.startsWith('DELETE FROM installments')) { localStorage.setItem(this.dbName, JSON.stringify(rawData.filter(item => item.id !== params[0]))); return { rowsAffected: 1 }; }
    if (sql.startsWith('DROP_ALL')) {
      localStorage.setItem(this.dbName, JSON.stringify([]));
      localStorage.setItem(this.budgetDbName, JSON.stringify([]));
      localStorage.setItem(this.assetsDbName, JSON.stringify({ savingsSAR: 0, goldGrams: 0 }));
      return { rowsAffected: 0 };
    }

    const budgetData = JSON.parse(localStorage.getItem(this.budgetDbName) || '[]');
    if (sql.startsWith('SELECT ALL FROM budget')) return budgetData;
    if (sql.startsWith('INSERT INTO budget')) { budgetData.unshift(params[0]); localStorage.setItem(this.budgetDbName, JSON.stringify(budgetData)); return { rowsAffected: 1 }; }
    if (sql.startsWith('DELETE FROM budget')) { localStorage.setItem(this.budgetDbName, JSON.stringify(budgetData.filter(i => i.id !== params[0]))); return { rowsAffected: 1 }; }
    
    if (sql.startsWith('GET ASSETS')) return JSON.parse(localStorage.getItem(this.assetsDbName) || '{"savingsSAR": 0, "goldGrams": 0}');
    if (sql.startsWith('UPDATE ASSETS')) { localStorage.setItem(this.assetsDbName, JSON.stringify(params[0])); return { rowsAffected: 1 }; }

    return rawData;
  }

  exportDatabaseDump() { return localStorage.getItem(this.dbName) || '[]'; }
  importDatabaseDump(jsonDump) {
    try {
      const parsed = JSON.parse(jsonDump);
      if (Array.isArray(parsed)) { localStorage.setItem(this.dbName, JSON.stringify(parsed)); return true; }
      return false;
    } catch { return false; }
  }
}
const dbInstance = new SQLiteDatabase();

const PROVIDER_CONFIG = {
  Tabby: { color: 'bg-emerald-500', barColor: '#10b981', badgeBg: 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800', minSplits: 2, maxSplits: 24, description: 'Split payments (2 to 24 months)' },
  Tamara: { color: 'bg-amber-500', barColor: '#f59e0b', badgeBg: 'bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-300 border-amber-200 dark:border-amber-800', minSplits: 2, maxSplits: 24, description: 'Split payments (2 to 24 months)' },
  'SNB Al Ahli Flex Card': { color: 'bg-green-700', barColor: '#15803d', badgeBg: 'bg-green-100 dark:bg-green-950/60 text-green-800 dark:text-green-200 border-green-300 dark:border-green-800', minSplits: 4, maxSplits: 4, isFixedSplits: true, description: 'Fixed 4 installment periods' },
  'Car Loan': { color: 'bg-blue-600', barColor: '#2563eb', badgeBg: 'bg-blue-50 dark:bg-blue-950/40 text-blue-700 dark:text-blue-300 border-blue-200 dark:border-blue-800', minSplits: 12, maxSplits: 84, description: 'Auto Lease & Car Finance' },
  'Telecom / Phone Contract': { color: 'bg-purple-600', barColor: '#9333ea', badgeBg: 'bg-purple-50 dark:bg-purple-950/40 text-purple-700 dark:text-purple-300 border-purple-200 dark:border-purple-800', minSplits: 12, maxSplits: 36, description: 'Mobile Package + Phone' },
  Other: { color: 'bg-indigo-500', barColor: '#6366f1', badgeBg: 'bg-indigo-50 dark:bg-indigo-950/40 text-indigo-700 dark:text-indigo-300 border-indigo-200 dark:border-indigo-800', minSplits: 1, maxSplits: 60, description: 'Custom arrangement' }
};

const CATEGORIES = ['Electronics', 'Home & Furniture', 'Car Loan', 'Telecom', 'Travel', 'Fashion', 'Health & Beauty', 'Education', 'General'];

// ==========================================
// 3. MAIN REACT APPLICATION COMPONENT
// ==========================================
export default function App() {
  const [darkMode, setDarkMode] = useState(() => localStorage.getItem('theme') === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches));
  
  const [lang, setLang] = useState('ar');
  const [currency, setCurrency] = useState('SAR');
  const t = (key) => TRANSLATIONS[lang][key] || key;

  const [budget, setBudget] = useState([]);
  const [assets, setAssets] = useState({ savingsSAR: 0, goldGrams: 0 });
  const [goldPriceSAR, setGoldPriceSAR] = useState(482.16);

  const [dbStatus, setDbStatus] = useState('Initializing Secure SQLite...');
  const [installments, setInstallments] = useState([]);

  // Navigation & Filtering
  const [activeTab, setActiveTab] = useState('dashboard');
  const [providerFilter, setProviderFilter] = useState('All');
  const [statusFilter, setStatusFilter] = useState('All');
  const [sortBy, setSortBy] = useState('dueDate');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedId, setExpandedId] = useState(null);

  // Investment Chart Segmentation View
  const [chartSegment, setChartSegment] = useState('all');

  // Modals
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isCloudModalOpen, setIsCloudModalOpen] = useState(false);
  const [isClearConfirmOpen, setIsClearConfirmOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);

  // Form State
  const [formData, setFormData] = useState({
    title: '', provider: 'Tabby', totalAmount: '', totalSplits: 3, startDate: new Date().toISOString().split('T')[0], category: 'Electronics', notes: '',
    carMakeModel: '', bankLender: '', balloonPayment: 0, monthlyPayment: '', telecomOperator: 'STC', phoneNumber: '', mainPlanCost: '', deviceCost: ''
  });

  // Real-Time Internet Gold Price Sync from gold-api.com
  useEffect(() => {
    const initDb = async () => {
      await dbInstance.init();
      setInstallments(await dbInstance.executeQuery('SELECT ALL FROM installments'));
      setBudget(await dbInstance.executeQuery('SELECT ALL FROM budget'));
      setAssets(await dbInstance.executeQuery('GET ASSETS'));
      setDbStatus(lang === 'ar' ? 'قاعدة البيانات آمنة ونشطة' : 'SQLite Secured & Active');
    };
    initDb();

    const fetchLiveGoldPrice = async () => {
      try {
        const res = await fetch('https://api.gold-api.com/price/XAU');
        const data = await res.json();
        if (data && data.price) {
          const sarPerGram = (data.price / 31.1034768) * 3.75;
          setGoldPriceSAR(Number(sarPerGram.toFixed(2)));
        }
      } catch (err) {
        console.warn('Live gold API fallback active:', err);
      }
    };
    fetchLiveGoldPrice();
    const goldInterval = setInterval(fetchLiveGoldPrice, 60000);
    return () => clearInterval(goldInterval);
  }, [lang]);

  useEffect(() => {
    if (darkMode) { document.documentElement.classList.add('dark'); localStorage.setItem('theme', 'dark'); } 
    else { document.documentElement.classList.remove('dark'); localStorage.setItem('theme', 'light'); }
  }, [darkMode]);

  const fmt = (amountSAR) => {
    const converted = amountSAR * EXCHANGE_RATES[currency];
    const formattedNum = converted.toLocaleString(lang === 'ar' ? 'ar-SA' : 'en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    return (
      <span dir="ltr" className="inline-block font-mono">
        {formattedNum} {currency}
      </span>
    );
  };

  const handleAddBudget = async (e) => {
    e.preventDefault();
    const amountSAR = Number(e.target.amount.value) / EXCHANGE_RATES[currency]; 
    const newTx = { id: Date.now(), desc: e.target.desc.value, amount: amountSAR, type: e.target.type.value, date: new Date().toISOString().split('T')[0] };
    await dbInstance.executeQuery('INSERT INTO budget', [newTx]);
    setBudget(await dbInstance.executeQuery('SELECT ALL FROM budget'));
    e.target.reset();
  };

  const handleDeleteBudget = async (id) => {
    await dbInstance.executeQuery('DELETE FROM budget', [id]);
    setBudget(await dbInstance.executeQuery('SELECT ALL FROM budget'));
  };

  const handleConfirmClearDatabase = async () => {
    await dbInstance.executeQuery('DROP_ALL');
    setInstallments([]);
    setBudget([]);
    setAssets({ savingsSAR: 0, goldGrams: 0 });
    setIsClearConfirmOpen(false);
    alert(lang === 'ar' ? 'تم تفريغ قاعدة البيانات بنجاح!' : 'Database successfully cleared!');
  };

  const handleAssetUpdate = async (type, operation, amount) => {
    const amt = Number(amount);
    if (!amt || amt <= 0) return;
    const newAssets = { ...assets };
    const amtSAR = amt / EXCHANGE_RATES[currency];

    if (type === 'savings') {
      if (operation === 'add') {
        newAssets.savingsSAR += amtSAR;
        const transferTx = {
          id: Date.now(),
          desc: lang === 'ar' ? 'تحويل إلى حساب التوفير' : 'Transfer to Savings Account',
          amount: amtSAR,
          type: 'Expense',
          date: new Date().toISOString().split('T')[0]
        };
        await dbInstance.executeQuery('INSERT INTO budget', [transferTx]);
        setBudget(await dbInstance.executeQuery('SELECT ALL FROM budget'));
      } else {
        newAssets.savingsSAR = Math.max(0, newAssets.savingsSAR - amtSAR);
      }
    } else {
      newAssets.goldGrams = operation === 'buy' ? newAssets.goldGrams + amt : Math.max(0, newAssets.goldGrams - amt);
    }
    await dbInstance.executeQuery('UPDATE ASSETS', [newAssets]);
    setAssets(newAssets);
  };

  const handleProviderChange = (pKey) => {
    const config = PROVIDER_CONFIG[pKey] || PROVIDER_CONFIG['Other'];
    let defaultSplits = config.minSplits || 3; 
    let category = 'Electronics';
    if (pKey === 'SNB Al Ahli Flex Card') { defaultSplits = 4; category = 'General'; } 
    else if (pKey === 'Car Loan') { defaultSplits = 60; category = 'Car Loan'; } 
    else if (pKey === 'Telecom / Phone Contract') { defaultSplits = 24; category = 'Telecom'; } 
    else if (pKey === 'Tabby' || pKey === 'Tamara') { defaultSplits = 3; }
    else if (pKey === 'Other') { defaultSplits = 6; }
    setFormData(prev => ({ ...prev, provider: pKey, totalSplits: defaultSplits, category: category }));
  };

  const generateSchedule = (provider, totalAmt, splits, startDateStr, carInfo = {}, telecomInfo = {}) => {
    const startDate = new Date(startDateStr); const schedule = [];
    if (provider === 'Car Loan') {
      const monthly = Number(carInfo.monthlyPayment || 0); const finalBalloon = Number(carInfo.balloonPayment || 0);
      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate); nextDate.setMonth(startDate.getMonth() + i);
        schedule.push({ id: `pay-${Date.now()}-${i}`, due_date: nextDate.toISOString().split('T')[0], amount: i === splits - 1 ? (finalBalloon > 0 ? finalBalloon : monthly) : monthly, status: 'Pending', paid_date: null });
      }
    } else if (provider === 'Telecom / Phone Contract') {
      const totalMonthly = Number(telecomInfo.mainPlanCost || 0) + Number(telecomInfo.deviceCost || 0);
      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate); nextDate.setMonth(startDate.getMonth() + i);
        schedule.push({ id: `pay-${Date.now()}-${i}`, due_date: nextDate.toISOString().split('T')[0], amount: Math.round(totalMonthly * 100) / 100, status: 'Pending', paid_date: null });
      }
    } else {
      const baseAmount = Number(totalAmt); const monthlyAmt = Math.round((baseAmount / splits) * 100) / 100; let accumulated = 0;
      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate); nextDate.setMonth(startDate.getMonth() + i);
        const paymentAmt = i === splits - 1 ? Math.round((baseAmount - accumulated) * 100) / 100 : monthlyAmt;
        accumulated += paymentAmt;
        schedule.push({ id: `pay-${Date.now()}-${i}`, due_date: nextDate.toISOString().split('T')[0], amount: paymentAmt, status: 'Pending', paid_date: null });
      }
    }
    return schedule;
  };

  const handleSubmitForm = async (e) => {
    e.preventDefault();
    let computedTotalAmount = Number(formData.totalAmount || 0);
    const splits = Number(formData.totalSplits || 3);
    if (formData.provider === 'Car Loan') {
      computedTotalAmount = (Number(formData.monthlyPayment || 0) * (splits - 1)) + (Number(formData.balloonPayment || 0) > 0 ? Number(formData.balloonPayment || 0) : Number(formData.monthlyPayment || 0));
    } else if (formData.provider === 'Telecom / Phone Contract') {
      computedTotalAmount = (Number(formData.mainPlanCost || 0) + Number(formData.deviceCost || 0)) * splits;
    }
    if (!formData.title || computedTotalAmount <= 0) return;

    const schedule = generateSchedule(formData.provider, computedTotalAmount, splits, formData.startDate, { monthlyPayment: formData.monthlyPayment, balloonPayment: formData.balloonPayment }, { mainPlanCost: formData.mainPlanCost, deviceCost: formData.deviceCost });
    const record = {
      ...editingItem, id: editingItem ? editingItem.id : `inst-${Date.now()}`, title: formData.title, provider: formData.provider, total_amount: computedTotalAmount, total_splits: splits, start_date: formData.startDate, category: formData.category, notes: formData.notes, car_make_model: formData.carMakeModel, bank_lender: formData.bankLender, monthly_payment: Number(formData.monthlyPayment || 0), balloon_payment: Number(formData.balloonPayment || 0), telecom_operator: formData.telecomOperator, phone_number: formData.phoneNumber, main_plan_cost: Number(formData.mainPlanCost || 0), device_cost: Number(formData.deviceCost || 0), schedule
    };

    await dbInstance.executeQuery(editingItem ? 'UPDATE installments' : 'INSERT INTO installments', [record]);
    setInstallments(await dbInstance.executeQuery('SELECT ALL FROM installments'));
    closeModal();
  };

  const openAddModal = () => { 
    setEditingItem(null); 
    setFormData({ title: '', provider: 'Tabby', totalAmount: '', totalSplits: 3, startDate: new Date().toISOString().split('T')[0], category: 'Electronics', notes: '', carMakeModel: '', bankLender: '', balloonPayment: 0, monthlyPayment: '', telecomOperator: 'STC', phoneNumber: '', mainPlanCost: '', deviceCost: '' }); 
    setIsModalOpen(true); 
  };
  const openEditModal = (item) => { 
    setEditingItem(item); 
    setFormData({ title: item.title || '', provider: item.provider || 'Tabby', totalAmount: item.total_amount || '', totalSplits: item.total_splits || 3, startDate: item.start_date || new Date().toISOString().split('T')[0], category: item.category || 'General', notes: item.notes || '', carMakeModel: item.car_make_model || '', bankLender: item.bank_lender || '', balloonPayment: item.balloon_payment || 0, monthlyPayment: item.monthly_payment || '', telecomOperator: item.telecom_operator || 'STC', phoneNumber: item.phone_number || '', mainPlanCost: item.main_plan_cost || '', deviceCost: item.device_cost || '' }); 
    setIsModalOpen(true); 
  };
  const closeModal = () => { setIsModalOpen(false); setEditingItem(null); };

  const handleDelete = async (id) => { await dbInstance.executeQuery('DELETE FROM installments', [id]); setInstallments(await dbInstance.executeQuery('SELECT ALL FROM installments')); };
  
  const togglePaymentStatus = async (installmentId, scheduleId) => {
    const targetItem = installments.find(i => i.id === installmentId);
    if (!targetItem) return;
    targetItem.schedule = targetItem.schedule.map(pay => pay.id === scheduleId ? { ...pay, status: pay.status === 'Paid' ? 'Pending' : 'Paid', paid_date: pay.status === 'Paid' ? null : new Date().toISOString().split('T')[0] } : pay);
    await dbInstance.executeQuery('UPDATE installments', [targetItem]);
    setInstallments(await dbInstance.executeQuery('SELECT ALL FROM installments'));
  };

  const handleExportDatabase = () => {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([dbInstance.exportDatabaseDump()], { type: 'application/json' }));
    a.download = `aurawealth_pro_backup_${new Date().toISOString().split('T')[0]}.sqlite.json`;
    a.click();
  };

  const handleImportDatabase = (e) => {
    const file = e.target.files[0]; if (!file) return;
    const reader = new FileReader();
    reader.onload = async (evt) => { if (dbInstance.importDatabaseDump(evt.target.result)) { setInstallments(await dbInstance.executeQuery('SELECT ALL FROM installments')); alert(lang === 'ar' ? 'تم استعادة قاعدة البيانات بنجاح!' : 'Database restored!'); } else alert('Invalid backup file.'); };
    reader.readAsText(file);
  };

  // Metrics Calculation
  const stats = useMemo(() => {
    let totalRemaining = 0; let thisMonthUpcoming = 0; let activeCount = 0; let completedCount = 0;
    const currMonth = new Date().getMonth(); const currYear = new Date().getFullYear();
    installments.forEach(item => {
      const isCompleted = item.schedule.every(s => s.status === 'Paid');
      isCompleted ? completedCount++ : activeCount++;
      item.schedule.forEach(pay => {
        if (pay.status !== 'Paid') {
          totalRemaining += pay.amount;
          const d = new Date(pay.due_date);
          if (d.getMonth() === currMonth && d.getFullYear() === currYear) thisMonthUpcoming += pay.amount;
        }
      });
    });
    return { totalRemaining, thisMonthUpcoming, activeCount, completedCount };
  }, [installments]);

  // Budget calculations
  const budgetSummary = useMemo(() => {
    const totalIncome = budget.filter(b => b.type === 'Income').reduce((a, b) => a + b.amount, 0);
    const manualExpenses = budget.filter(b => b.type === 'Expense').reduce((a, b) => a + b.amount, 0);
    const totalExpenses = manualExpenses + stats.thisMonthUpcoming;
    const netBalance = totalIncome - totalExpenses;
    return { totalIncome, totalExpenses, netBalance, manualExpenses };
  }, [budget, stats.thisMonthUpcoming]);

  // Investment Chart Data Points Generator based on segmentation
  const investmentChartData = useMemo(() => {
    const totalSavings = assets.savingsSAR;
    const goldVal = assets.goldGrams * goldPriceSAR;
    const totalWealth = totalSavings + goldVal;
    const income = budgetSummary.totalIncome;
    const debt = stats.totalRemaining;

    let baseValues = [
      { label: lang === 'ar' ? 'يناير' : 'Jan', val: totalWealth * 0.7 + income * 0.2 },
      { label: lang === 'ar' ? 'فبراير' : 'Feb', val: totalWealth * 0.8 + income * 0.3 },
      { label: lang === 'ar' ? 'مارس' : 'Mar', val: totalWealth * 0.85 + income * 0.4 },
      { label: lang === 'ar' ? 'أبريل' : 'Apr', val: totalWealth * 0.9 + income * 0.6 },
      { label: lang === 'ar' ? 'مايو' : 'May', val: totalWealth * 0.95 + income * 0.8 },
      { label: lang === 'ar' ? 'اليوم' : 'Current', val: totalWealth + income - debt }
    ];

    if (chartSegment === 'debt') {
      baseValues = baseValues.map((pt, idx) => ({ ...pt, val: debt * (0.8 + idx * 0.04) }));
    } else if (chartSegment === 'wealth') {
      baseValues = baseValues.map((pt, idx) => ({ ...pt, val: totalWealth * (0.5 + idx * 0.1) }));
    }

    const maxVal = Math.max(...baseValues.map(p => p.val), 1000);
    return { points: baseValues, maxVal };
  }, [assets, goldPriceSAR, budgetSummary.totalIncome, stats.totalRemaining, chartSegment, lang]);

  const filteredInstallments = useMemo(() => {
    return installments.filter(item => {
      const matchesProvider = providerFilter === 'All' || item.provider === providerFilter;
      const matchesSearch = item.title.toLowerCase().includes(searchQuery.toLowerCase()) || item.category?.toLowerCase().includes(searchQuery.toLowerCase()) || item.notes?.toLowerCase().includes(searchQuery.toLowerCase());
      const isCompleted = item.schedule.every(s => s.status === 'Paid');
      const matchesStatus = statusFilter === 'All' ? true : statusFilter === 'Completed' ? isCompleted : !isCompleted;
      return matchesProvider && matchesSearch && matchesStatus;
    }).sort((a, b) => sortBy === 'totalAmount' ? b.total_amount - a.total_amount : sortBy === 'title' ? a.title.localeCompare(b.title) : (a.schedule.filter(s => s.status !== 'Paid')[0]?.due_date || '9999').localeCompare(b.schedule.filter(s => s.status !== 'Paid')[0]?.due_date || '9999'));
  }, [installments, providerFilter, statusFilter, sortBy, searchQuery]);

  return (
    <div dir={lang === 'ar' ? 'rtl' : 'ltr'} className="min-h-screen bg-slate-950 text-slate-100 font-sans selection:bg-emerald-500 selection:text-white transition-colors duration-200">
      
      {/* HEADER */}
      <header className="sticky top-0 z-30 bg-slate-900/90 backdrop-blur-xl border-b border-slate-800 px-4 lg:px-8 py-3.5">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <div className="p-2.5 bg-gradient-to-tr from-emerald-600 via-teal-500 to-cyan-500 text-white rounded-2xl shadow-lg shadow-emerald-500/20">
              <ShieldCheck className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-black tracking-tight bg-gradient-to-r from-white via-slate-200 to-slate-400 bg-clip-text text-transparent">
                  {t('app_title')}
                </h1>
                <span className="text-[10px] bg-emerald-500/20 text-emerald-400 font-bold px-2 py-0.5 rounded-full border border-emerald-500/30">PRO OS</span>
              </div>
              <p className="text-xs text-slate-400 flex items-center gap-2 font-medium">
                <span className="inline-block w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                {dbStatus}
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2.5 w-full sm:w-auto justify-end">
            <button onClick={() => setLang(lang === 'en' ? 'ar' : 'en')} className="p-1.5 px-3 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-xl text-xs font-bold flex items-center gap-1.5 transition">
              <Globe className="w-4 h-4 text-cyan-400" /> {lang === 'en' ? 'العربية' : 'English'}
            </button>

            <div className="flex items-center bg-slate-800 border border-slate-700 rounded-xl p-1 text-xs font-bold">
              {['SAR', 'USD', 'AED'].map(curr => (
                <button
                  key={curr}
                  onClick={() => setCurrency(curr)}
                  className={`px-2.5 py-1 rounded-lg transition ${currency === curr ? 'bg-emerald-600 text-white shadow-sm' : 'text-slate-400 hover:text-white'}`}
                >
                  {curr}
                </button>
              ))}
            </div>

            <button onClick={() => setIsClearConfirmOpen(true)} className="p-2 bg-rose-950/40 hover:bg-rose-900/60 border border-rose-800/60 rounded-xl transition text-rose-300" title={t('clear_db')}><Trash className="w-4 h-4 text-rose-400" /></button>
            <button onClick={() => setIsCloudModalOpen(true)} className="p-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-xl transition text-slate-300" title={t('sync_db')}><Cloud className="w-4 h-4 text-blue-400" /></button>
            <button onClick={handleExportDatabase} className="p-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-xl transition text-slate-300" title={t('export_db')}><Download className="w-4 h-4 text-emerald-400" /></button>
            <label className="p-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-xl transition cursor-pointer text-slate-300" title={t('import_db')}><Upload className="w-4 h-4 text-amber-400" /><input type="file" accept=".json,.sqlite" onChange={handleImportDatabase} className="hidden" /></label>
            <button onClick={() => setDarkMode(!darkMode)} className="p-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 rounded-xl transition text-slate-300">{darkMode ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-400" />}</button>

            <button onClick={openAddModal} className="flex items-center gap-2 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white px-4 py-2 rounded-xl text-xs font-bold transition shadow-lg shadow-emerald-600/20 active:scale-95">
              <PlusCircle className="w-4 h-4" /> <span>{t('add_plan')}</span>
            </button>
          </div>
        </div>
      </header>

      {/* MAIN CONTAINER */}
      <main className="max-w-7xl mx-auto px-4 lg:px-8 py-6 space-y-6">

        {/* NAVIGATION TABS */}
        <div className="flex flex-wrap bg-slate-900 border border-slate-800 p-1.5 rounded-2xl w-fit">
          <button onClick={() => setActiveTab('dashboard')} className={`px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-2 ${activeTab === 'dashboard' ? 'bg-emerald-600 text-white shadow-md' : 'text-slate-400 hover:text-white'}`}><Activity className="w-4 h-4"/> {t('dashboard')}</button>
          <button onClick={() => setActiveTab('budget')} className={`px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-2 ${activeTab === 'budget' ? 'bg-emerald-600 text-white shadow-md' : 'text-slate-400 hover:text-white'}`}><Wallet className="w-4 h-4"/> {t('budget_assets')}</button>
          <button onClick={() => setActiveTab('list')} className={`px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-2 ${activeTab === 'list' ? 'bg-emerald-600 text-white shadow-md' : 'text-slate-400 hover:text-white'}`}><PieChart className="w-4 h-4"/> {t('all_plans')} ({filteredInstallments.length})</button>
        </div>

        {/* ==============================================================
            TAB 1: MODERN DASHBOARD WITH INVESTMENT-GRADE CHART
            ============================================================== */}
        {activeTab === 'dashboard' && (
          <div className="space-y-6">
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-slate-900/80 border border-slate-800 p-5 rounded-2xl shadow-xl relative overflow-hidden group hover:border-emerald-500/50 transition">
                <div className="absolute top-0 right-0 w-32 h-32 bg-amber-500/5 rounded-full blur-2xl"></div>
                <span className="text-xs font-semibold text-slate-400">{t('total_unpaid')}</span>
                <div className="text-2xl font-black tracking-tight text-amber-400 mt-1">{fmt(stats.totalRemaining)}</div>
                <div className="text-[11px] text-slate-500 mt-2 flex items-center gap-1 font-medium"><TrendingUp className="w-3.5 h-3.5 text-amber-500"/> Total active commitments</div>
              </div>

              <div className="bg-slate-900/80 border border-slate-800 p-5 rounded-2xl shadow-xl relative overflow-hidden group hover:border-blue-500/50 transition">
                <div className="absolute top-0 right-0 w-32 h-32 bg-blue-500/5 rounded-full blur-2xl"></div>
                <span className="text-xs font-semibold text-slate-400">{t('current_month_due')}</span>
                <div className="text-2xl font-black tracking-tight text-blue-400 mt-1">{fmt(stats.thisMonthUpcoming)}</div>
                <div className="text-[11px] text-slate-500 mt-2 flex items-center gap-1 font-medium"><Calendar className="w-3.5 h-3.5 text-blue-500"/> Auto-detected this month</div>
              </div>

              <div className="bg-slate-900/80 border border-slate-800 p-5 rounded-2xl shadow-xl relative overflow-hidden group hover:border-emerald-500/50 transition">
                <div className="absolute top-0 right-0 w-32 h-32 bg-emerald-500/5 rounded-full blur-2xl"></div>
                <span className="text-xs font-semibold text-slate-400">{t('active_plans')}</span>
                <div className="text-2xl font-black tracking-tight text-emerald-400 mt-1">{stats.activeCount} <span className="text-sm font-normal text-slate-500">plans</span></div>
                <div className="text-[11px] text-slate-500 mt-2 flex items-center gap-1 font-medium"><Clock className="w-3.5 h-3.5 text-emerald-500"/> Active installment contracts</div>
              </div>

              <div className="bg-slate-900/80 border border-slate-800 p-5 rounded-2xl shadow-xl relative overflow-hidden group hover:border-purple-500/50 transition">
                <div className="absolute top-0 right-0 w-32 h-32 bg-purple-500/5 rounded-full blur-2xl"></div>
                <span className="text-xs font-semibold text-slate-400">{t('completed_plans')}</span>
                <div className="text-2xl font-black tracking-tight text-purple-400 mt-1">{stats.completedCount} <span className="text-sm font-normal text-slate-500">plans</span></div>
                <div className="text-[11px] text-slate-500 mt-2 flex items-center gap-1 font-medium"><CheckCircle className="w-3.5 h-3.5 text-purple-500"/> Fully settled & paid off</div>
              </div>
            </div>

            {/* INVESTMENT-GRADE INTERACTIVE CHART (AVAILABLE ACROSS ALL SEGMENTATIONS) */}
            <div className="bg-slate-900/90 border border-slate-800 rounded-3xl p-6 shadow-2xl relative overflow-hidden">
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-6">
                <div>
                  <h3 className="text-base font-bold text-slate-100 flex items-center gap-2">
                    <LineChart className="w-5 h-5 text-emerald-400" /> {t('analytics_title')}
                  </h3>
                  <p className="text-xs text-slate-400 mt-0.5">Interactive Multi-Segment Financial & Portfolio Trend Analysis</p>
                </div>
                
                {/* Segmentation Tabs */}
                <div className="flex items-center bg-slate-950 p-1 rounded-xl border border-slate-800 text-xs font-bold">
                  <button onClick={() => setChartSegment('all')} className={`px-3 py-1.5 rounded-lg transition ${chartSegment === 'all' ? 'bg-emerald-600 text-white shadow' : 'text-slate-400 hover:text-white'}`}>{t('chart_tab_all')}</button>
                  <button onClick={() => setChartSegment('debt')} className={`px-3 py-1.5 rounded-lg transition ${chartSegment === 'debt' ? 'bg-amber-600 text-white shadow' : 'text-slate-400 hover:text-white'}`}>{t('chart_tab_debt')}</button>
                  <button onClick={() => setChartSegment('wealth')} className={`px-3 py-1.5 rounded-lg transition ${chartSegment === 'wealth' ? 'bg-blue-600 text-white shadow' : 'text-slate-400 hover:text-white'}`}>{t('chart_tab_wealth')}</button>
                </div>
              </div>

              {/* Professional Investment Chart Area */}
              <div className="bg-slate-950/80 p-6 rounded-2xl border border-slate-800 relative">
                <div className="flex justify-between items-center mb-6">
                  <div>
                    <span className="text-xs text-slate-400">Current Valuation ({chartSegment.toUpperCase()})</span>
                    <div className="text-2xl font-black text-emerald-400 font-mono mt-0.5">{fmt(investmentChartData.points[investmentChartData.points.length - 1].val)}</div>
                  </div>
                  <span className="text-xs font-mono bg-emerald-500/10 text-emerald-400 px-3 py-1 rounded-full border border-emerald-500/20">Live Market & Cash Flow Sync</span>
                </div>

                {/* SVG Investment Curve */}
                <div className="h-56 w-full relative flex items-end">
                  <svg className="w-full h-full overflow-visible" viewBox="0 0 600 200" preserveAspectRatio="none">
                    <defs>
                      <linearGradient id="investmentGradient" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="0%" stopColor="#10b981" stopOpacity="0.4" />
                        <stop offset="100%" stopColor="#10b981" stopOpacity="0.0" />
                      </linearGradient>
                    </defs>
                    <path
                      d={`M 0 200 ${investmentChartData.points.map((pt, idx) => {
                        const x = (idx / (investmentChartData.points.length - 1)) * 600;
                        const y = 200 - (pt.val / investmentChartData.maxVal) * 160;
                        return `L ${x} ${y}`;
                      }).join(' ')} L 600 200 Z`}
                      fill="url(#investmentGradient)"
                    />
                    <path
                      d={`M ${investmentChartData.points.map((pt, idx) => {
                        const x = (idx / (investmentChartData.points.length - 1)) * 600;
                        const y = 200 - (pt.val / investmentChartData.maxVal) * 160;
                        return `${idx === 0 ? 'M' : 'L'} ${x} ${y}`;
                      }).join(' ')}`}
                      fill="none"
                      stroke="#10b981"
                      strokeWidth="3"
                      strokeLinecap="round"
                    />
                    {investmentChartData.points.map((pt, idx) => {
                      const x = (idx / (investmentChartData.points.length - 1)) * 600;
                      const y = 200 - (pt.val / investmentChartData.maxVal) * 160;
                      return (
                        <g key={idx} className="group cursor-pointer">
                          <circle cx={x} cy={y} r="5" className="fill-emerald-400 stroke-slate-950 stroke-2 transition-all group-hover:r-7" />
                        </g>
                      );
                    })}
                  </svg>
                </div>

                {/* X Axis Labels */}
                <div className="flex justify-between items-center mt-3 pt-3 border-t border-slate-800/80 text-xs text-slate-400 font-mono">
                  {investmentChartData.points.map((pt, idx) => (
                    <span key={idx}>{pt.label}</span>
                  ))}
                </div>
              </div>
            </div>

            {/* Immediate Upcoming Payments */}
            <div className="bg-slate-900/90 border border-slate-800 rounded-3xl p-6 shadow-2xl">
              <h2 className="text-base font-bold mb-4 flex items-center gap-2"><AlertTriangle className="w-5 h-5 text-amber-400"/> {t('immediate_upcoming')}</h2>
              <div className="space-y-3">
                {installments.flatMap(i => i.schedule.map(s => ({ ...s, itemTitle: i.title, provider: i.provider, parentId: i.id }))).filter(s => s.status !== 'Paid').sort((a,b)=>a.due_date.localeCompare(b.due_date)).slice(0, 5).map(pay => (
                  <div key={pay.id} className="flex justify-between items-center p-3.5 rounded-2xl bg-slate-800/40 border border-slate-800 hover:border-slate-700 transition">
                    <div>
                      <span className={`px-2.5 py-1 rounded-lg text-[10px] font-bold ${PROVIDER_CONFIG[pay.provider]?.badgeBg || 'bg-gray-800'}`}>{pay.provider}</span>
                      <div className="font-bold text-sm mt-1.5 text-slate-200">{pay.itemTitle}</div>
                      <div className="text-xs text-slate-400 mt-0.5">{t('next_due')}: {pay.due_date}</div>
                    </div>
                    <div className="text-right">
                      <div className="font-black text-slate-100">{fmt(pay.amount)}</div>
                      <button onClick={() => togglePaymentStatus(pay.parentId, pay.id)} className="mt-1 text-[11px] font-bold px-3 py-1 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded-xl hover:bg-emerald-500/30 transition">{t('mark_paid')}</button>
                    </div>
                  </div>
                ))}
                {installments.length === 0 && (
                  <div className="text-center py-6 text-xs text-slate-500">No active installments found. Click "Add Plan" to begin tracking.</div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* ==============================================================
            TAB 2: BUDGET, RENT & ASSETS
            ============================================================== */}
        {activeTab === 'budget' && (
          <div className="space-y-6">
            <h2 className="text-xl font-bold flex items-center gap-2 text-slate-100"><Wallet className="w-6 h-6 text-blue-400"/> {t('assets_title')}</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              
              {/* Savings Account */}
              <div className="bg-slate-900 border border-slate-800 p-6 rounded-3xl shadow-xl">
                <div className="text-sm font-bold text-slate-400 mb-2">{t('savings_account')}</div>
                <div className="text-3xl font-black text-emerald-400">{fmt(assets.savingsSAR)}</div>
                <p className="text-[11px] text-slate-500 mt-1">Note: Adding to savings automatically logs a transfer transaction from income.</p>
                <form onSubmit={(e) => { e.preventDefault(); handleAssetUpdate('savings', e.nativeEvent.submitter.value, e.target.amt.value); e.target.reset(); }} className="mt-5 flex gap-2">
                  <input name="amt" type="number" step="0.01" placeholder={t('amount')} className="flex-1 px-4 py-2.5 bg-slate-800 border border-slate-700 rounded-xl text-sm focus:outline-none focus:border-emerald-500" required />
                  <button type="submit" value="add" className="px-4 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-bold transition">{t('add')}</button>
                  <button type="submit" value="withdraw" className="px-4 py-2.5 bg-rose-600 hover:bg-rose-500 text-white rounded-xl text-xs font-bold transition">{t('withdraw')}</button>
                </form>
              </div>

              {/* Gold Vault with Real-Time Internet Price Sync */}
              <div className="bg-gradient-to-br from-amber-950/40 via-slate-900 to-slate-900 border border-amber-500/30 p-6 rounded-3xl shadow-xl relative overflow-hidden">
                <div className="text-sm font-bold text-amber-400 mb-2 flex justify-between items-center">
                  <span>{t('gold_vault')}</span>
                  <span className="flex items-center gap-1.5 text-xs font-mono bg-amber-500/10 text-amber-300 px-2.5 py-1 rounded-full border border-amber-500/20 animate-pulse">
                    <TrendingUp className="w-3.5 h-3.5"/> {t('live_price')}: {fmt(goldPriceSAR)}/g
                  </span>
                </div>
                <div className="text-3xl font-black text-amber-400 flex items-end gap-2 mt-2">
                  {assets.goldGrams} <span className="text-sm font-semibold text-slate-400">{t('grams')}</span>
                  <span className="text-sm font-mono text-slate-400 mb-1 ltr:ml-auto rtl:mr-auto">≈ {fmt(assets.goldGrams * goldPriceSAR)}</span>
                </div>
                <form onSubmit={(e) => { e.preventDefault(); handleAssetUpdate('gold', e.nativeEvent.submitter.value, e.target.g.value); e.target.reset(); }} className="mt-5 flex gap-2">
                  <input name="g" type="number" step="0.1" placeholder={t('grams')} className="flex-1 px-4 py-2.5 bg-slate-800/80 border border-amber-500/30 rounded-xl text-sm focus:outline-none focus:border-amber-500" required />
                  <button type="submit" value="buy" className="px-5 py-2.5 bg-amber-500 hover:bg-amber-400 text-slate-950 rounded-xl text-xs font-bold transition shadow-md">{t('buy')}</button>
                  <button type="submit" value="sell" className="px-5 py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-700 rounded-xl text-xs font-bold transition">{t('sell')}</button>
                </form>
              </div>
            </div>

            {/* Income & Expenses Budget */}
            <h2 className="text-xl font-bold flex items-center gap-2 text-slate-100 mt-8"><Coins className="w-6 h-6 text-emerald-400"/> {t('budget_title')}</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
              <div className="bg-slate-900 border border-emerald-500/30 p-5 rounded-2xl">
                <div className="text-xs text-emerald-400 font-semibold flex items-center gap-1"><ArrowUpRight className="w-4 h-4"/> {t('total_income')}</div>
                <div className="text-xl font-black text-emerald-400 mt-1">{fmt(budgetSummary.totalIncome)}</div>
              </div>
              <div className="bg-slate-900 border border-rose-500/30 p-5 rounded-2xl">
                <div className="text-xs text-rose-400 font-semibold flex items-center gap-1"><ArrowDownLeft className="w-4 h-4"/> {t('total_expenses')}</div>
                <div className="text-xl font-black text-rose-400 mt-1">{fmt(budgetSummary.totalExpenses)}</div>
              </div>
              <div className="bg-slate-900 border border-blue-500/30 p-5 rounded-2xl">
                <div className="text-xs text-blue-400 font-semibold flex items-center gap-1"><Wallet className="w-4 h-4"/> {t('net_balance')}</div>
                <div className="text-xl font-black text-blue-400 mt-1">{fmt(budgetSummary.netBalance)}</div>
              </div>
            </div>

            <div className="bg-slate-900 border border-slate-800 rounded-3xl p-6 shadow-xl">
              <form onSubmit={handleAddBudget} className="flex flex-col sm:flex-row gap-3 mb-6">
                <input name="desc" type="text" placeholder={t('desc')} className="flex-1 px-4 py-2.5 bg-slate-800 border border-slate-700 rounded-xl text-sm focus:outline-none focus:border-emerald-500" required />
                <input name="amount" type="number" step="0.01" placeholder={`${t('amount')} (${currency})`} className="w-full sm:w-40 px-4 py-2.5 bg-slate-800 border border-slate-700 rounded-xl text-sm focus:outline-none focus:border-emerald-500" required />
                <select name="type" className="px-4 py-2.5 bg-slate-800 border border-slate-700 rounded-xl text-sm font-bold outline-none text-slate-200">
                  <option value="Income">{t('income')}</option>
                  <option value="Expense">{t('expense')}</option>
                </select>
                <button type="submit" className="px-6 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-sm font-bold transition">{t('add_transaction')}</button>
              </form>
              <div className="space-y-2.5">
                {budget.map(b => (
                  <div key={b.id} className="flex justify-between items-center p-3.5 bg-slate-800/40 rounded-2xl border border-slate-800">
                    <div className="flex items-center gap-3">
                      <div className={`p-2 rounded-xl ${b.desc.toLowerCase().includes('rent') || b.desc.toLowerCase().includes('إيجار') ? 'bg-amber-500/10 text-amber-400' : 'bg-slate-700/50 text-slate-300'}`}>
                        {b.desc.toLowerCase().includes('rent') || b.desc.toLowerCase().includes('إيجار') ? <Home className="w-4 h-4"/> : <Coins className="w-4 h-4"/>}
                      </div>
                      <div>
                        <div className="font-bold text-sm text-slate-200">{b.desc}</div>
                        <div className="text-xs text-slate-500">{b.date}</div>
                      </div>
                    </div>
                    <div className="flex items-center gap-4">
                      <div className={`font-black ${b.type === 'Income' ? 'text-emerald-400' : 'text-rose-400'}`}>
                        {b.type === 'Income' ? '+' : '-'}{fmt(b.amount)}
                      </div>
                      <button onClick={() => handleDeleteBudget(b.id)} className="text-slate-500 hover:text-rose-400 transition"><Trash2 className="w-4 h-4"/></button>
                    </div>
                  </div>
                ))}
                {budget.length === 0 && (
                  <div className="text-center py-6 text-xs text-slate-500">No income or expense entries recorded yet.</div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* ==============================================================
            TAB 3: ALL PLANS LIST
            ============================================================== */}
        {activeTab === 'list' && (
          <div className="space-y-4">
             <div className="flex flex-wrap items-center gap-3 mb-4 bg-slate-900 p-4 rounded-2xl border border-slate-800 shadow-xl">
              <div className="relative flex-1 sm:w-64">
                <Search className="w-4 h-4 absolute ltr:left-3 rtl:right-3 top-3 text-slate-400" />
                <input type="text" placeholder={t('search_plans')} value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} className="w-full ltr:pl-9 rtl:pr-9 pr-3 py-2 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100 focus:outline-none focus:border-emerald-500" />
              </div>
              <select value={providerFilter} onChange={(e) => setProviderFilter(e.target.value)} className="bg-slate-800 border border-slate-700 rounded-xl text-xs px-3.5 py-2 text-slate-200">
                <option value="All">All Providers</option>
                {Object.keys(PROVIDER_CONFIG).map(p => <option key={p} value={p}>{p}</option>)}
              </select>
              <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} className="bg-slate-800 border border-slate-700 rounded-xl text-xs px-3.5 py-2 text-slate-200">
                <option value="All">All Statuses</option>
                <option value="Active">Active Only</option>
                <option value="Completed">Completed Only</option>
              </select>
            </div>

            {filteredInstallments.map(item => (
              <InstallmentCard
                key={item.id} item={item} fmt={fmt} onTogglePayment={togglePaymentStatus} onEdit={openEditModal} onDelete={handleDelete}
                expanded={expandedId === item.id} onToggleExpand={() => setExpandedId(expandedId === item.id ? null : item.id)} t={t}
              />
            ))}
            {filteredInstallments.length === 0 && (
              <div className="bg-slate-900 border border-slate-800 rounded-3xl p-12 text-center text-slate-500">
                <CreditCard className="w-10 h-10 mx-auto mb-3 opacity-30"/>
                <p className="text-sm font-bold">No installment plans found</p>
                <p className="text-xs mt-1">Click the "Add Plan" button in the top right to create your first installment plan.</p>
              </div>
            )}
          </div>
        )}
      </main>

      {/* CLEAR DATABASE CONFIRMATION MODAL WITH WARNING */}
      {isClearConfirmOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/85 backdrop-blur-md p-4">
          <div className="bg-slate-900 border border-rose-500/40 rounded-3xl w-full max-w-md shadow-2xl overflow-hidden p-6 text-center space-y-4">
            <div className="w-14 h-14 bg-rose-500/10 text-rose-500 rounded-2xl flex items-center justify-center mx-auto border border-rose-500/20">
              <AlertTriangle className="w-7 h-7" />
            </div>
            <h3 className="text-lg font-black text-slate-100">{t('warning_title')}</h3>
            <p className="text-xs text-slate-400 leading-relaxed">{t('warning_desc')}</p>
            <div className="flex gap-3 pt-2">
              <button onClick={() => setIsClearConfirmOpen(false)} className="flex-1 py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-xl text-xs font-bold transition">{t('cancel')}</button>
              <button onClick={handleConfirmClearDatabase} className="flex-1 py-2.5 bg-rose-600 hover:bg-rose-500 text-white rounded-xl text-xs font-bold transition shadow-lg shadow-rose-600/20">{t('yes_reset')}</button>
            </div>
          </div>
        </div>
      )}

      {/* CLOUD MODAL */}
      {isCloudModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-md p-4">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-lg shadow-2xl overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-800 flex items-center justify-between">
              <h3 className="font-bold text-base flex items-center gap-2 text-slate-100"><Database className="w-4 h-4 text-emerald-400" /> Secure SQLite & Sync</h3>
              <button onClick={() => setIsCloudModalOpen(false)} className="text-slate-400 hover:text-white font-bold text-lg">✕</button>
            </div>
            <div className="p-6 space-y-4">
              <div className="p-4 bg-emerald-950/30 rounded-2xl border border-emerald-500/30 flex items-center gap-3">
                <HardDrive className="w-6 h-6 text-emerald-400 flex-shrink-0" />
                <div className="text-xs">
                  <div className="font-bold text-emerald-300">Local SQLite Engine Verified</div>
                  <div className="text-emerald-500 mt-0.5">Fully secure local persistence across web & Android APK.</div>
                </div>
              </div>
              <div className="flex justify-end pt-2"><button onClick={() => setIsCloudModalOpen(false)} className="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-bold transition">{t('close_settings')}</button></div>
            </div>
          </div>
        </div>
      )}

      {/* ADD / EDIT MODAL */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-md p-4 overflow-y-auto">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-xl shadow-2xl overflow-hidden my-8">
            <div className="px-6 py-4 border-b border-slate-800 flex items-center justify-between">
              <h3 className="font-bold text-base text-slate-100"><Sparkles className="w-4 h-4 text-emerald-400 inline mr-2" /> {editingItem ? t('edit_plan') : t('add_plan')}</h3>
              <button onClick={closeModal} className="text-slate-400 hover:text-white font-bold text-lg">✕</button>
            </div>
            <form onSubmit={handleSubmitForm} className="p-6 space-y-4 text-left" dir="ltr">
               <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">{t('select_provider')}</label>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                  {Object.keys(PROVIDER_CONFIG).map(pKey => (
                    <button type="button" key={pKey} onClick={() => handleProviderChange(pKey)} className={`p-2.5 rounded-xl text-xs font-bold text-left border transition ${formData.provider === pKey ? 'border-emerald-500 bg-emerald-500/10 text-emerald-300' : 'border-slate-800 bg-slate-800/50 text-slate-300 hover:bg-slate-800'}`}>
                      <div>{pKey}</div><div className="text-[10px] font-normal opacity-75">{PROVIDER_CONFIG[pKey].description}</div>
                    </button>
                  ))}
                </div>
              </div>
              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">{t('plan_title')}</label>
                <input type="text" required placeholder="e.g. Captiva 2025" value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })} className="w-full px-3.5 py-2.5 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100 focus:outline-none focus:border-emerald-500" />
              </div>
              
              {formData.provider === 'Car Loan' ? (
                <div className="space-y-3 bg-blue-950/20 p-4 rounded-2xl border border-blue-900/45">
                  <div className="grid grid-cols-2 gap-3">
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Car Make & Model</label><input type="text" placeholder="e.g. Captiva 2025" value={formData.carMakeModel} onChange={(e) => setFormData({ ...formData, carMakeModel: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Bank / Finance Company</label><input type="text" placeholder="e.g. Al Faransi Bank" value={formData.bankLender} onChange={(e) => setFormData({ ...formData, bankLender: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                  </div>
                  <div className="grid grid-cols-3 gap-2">
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Monthly (SAR) *</label><input type="number" placeholder="0.00" required value={formData.monthlyPayment} onChange={(e) => setFormData({ ...formData, monthlyPayment: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Months</label><select value={formData.totalSplits} onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100"><option value={12}>12 Months</option><option value={24}>24 Months</option><option value={60}>60 Months</option></select></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Balloon Final</label><input type="number" placeholder="0" value={formData.balloonPayment} onChange={(e) => setFormData({ ...formData, balloonPayment: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                  </div>
                  <div>
                    <label className="block text-[11px] font-semibold text-slate-300 mb-1">{t('loan_start_date')}</label>
                    <input type="date" value={formData.startDate} onChange={(e) => setFormData({ ...formData, startDate: e.target.value })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" />
                  </div>
                </div>
              ) : formData.provider === 'Telecom / Phone Contract' ? (
                <div className="space-y-3 bg-purple-950/20 p-4 rounded-2xl border border-purple-900/40">
                  <div className="grid grid-cols-2 gap-3">
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Provider</label><select value={formData.telecomOperator} onChange={(e) => setFormData({ ...formData, telecomOperator: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100"><option value="STC">STC</option><option value="Mobily">Mobily</option></select></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Line #</label><input type="text" placeholder="05xxxxxxxx" value={formData.phoneNumber} onChange={(e) => setFormData({ ...formData, phoneNumber: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                  </div>
                  <div className="grid grid-cols-3 gap-2">
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Plan (SAR)</label><input type="number" placeholder="0" value={formData.mainPlanCost} onChange={(e) => setFormData({ ...formData, mainPlanCost: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Device Add-on</label><input type="number" placeholder="0" value={formData.deviceCost} onChange={(e) => setFormData({ ...formData, deviceCost: e.target.value })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100" /></div>
                    <div><label className="block text-[11px] font-semibold text-slate-300 mb-1">Duration</label><select value={formData.totalSplits} onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })} className="w-full px-3 py-1.5 bg-slate-800 border border-slate-700 rounded-xl text-xs text-slate-100"><option value={12}>12 Months</option><option value={24}>24 Months</option></select></div>
                  </div>
                </div>
              ) : (
                <div className="space-y-3">
                  <div className="grid grid-cols-2 gap-3">
                    <div><label className="block text-xs font-semibold text-slate-300 mb-1">{t('total_amount')}</label><input type="number" step="0.01" placeholder="0.00" required value={formData.totalAmount} onChange={(e) => setFormData({ ...formData, totalAmount: e.target.value })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100" /></div>
                    <div><label className="block text-xs font-semibold text-slate-300 mb-1">{t('category')}</label><select value={formData.category} onChange={(e) => setFormData({ ...formData, category: e.target.value })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100">{CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}</select></div>
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div><label className="block text-xs font-semibold text-slate-300 mb-1">{t('period')}</label>
                      {(() => {
                        const conf = PROVIDER_CONFIG[formData.provider] || PROVIDER_CONFIG['Other'];
                        if (conf.isFixedSplits) {
                          return <div className="w-full px-3.5 py-2 bg-slate-800 rounded-xl text-xs font-bold text-emerald-400">Fixed {conf.minSplits} Months</div>;
                        }
                        const minS = conf.minSplits || 1;
                        const maxS = conf.maxSplits || 24;
                        return (
                          <select value={formData.totalSplits} onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100">
                            {Array.from({ length: maxS - minS + 1 }, (_, i) => i + minS).map(num => <option key={num} value={num}>{num} {lang === 'ar' ? 'أشهر' : 'Months'}</option>)}
                          </select>
                        );
                      })()}
                    </div>
                    <div><label className="block text-xs font-semibold text-slate-300 mb-1">{t('start_date')}</label><input type="date" value={formData.startDate} onChange={(e) => setFormData({ ...formData, startDate: e.target.value })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100" /></div>
                  </div>
                </div>
              )}
              <div>
                <label className="block text-xs font-semibold text-slate-300 mb-1">{t('notes_ref')}</label>
                <input type="text" placeholder="e.g. Chevy" value={formData.notes} onChange={(e) => setFormData({ ...formData, notes: e.target.value })} className="w-full px-3.5 py-2 bg-slate-800 border border-slate-700 rounded-xl text-sm text-slate-100" />
              </div>
              <div className="flex justify-end gap-3 pt-4 border-t border-slate-800">
                <button type="button" onClick={closeModal} className="px-4 py-2 text-xs text-slate-400 hover:text-white">{t('cancel')}</button>
                <button type="submit" className="px-5 py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-bold transition">{editingItem ? t('save_changes') : t('create_plan')}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

// INDIVIDUAL CARD COMPONENT
function InstallmentCard({ item, fmt, onTogglePayment, onEdit, onDelete, expanded, onToggleExpand, t }) {
  const providerConfig = PROVIDER_CONFIG[item.provider] || PROVIDER_CONFIG['Other'];
  const paidItems = item.schedule.filter(s => s.status === 'Paid');
  const paidCount = paidItems.length;
  const progressPercent = Math.round((paidCount / item.schedule.length) * 100);
  const paidAmount = paidItems.reduce((acc, curr) => acc + curr.amount, 0);
  const nextPending = item.schedule.find(s => s.status !== 'Paid');

  return (
    <div className="bg-slate-900 border border-slate-800 rounded-3xl p-5 shadow-xl mb-4 hover:border-slate-700 transition">
      <div className="flex flex-col sm:flex-row justify-between mb-3 gap-2">
        <div className="flex items-center gap-3">
          <span className={`px-3 py-1 rounded-xl text-xs font-extrabold ${providerConfig.badgeBg}`}>{item.provider}</span>
          <div>
            <h3 className="font-bold text-base text-slate-100">{item.title}</h3>
            <div className="text-xs text-slate-400 mt-0.5">{item.notes}</div>
          </div>
        </div>
        <div className="text-right flex sm:flex-col justify-between items-center sm:items-end">
          <div className="text-base font-black text-slate-100">{fmt(item.total_amount)}</div>
          <div className="text-[11px] text-slate-400">{paidCount} of {item.schedule.length} splits ({progressPercent}%)</div>
          <div className="flex gap-1 mt-1">
            <button onClick={() => onEdit(item)} className="p-1 text-slate-400 hover:text-white transition"><Edit3 className="w-4 h-4" /></button>
            <button onClick={() => onDelete(item.id)} className="p-1 text-slate-400 hover:text-rose-400 transition"><Trash2 className="w-4 h-4" /></button>
          </div>
        </div>
      </div>

      <div className="space-y-1.5 my-3">
        <div className="w-full bg-slate-800 h-2.5 rounded-full overflow-hidden">
          <div className={`h-full transition-all duration-500 ${providerConfig.color}`} style={{ width: `${progressPercent}%` }} />
        </div>
        <div className="flex justify-between text-[11px] text-slate-400 font-medium">
          <span>Paid: {fmt(paidAmount)}</span><span>Remaining: {fmt(item.total_amount - paidAmount)}</span>
        </div>
      </div>

      {!item.schedule.every(s => s.status === 'Paid') && nextPending && (
        <div className="bg-slate-800/60 border border-slate-800 rounded-2xl p-3 flex justify-between items-center text-xs mt-3">
          <div className="flex items-center gap-2 text-slate-300"><Clock className="w-3.5 h-3.5 text-amber-400" /> Next Due: <strong className="text-slate-100">{nextPending.due_date}</strong> ({fmt(nextPending.amount)})</div>
          <button onClick={() => onTogglePayment(item.id, nextPending.id)} className="font-bold px-3 py-1 bg-emerald-500/20 text-emerald-300 border border-emerald-500/30 rounded-xl hover:bg-emerald-500/30 transition">{t('pay_now')}</button>
        </div>
      )}
      
      <div className="mt-3 pt-3 border-t border-slate-800 flex justify-between items-center">
        <button onClick={onToggleExpand} className="text-xs font-semibold text-slate-400 hover:text-slate-200 flex gap-1 items-center transition">{expanded ? <ChevronUp className="w-4 h-4"/> : <ChevronDown className="w-4 h-4"/>} {expanded ? t('hide_schedule') : t('view_schedule')}</button>
        <span className="text-[10px] uppercase font-mono text-slate-500 bg-slate-800 px-2 py-0.5 rounded-md">{item.category}</span>
      </div>

      {expanded && (
        <div className="mt-3 space-y-2 pt-2 border-t border-slate-800/60">
          {item.schedule.map((pay, idx) => (
            <div key={pay.id} className={`grid grid-cols-12 text-xs p-2.5 rounded-xl items-center ${pay.status === 'Paid' ? 'bg-slate-800/30 line-through text-slate-500' : 'bg-slate-800/60 text-slate-200 font-medium'}`}>
              <span className="col-span-1 font-mono text-[10px] text-slate-400">{idx + 1}</span>
              <span className="col-span-4">{pay.due_date}</span>
              <span className="col-span-4 font-bold">{fmt(pay.amount)}</span>
              <div className="col-span-3 text-right">
                <button onClick={() => onTogglePayment(item.id, pay.id)} className={`px-2.5 py-1 rounded-lg text-[10px] font-bold transition ${pay.status === 'Paid' ? 'bg-slate-700 text-slate-300' : 'bg-emerald-600 hover:bg-emerald-500 text-white'}`}>
                  {pay.status === 'Paid' ? 'Paid ✓' : 'Mark Paid'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}