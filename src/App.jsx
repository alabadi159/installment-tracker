import React, { useState, useEffect, useMemo } from 'react';
import {
  CreditCard,
  Calendar,
  CheckCircle,
  Clock,
  PlusCircle,
  Trash2,
  Edit3,
  ChevronDown,
  ChevronUp,
  DollarSign,
  TrendingUp,
  PieChart,
  Sun,
  Moon,
  Check,
  AlertTriangle,
  ShoppingBag,
  Car,
  Smartphone,
  RefreshCw,
  Search,
  Sparkles,
  Database,
  Cloud,
  Download,
  Upload,
  Settings,
  HardDrive,
  Activity,
  CheckCircle2,
  X,
  FileText,
  ShieldAlert,
  Server,
  Layers,
  Phone
} from 'lucide-react';

// ==========================================
// 1. SIMULATED SQLITE DB LAYER (INDEXEDDB/LOCALSTORAGE WITH SQL INTERFACE)
// ==========================================

const INITIAL_SAMPLE_INSTALLMENTS = [
  {
    id: 'inst-tabby-12',
    title: 'MacBook Pro M3 Max',
    provider: 'Tabby',
    total_amount: 9600,
    total_splits: 12,
    start_date: '2026-01-15',
    category: 'Electronics',
    notes: 'Purchased from Jarir Bookstore',
    car_make_model: '',
    bank_lender: '',
    balloon_payment: 0,
    monthly_payment: 800,
    telecom_operator: '',
    phone_number: '',
    main_plan_cost: 0,
    device_cost: 0,
    schedule: Array.from({ length: 12 }, (_, index) => {
      const date = new Date(2026, index, 15);
      const isPast = index < 9;
      return {
        id: `pay-tabby-12-${index + 1}`,
        installment_id: 'inst-tabby-12',
        due_date: date.toISOString().split('T')[0],
        amount: 800,
        status: isPast ? 'Paid' : 'Pending',
        paid_date: isPast ? date.toISOString().split('T')[0] : null
      };
    })
  },
  {
    id: 'inst-tamara-6',
    title: 'Dyson Airwrap & Home Appliance',
    provider: 'Tamara',
    total_amount: 3600,
    total_splits: 6,
    start_date: '2026-06-01',
    category: 'Home & Furniture',
    notes: 'Ordered via eXtra online store',
    car_make_model: '',
    bank_lender: '',
    balloon_payment: 0,
    monthly_payment: 600,
    telecom_operator: '',
    phone_number: '',
    main_plan_cost: 0,
    device_cost: 0,
    schedule: Array.from({ length: 6 }, (_, index) => {
      const date = new Date(2026, 5 + index, 1);
      const isPast = index < 4;
      return {
        id: `pay-tamara-6-${index + 1}`,
        installment_id: 'inst-tamara-6',
        due_date: date.toISOString().split('T')[0],
        amount: 600,
        status: isPast ? 'Paid' : 'Pending',
        paid_date: isPast ? date.toISOString().split('T')[0] : null
      };
    })
  },
  {
    id: 'inst-snb-4',
    title: 'Riyadh to London Vacation Flights',
    provider: 'SNB Al Ahli Flex Card',
    total_amount: 4000,
    total_splits: 4,
    start_date: '2026-08-10',
    category: 'Travel',
    notes: '0% APR Plan - SNB Flex 4 Month Plan',
    car_make_model: '',
    bank_lender: '',
    balloon_payment: 0,
    monthly_payment: 1000,
    telecom_operator: '',
    phone_number: '',
    main_plan_cost: 0,
    device_cost: 0,
    schedule: Array.from({ length: 4 }, (_, index) => {
      const date = new Date(2026, 7 + index, 10);
      const isPast = index < 2;
      return {
        id: `pay-snb-4-${index + 1}`,
        installment_id: 'inst-snb-4',
        due_date: date.toISOString().split('T')[0],
        amount: 1000,
        status: isPast ? 'Paid' : 'Pending',
        paid_date: isPast ? date.toISOString().split('T')[0] : null
      };
    })
  },
  {
    id: 'inst-car-1',
    title: 'Hyundai Tucson 2025 Smart',
    provider: 'Car Loan',
    total_amount: 110000,
    total_splits: 60,
    start_date: '2025-01-01',
    category: 'Car Loan',
    notes: '5-Year Finance Plan with 20% Last Payment',
    car_make_model: 'Hyundai Tucson 2025',
    bank_lender: 'Al Rajhi Auto Finance',
    balloon_payment: 23000,
    monthly_payment: 1450,
    telecom_operator: '',
    phone_number: '',
    main_plan_cost: 0,
    device_cost: 0,
    schedule: Array.from({ length: 60 }, (_, index) => {
      const date = new Date(2025, index, 1);
      const isLast = index === 59;
      const amount = isLast ? 23000 : 1450;
      const isPast = index < 21;
      return {
        id: `pay-car-1-${index + 1}`,
        installment_id: 'inst-car-1',
        due_date: date.toISOString().split('T')[0],
        amount: amount,
        status: isPast ? 'Paid' : 'Pending',
        paid_date: isPast ? date.toISOString().split('T')[0] : null
      };
    })
  },
  {
    id: 'inst-telecom-1',
    title: 'STC Postpaid 4 Plan + iPhone 16 Pro',
    provider: 'Telecom / Phone Contract',
    total_amount: 11100,
    total_splits: 24,
    start_date: '2025-09-20',
    category: 'Telecom',
    notes: 'Unlimited Data 5G Line + 256GB Desert Titanium Device',
    car_make_model: '',
    bank_lender: '',
    balloon_payment: 0,
    monthly_payment: 462.50,
    telecom_operator: 'STC',
    phone_number: '+966 50 123 4567',
    main_plan_cost: 287.50,
    device_cost: 175.00,
    schedule: Array.from({ length: 24 }, (_, index) => {
      const date = new Date(2025, 8 + index, 20);
      const isPast = index < 13;
      return {
        id: `pay-telecom-1-${index + 1}`,
        installment_id: 'inst-telecom-1',
        due_date: date.toISOString().split('T')[0],
        amount: 462.50,
        status: isPast ? 'Paid' : 'Pending',
        paid_date: isPast ? date.toISOString().split('T')[0] : null
      };
    })
  }
];

// SQLite Simulator class that mimics native SQLite queries / Tauri SQLite bindings
class SQLiteDatabase {
  constructor() {
    this.dbName = 'installment_manager_sqlite.db';
    this.isInitialized = false;
  }

  async init() {
    return new Promise((resolve) => {
      const savedData = localStorage.getItem(this.dbName);
      if (!savedData) {
        localStorage.setItem(this.dbName, JSON.stringify(INITIAL_SAMPLE_INSTALLMENTS));
      }
      this.isInitialized = true;
      resolve(true);
    });
  }

  async executeQuery(sql, params = []) {
    // Simulated SQL query parser & executor over JSON SQLite storage
    const rawData = JSON.parse(localStorage.getItem(this.dbName) || '[]');

    if (sql.startsWith('SELECT ALL FROM installments')) {
      return rawData;
    }

    if (sql.startsWith('INSERT INTO installments')) {
      const [newItem] = params;
      rawData.unshift(newItem);
      localStorage.setItem(this.dbName, JSON.stringify(rawData));
      return { rowsAffected: 1 };
    }

    if (sql.startsWith('UPDATE installments')) {
      const [updatedItem] = params;
      const index = rawData.findIndex(item => item.id === updatedItem.id);
      if (index !== -1) {
        rawData[index] = updatedItem;
        localStorage.setItem(this.dbName, JSON.stringify(rawData));
      }
      return { rowsAffected: 1 };
    }

    if (sql.startsWith('DELETE FROM installments')) {
      const [id] = params;
      const filtered = rawData.filter(item => item.id !== id);
      localStorage.setItem(this.dbName, JSON.stringify(filtered));
      return { rowsAffected: 1 };
    }

    if (sql.startsWith('RESTORE_FULL_DATABASE')) {
      const [fullData] = params;
      localStorage.setItem(this.dbName, JSON.stringify(fullData));
      return { rowsAffected: fullData.length };
    }

    return rawData;
  }

  exportDatabaseDump() {
    return localStorage.getItem(this.dbName) || '[]';
  }

  importDatabaseDump(jsonDump) {
    try {
      const parsed = JSON.parse(jsonDump);
      if (Array.isArray(parsed)) {
        localStorage.setItem(this.dbName, JSON.stringify(parsed));
        return true;
      }
      return false;
    } catch {
      return false;
    }
  }
}

const dbInstance = new SQLiteDatabase();

// ==========================================
// 2. CONFIGURATION & PRESET CONSTANTS
// ==========================================

const PROVIDER_CONFIG = {
  Tabby: {
    color: 'bg-emerald-500',
    badgeBg: 'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800',
    minSplits: 4,
    maxSplits: 24,
    description: 'Split payments (4 to 24 months)'
  },
  Tamara: {
    color: 'bg-amber-500',
    badgeBg: 'bg-amber-50 dark:bg-amber-950/40 text-amber-700 dark:text-amber-300 border-amber-200 dark:border-amber-800',
    minSplits: 4,
    maxSplits: 24,
    description: 'Split payments (4 to 24 months)'
  },
  'SNB Al Ahli Flex Card': {
    color: 'bg-green-700',
    badgeBg: 'bg-green-100 dark:bg-green-950/60 text-green-800 dark:text-green-200 border-green-300 dark:border-green-800',
    minSplits: 4,
    maxSplits: 4,
    isFixedSplits: true,
    description: 'Fixed 4 installment periods'
  },
  'Car Loan': {
    color: 'bg-blue-600',
    badgeBg: 'bg-blue-50 dark:bg-blue-950/40 text-blue-700 dark:text-blue-300 border-blue-200 dark:border-blue-800',
    minSplits: 12,
    maxSplits: 84,
    description: 'Auto Lease & Car Finance (Balloon payment)'
  },
  'Telecom / Phone Contract': {
    color: 'bg-purple-600',
    badgeBg: 'bg-purple-50 dark:bg-purple-950/40 text-purple-700 dark:text-purple-300 border-purple-200 dark:border-purple-800',
    minSplits: 12,
    maxSplits: 36,
    description: 'Mobile Package + Phone Device Installment'
  },
  Other: {
    color: 'bg-indigo-500',
    badgeBg: 'bg-indigo-50 dark:bg-indigo-950/40 text-indigo-700 dark:text-indigo-300 border-indigo-200 dark:border-indigo-800',
    minSplits: 1,
    maxSplits: 60,
    description: 'Custom installment arrangement'
  }
};

const CATEGORIES = [
  'Electronics',
  'Home & Furniture',
  'Car Loan',
  'Telecom',
  'Travel',
  'Fashion',
  'Health & Beauty',
  'Education',
  'General'
];

// ==========================================
// 3. MAIN REACT APPLICATION COMPONENT
// ==========================================

export default function App() {
  const [darkMode, setDarkMode] = useState(() => {
    return localStorage.getItem('theme') === 'dark' ||
      (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches);
  });

  const [currency, setCurrency] = useState('SAR');
  const [dbStatus, setDbStatus] = useState('Initializing Local SQLite...');
  const [installments, setInstallments] = useState([]);

  // Navigation & Filtering
  const [activeTab, setActiveTab] = useState('dashboard');
  const [providerFilter, setProviderFilter] = useState('All');
  const [statusFilter, setStatusFilter] = useState('All');
  const [sortBy, setSortBy] = useState('dueDate');
  const [searchQuery, setSearchQuery] = useState('');
  const [expandedId, setExpandedId] = useState(null);

  // Modals & Settings
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isCloudModalOpen, setIsCloudModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);

  // Cloud Sync Settings State
  const [cloudSettings, setCloudSettings] = useState({
    provider: 'firebase', // firebase or supabase
    enabled: false,
    apiKey: '',
    projectUrl: '',
    syncInterval: 30
  });

  // Form State for Add / Edit
  const [formData, setFormData] = useState({
    title: '',
    provider: 'Tabby',
    totalAmount: '',
    totalSplits: 4,
    startDate: new Date().toISOString().split('T')[0],
    category: 'Electronics',
    notes: '',
    // Car specific
    carMakeModel: '',
    bankLender: '',
    balloonPayment: 0,
    monthlyPayment: '',
    // Telecom specific
    telecomOperator: 'STC',
    phoneNumber: '',
    mainPlanCost: '',
    deviceCost: ''
  });

  // Initialize SQLite Database
  useEffect(() => {
    const initDb = async () => {
      await dbInstance.init();
      const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
      setInstallments(records);
      setDbStatus('Local SQLite Connected (Native / WebSQL)');
    };
    initDb();
  }, []);

  // Dark Mode side effects
  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('theme', 'dark');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('theme', 'light');
    }
  }, [darkMode]);

  // Handle Provider Selection Change in Modal
  const handleProviderChange = (pKey) => {
    let defaultSplits = 4;
    let category = 'Electronics';

    if (pKey === 'SNB Al Ahli Flex Card') {
      defaultSplits = 4; // Strictly fixed to 4
      category = 'General';
    } else if (pKey === 'Car Loan') {
      defaultSplits = 60;
      category = 'Car Loan';
    } else if (pKey === 'Telecom / Phone Contract') {
      defaultSplits = 24;
      category = 'Telecom';
    } else if (pKey === 'Tabby' || pKey === 'Tamara') {
      defaultSplits = 4;
      category = 'Electronics';
    } else if (pKey === 'Other') {
      defaultSplits = 6;
    }

    setFormData(prev => ({
      ...prev,
      provider: pKey,
      totalSplits: defaultSplits,
      category: category
    }));
  };

  // Generate Payment Breakdown Schedule
  const generateSchedule = (provider, totalAmt, splits, startDateStr, carInfo = {}, telecomInfo = {}) => {
    const startDate = new Date(startDateStr);
    const schedule = [];

    if (provider === 'Car Loan') {
      const monthly = Number(carInfo.monthlyPayment || 0);
      const finalBalloon = Number(carInfo.balloonPayment || 0);

      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate);
        nextDate.setMonth(startDate.getMonth() + i);

        const isLast = i === splits - 1;
        const paymentAmt = isLast ? (finalBalloon > 0 ? finalBalloon : monthly) : monthly;

        schedule.push({
          id: `pay-${Date.now()}-${i}`,
          due_date: nextDate.toISOString().split('T')[0],
          amount: Math.round(paymentAmt * 100) / 100,
          status: 'Pending',
          paid_date: null
        });
      }
    } else if (provider === 'Telecom / Phone Contract') {
      const planCost = Number(telecomInfo.mainPlanCost || 0);
      const devCost = Number(telecomInfo.deviceCost || 0);
      const totalMonthly = planCost + devCost;

      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate);
        nextDate.setMonth(startDate.getMonth() + i);

        schedule.push({
          id: `pay-${Date.now()}-${i}`,
          due_date: nextDate.toISOString().split('T')[0],
          amount: Math.round(totalMonthly * 100) / 100,
          status: 'Pending',
          paid_date: null
        });
      }
    } else {
      const baseAmount = Number(totalAmt);
      const monthlyAmt = Math.round((baseAmount / splits) * 100) / 100;
      let accumulated = 0;

      for (let i = 0; i < splits; i++) {
        const nextDate = new Date(startDate);
        nextDate.setMonth(startDate.getMonth() + i);

        const isLast = i === splits - 1;
        const paymentAmt = isLast ? Math.round((baseAmount - accumulated) * 100) / 100 : monthlyAmt;
        accumulated += paymentAmt;

        schedule.push({
          id: `pay-${Date.now()}-${i}`,
          due_date: nextDate.toISOString().split('T')[0],
          amount: paymentAmt,
          status: 'Pending',
          paid_date: null
        });
      }
    }

    return schedule;
  };

  // Submit Form (Add or Edit)
  const handleSubmitForm = async (e) => {
    e.preventDefault();

    let computedTotalAmount = Number(formData.totalAmount || 0);
    const splits = Number(formData.totalSplits || 4);

    if (formData.provider === 'Car Loan') {
      const monthly = Number(formData.monthlyPayment || 0);
      const balloon = Number(formData.balloonPayment || 0);
      computedTotalAmount = (monthly * (splits - 1)) + (balloon > 0 ? balloon : monthly);
    } else if (formData.provider === 'Telecom / Phone Contract') {
      const monthlyTotal = Number(formData.mainPlanCost || 0) + Number(formData.deviceCost || 0);
      computedTotalAmount = monthlyTotal * splits;
    }

    if (!formData.title || computedTotalAmount <= 0) return;

    if (editingItem) {
      const updatedSchedule = generateSchedule(
        formData.provider,
        computedTotalAmount,
        splits,
        formData.startDate,
        { monthlyPayment: formData.monthlyPayment, balloonPayment: formData.balloonPayment },
        { mainPlanCost: formData.mainPlanCost, deviceCost: formData.deviceCost }
      );

      const updatedRecord = {
        ...editingItem,
        title: formData.title,
        provider: formData.provider,
        total_amount: computedTotalAmount,
        total_splits: splits,
        start_date: formData.startDate,
        category: formData.category,
        notes: formData.notes,
        car_make_model: formData.carMakeModel,
        bank_lender: formData.bankLender,
        monthly_payment: Number(formData.monthlyPayment || 0),
        balloon_payment: Number(formData.balloonPayment || 0),
        telecom_operator: formData.telecomOperator,
        phone_number: formData.phoneNumber,
        main_plan_cost: Number(formData.mainPlanCost || 0),
        device_cost: Number(formData.deviceCost || 0),
        schedule: updatedSchedule
      };

      await dbInstance.executeQuery('UPDATE installments', [updatedRecord]);
    } else {
      const newSchedule = generateSchedule(
        formData.provider,
        computedTotalAmount,
        splits,
        formData.startDate,
        { monthlyPayment: formData.monthlyPayment, balloonPayment: formData.balloonPayment },
        { mainPlanCost: formData.mainPlanCost, deviceCost: formData.deviceCost }
      );

      const newRecord = {
        id: `inst-${Date.now()}`,
        title: formData.title,
        provider: formData.provider,
        total_amount: computedTotalAmount,
        total_splits: splits,
        start_date: formData.startDate,
        category: formData.category,
        notes: formData.notes,
        car_make_model: formData.carMakeModel,
        bank_lender: formData.bankLender,
        monthly_payment: Number(formData.monthlyPayment || 0),
        balloon_payment: Number(formData.balloonPayment || 0),
        telecom_operator: formData.telecomOperator,
        phone_number: formData.phoneNumber,
        main_plan_cost: Number(formData.mainPlanCost || 0),
        device_cost: Number(formData.deviceCost || 0),
        schedule: newSchedule
      };

      await dbInstance.executeQuery('INSERT INTO installments', [newRecord]);
    }

    const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
    setInstallments(records);
    closeModal();
  };

  const openAddModal = () => {
    setEditingItem(null);
    setFormData({
      title: '',
      provider: 'Tabby',
      totalAmount: '',
      totalSplits: 4,
      startDate: new Date().toISOString().split('T')[0],
      category: 'Electronics',
      notes: '',
      carMakeModel: '',
      bankLender: '',
      balloonPayment: 0,
      monthlyPayment: '',
      telecomOperator: 'STC',
      phoneNumber: '',
      mainPlanCost: '',
      deviceCost: ''
    });
    setIsModalOpen(true);
  };

  const openEditModal = (item) => {
    setEditingItem(item);
    setFormData({
      title: item.title || '',
      provider: item.provider || 'Tabby',
      totalAmount: item.total_amount || '',
      totalSplits: item.total_splits || 4,
      startDate: item.start_date || new Date().toISOString().split('T')[0],
      category: item.category || 'General',
      notes: item.notes || '',
      carMakeModel: item.car_make_model || '',
      bankLender: item.bank_lender || '',
      balloonPayment: item.balloon_payment || 0,
      monthlyPayment: item.monthly_payment || '',
      telecomOperator: item.telecom_operator || 'STC',
      phoneNumber: item.phone_number || '',
      mainPlanCost: item.main_plan_cost || '',
      deviceCost: item.device_cost || ''
    });
    setIsModalOpen(true);
  };

  const closeModal = () => {
    setIsModalOpen(false);
    setEditingItem(null);
  };

  const handleDelete = async (id) => {
    await dbInstance.executeQuery('DELETE FROM installments', [id]);
    const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
    setInstallments(records);
  };

  const togglePaymentStatus = async (installmentId, scheduleId) => {
    const today = new Date().toISOString().split('T')[0];
    const targetItem = installments.find(i => i.id === installmentId);
    if (!targetItem) return;

    const updatedSchedule = targetItem.schedule.map(pay => {
      if (pay.id !== scheduleId) return pay;
      const newStatus = pay.status === 'Paid' ? 'Pending' : 'Paid';
      return {
        ...pay,
        status: newStatus,
        paid_date: newStatus === 'Paid' ? today : null
      };
    });

    const updatedItem = { ...targetItem, schedule: updatedSchedule };
    await dbInstance.executeQuery('UPDATE installments', [updatedItem]);
    const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
    setInstallments(records);
  };

  // EXPORT AND IMPORT DATABASE (.SQLITE / JSON)
  const handleExportDatabase = () => {
    const jsonDump = dbInstance.exportDatabaseDump();
    const blob = new Blob([jsonDump], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `installment_manager_db_backup_${new Date().toISOString().split('T')[0]}.sqlite.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleImportDatabase = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = async (evt) => {
      const content = evt.target.result;
      const success = dbInstance.importDatabaseDump(content);
      if (success) {
        const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
        setInstallments(records);
        alert('SQLite Database successfully restored!');
      } else {
        alert('Invalid database backup file format.');
      }
    };
    reader.readAsText(file);
  };

  const resetToDefaultData = async () => {
    await dbInstance.executeQuery('RESTORE_FULL_DATABASE', [INITIAL_SAMPLE_INSTALLMENTS]);
    const records = await dbInstance.executeQuery('SELECT ALL FROM installments');
    setInstallments(records);
  };

  // Metrics Calculation
  const stats = useMemo(() => {
    let totalRemaining = 0;
    let thisMonthUpcoming = 0;
    let activeCount = 0;
    let completedCount = 0;

    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();

    installments.forEach(item => {
      const paidCount = item.schedule.filter(s => s.status === 'Paid').length;
      const isCompleted = paidCount === item.schedule.length;

      if (isCompleted) {
        completedCount++;
      } else {
        activeCount++;
      }

      item.schedule.forEach(pay => {
        if (pay.status !== 'Paid') {
          totalRemaining += pay.amount;

          const payDate = new Date(pay.due_date);
          if (payDate.getMonth() === currentMonth && payDate.getFullYear() === currentYear) {
            thisMonthUpcoming += pay.amount;
          }
        }
      });
    });

    return { totalRemaining, thisMonthUpcoming, activeCount, completedCount };
  }, [installments]);

  // Filtering Logic
  const filteredInstallments = useMemo(() => {
    return installments
      .filter(item => {
        const matchesProvider = providerFilter === 'All' || item.provider === providerFilter;
        const matchesSearch = item.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
          item.category?.toLowerCase().includes(searchQuery.toLowerCase()) ||
          item.notes?.toLowerCase().includes(searchQuery.toLowerCase()) ||
          item.phone_number?.toLowerCase().includes(searchQuery.toLowerCase()) ||
          item.car_make_model?.toLowerCase().includes(searchQuery.toLowerCase());

        const isCompleted = item.schedule.every(s => s.status === 'Paid');
        const matchesStatus = statusFilter === 'All' ? true :
          statusFilter === 'Completed' ? isCompleted :
            statusFilter === 'Active' ? !isCompleted : true;

        return matchesProvider && matchesSearch && matchesStatus;
      })
      .sort((a, b) => {
        if (sortBy === 'totalAmount') {
          return b.total_amount - a.total_amount;
        } else if (sortBy === 'title') {
          return a.title.localeCompare(b.title);
        } else {
          const getNextDueDate = (inst) => {
            const pending = inst.schedule.filter(s => s.status !== 'Paid');
            return pending.length > 0 ? pending[0].due_date : '9999-12-31';
          };
          return getNextDueDate(a).localeCompare(getNextDueDate(b));
        }
      });
  }, [installments, providerFilter, statusFilter, sortBy, searchQuery]);

  // Monthly Forecast Grouping
  const calendarTimeline = useMemo(() => {
    const monthsMap = {};

    installments.forEach(item => {
      item.schedule.forEach(pay => {
        const d = new Date(pay.due_date);
        const monthKey = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
        const monthLabel = d.toLocaleString('default', { month: 'short', year: 'numeric' });

        if (!monthsMap[monthKey]) {
          monthsMap[monthKey] = {
            key: monthKey,
            label: monthLabel,
            totalDue: 0,
            paidTotal: 0,
            pendingTotal: 0,
            payments: []
          };
        }

        monthsMap[monthKey].totalDue += pay.amount;
        if (pay.status === 'Paid') {
          monthsMap[monthKey].paidTotal += pay.amount;
        } else {
          monthsMap[monthKey].pendingTotal += pay.amount;
        }

        monthsMap[monthKey].payments.push({
          ...pay,
          title: item.title,
          provider: item.provider,
          parentId: item.id
        });
      });
    });

    return Object.values(monthsMap).sort((a, b) => a.key.localeCompare(b.key));
  }, [installments]);

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-800 dark:text-slate-100 transition-colors duration-200">
      
      {/* HEADER / NAVIGATION BAR */}
      <header className="sticky top-0 z-30 bg-white/85 dark:bg-slate-900/85 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 px-4 lg:px-8 py-3 transition-colors">
        <div className="max-w-7xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-3">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-gradient-to-tr from-emerald-500 to-teal-600 text-white rounded-xl shadow-md">
              <CreditCard className="w-6 h-6" />
            </div>
            <div>
              <h1 className="text-xl font-bold tracking-tight bg-gradient-to-r from-slate-900 to-slate-600 dark:from-white dark:to-slate-400 bg-clip-text text-transparent">
                Installment & Loan Manager
              </h1>
              <p className="text-xs text-slate-500 dark:text-slate-400 flex items-center gap-2">
                <span className="inline-block w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                {dbStatus}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2 w-full sm:w-auto justify-end">
            {/* Database & Cloud Control Buttons */}
            <button
              onClick={() => setIsCloudModalOpen(true)}
              className="p-2 text-slate-600 dark:text-slate-300 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 rounded-lg transition text-xs font-semibold flex items-center gap-1.5"
              title="Cloud Sync & DB Settings"
            >
              <Cloud className="w-4 h-4 text-blue-500" />
              <span className="hidden sm:inline">Sync & DB</span>
            </button>

            <button
              onClick={handleExportDatabase}
              className="p-2 text-slate-600 dark:text-slate-300 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 rounded-lg transition text-xs font-semibold flex items-center gap-1.5"
              title="Export SQLite Backup"
            >
              <Download className="w-4 h-4 text-emerald-500" />
              <span className="hidden sm:inline">Export DB</span>
            </button>

            <label className="p-2 text-slate-600 dark:text-slate-300 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 rounded-lg transition text-xs font-semibold flex items-center gap-1.5 cursor-pointer">
              <Upload className="w-4 h-4 text-amber-500" />
              <span className="hidden sm:inline">Import DB</span>
              <input type="file" accept=".json,.sqlite" onChange={handleImportDatabase} className="hidden" />
            </label>

            {/* Currency Selector */}
            <div className="flex items-center bg-slate-100 dark:bg-slate-800 rounded-lg p-1 text-xs font-semibold">
              {['SAR', 'USD', 'AED'].map(curr => (
                <button
                  key={curr}
                  onClick={() => setCurrency(curr)}
                  className={`px-2.5 py-1 rounded-md transition ${currency === curr ? 'bg-white dark:bg-slate-700 shadow-xs text-emerald-600 dark:text-emerald-400' : 'text-slate-500 hover:text-slate-800 dark:hover:text-slate-200'}`}
                >
                  {curr}
                </button>
              ))}
            </div>

            {/* Dark Mode Toggle */}
            <button
              onClick={() => setDarkMode(!darkMode)}
              className="p-2 text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-100 bg-slate-100 dark:bg-slate-800 rounded-lg transition"
              aria-label="Toggle Theme"
            >
              {darkMode ? <Sun className="w-4 h-4 text-amber-400" /> : <Moon className="w-4 h-4 text-slate-600" />}
            </button>

            {/* Add Installment Button */}
            <button
              onClick={openAddModal}
              className="flex items-center gap-2 bg-emerald-600 hover:bg-emerald-700 text-white px-3.5 py-2 rounded-xl text-xs font-bold transition shadow-sm active:scale-95"
            >
              <PlusCircle className="w-4 h-4" />
              <span>Add Plan</span>
            </button>
          </div>
        </div>
      </header>

      {/* MAIN CONTENT AREA */}
      <main className="max-w-7xl mx-auto px-4 lg:px-8 py-6 space-y-6">

        {/* FINANCIAL SUMMARY CARDS */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-xs relative overflow-hidden">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-medium text-slate-500 dark:text-slate-400">Total Unpaid Balance</span>
              <div className="p-2 rounded-xl bg-amber-50 dark:bg-amber-950/40 text-amber-600 dark:text-amber-400">
                <DollarSign className="w-5 h-5" />
              </div>
            </div>
            <div className="text-2xl font-bold tracking-tight">
              {stats.totalRemaining.toLocaleString()} <span className="text-sm font-normal text-slate-500">{currency}</span>
            </div>
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1 flex items-center gap-1">
              <TrendingUp className="w-3 h-3 text-emerald-500" /> Outstanding commitments
            </p>
          </div>

          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-xs relative overflow-hidden">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-medium text-slate-500 dark:text-slate-400">Due Current Month</span>
              <div className="p-2 rounded-xl bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400">
                <Calendar className="w-5 h-5" />
              </div>
            </div>
            <div className="text-2xl font-bold tracking-tight">
              {stats.thisMonthUpcoming.toLocaleString()} <span className="text-sm font-normal text-slate-500">{currency}</span>
            </div>
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              Required monthly payments
            </p>
          </div>

          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-xs relative overflow-hidden">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-medium text-slate-500 dark:text-slate-400">Active Plans</span>
              <div className="p-2 rounded-xl bg-emerald-50 dark:bg-emerald-950/40 text-emerald-600 dark:text-emerald-400">
                <Clock className="w-5 h-5" />
              </div>
            </div>
            <div className="text-2xl font-bold tracking-tight">
              {stats.activeCount} <span className="text-sm font-normal text-slate-500">plans</span>
            </div>
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              Active installment contracts
            </p>
          </div>

          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-xs relative overflow-hidden">
            <div className="flex items-center justify-between mb-2">
              <span className="text-xs font-medium text-slate-500 dark:text-slate-400">Completed Plans</span>
              <div className="p-2 rounded-xl bg-purple-50 dark:bg-purple-950/40 text-purple-600 dark:text-purple-400">
                <CheckCircle className="w-5 h-5" />
              </div>
            </div>
            <div className="text-2xl font-bold tracking-tight">
              {stats.completedCount} <span className="text-sm font-normal text-slate-500">plans</span>
            </div>
            <p className="text-xs text-slate-400 dark:text-slate-500 mt-1">
              Fully settled & paid off
            </p>
          </div>
        </div>

        {/* PROVIDER STRIP & RULES */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-4 shadow-xs">
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-sm font-semibold text-slate-700 dark:text-slate-200 flex items-center gap-2">
              <PieChart className="w-4 h-4 text-emerald-500" /> Supported Providers & Rules
            </h2>
            <button
              onClick={resetToDefaultData}
              className="text-xs text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 flex items-center gap-1 transition"
              title="Reset sample data in SQLite"
            >
              <RefreshCw className="w-3 h-3" /> Reset Sample DB
            </button>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
            {Object.keys(PROVIDER_CONFIG).filter(k => k !== 'Other').map(pKey => {
              const config = PROVIDER_CONFIG[pKey];
              const providerItems = installments.filter(i => i.provider === pKey);
              const providerTotal = providerItems.reduce((acc, curr) => {
                const pendingAmt = curr.schedule
                  .filter(s => s.status !== 'Paid')
                  .reduce((a, b) => a + b.amount, 0);
                return acc + pendingAmt;
              }, 0);

              return (
                <div
                  key={pKey}
                  onClick={() => {
                    setProviderFilter(pKey);
                    setActiveTab('list');
                  }}
                  className={`cursor-pointer border p-3 rounded-xl transition hover:shadow-sm ${config.badgeBg}`}
                >
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-xs">{pKey}</span>
                    <span className="text-[10px] opacity-75 font-mono">{providerItems.length} active</span>
                  </div>
                  <div className="mt-2 text-base font-extrabold">
                    {providerTotal.toLocaleString()} <span className="text-[10px] font-normal">{currency}</span>
                  </div>
                  <div className="text-[10px] opacity-80 mt-1 font-medium">
                    {config.isFixedSplits ? 'Strictly 4 Periods' : `${config.minSplits} to ${config.maxSplits} Months`}
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* NAVIGATION & FILTER CONTROLS */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-200 dark:border-slate-800 pb-4">
          <div className="flex bg-slate-200/60 dark:bg-slate-800/60 p-1 rounded-xl w-fit">
            <button
              onClick={() => setActiveTab('dashboard')}
              className={`px-4 py-1.5 rounded-lg text-xs font-semibold transition ${activeTab === 'dashboard' ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs' : 'text-slate-500 hover:text-slate-800 dark:hover:text-slate-200'}`}
            >
              Dashboard
            </button>
            <button
              onClick={() => setActiveTab('list')}
              className={`px-4 py-1.5 rounded-lg text-xs font-semibold transition ${activeTab === 'list' ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs' : 'text-slate-500 hover:text-slate-800 dark:hover:text-slate-200'}`}
            >
              All Plans ({filteredInstallments.length})
            </button>
            <button
              onClick={() => setActiveTab('calendar')}
              className={`px-4 py-1.5 rounded-lg text-xs font-semibold transition ${activeTab === 'calendar' ? 'bg-white dark:bg-slate-900 text-slate-900 dark:text-white shadow-xs' : 'text-slate-500 hover:text-slate-800 dark:hover:text-slate-200'}`}
            >
              Monthly Forecast
            </button>
          </div>

          <div className="flex flex-wrap items-center gap-2">
            <div className="relative flex-1 sm:w-48">
              <Search className="w-3.5 h-3.5 absolute left-3 top-2.5 text-slate-400" />
              <input
                type="text"
                placeholder="Search plans or phone #..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-8 pr-3 py-1.5 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-emerald-500"
              />
            </div>

            <select
              value={providerFilter}
              onChange={(e) => setProviderFilter(e.target.value)}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              <option value="All">All Providers</option>
              <option value="Tabby">Tabby (4-24)</option>
              <option value="Tamara">Tamara (4-24)</option>
              <option value="SNB Al Ahli Flex Card">SNB Flex (4 Only)</option>
              <option value="Car Loan">Car Loans</option>
              <option value="Telecom / Phone Contract">Telecom & Phone</option>
              <option value="Other">Other</option>
            </select>

            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              <option value="All">All Statuses</option>
              <option value="Active">Active Only</option>
              <option value="Completed">Completed Only</option>
            </select>

            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl text-xs px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              <option value="dueDate">Next Due Date</option>
              <option value="totalAmount">Total Amount</option>
              <option value="title">Title (A-Z)</option>
            </select>
          </div>
        </div>

        {/* TAB 1: DASHBOARD VIEW */}
        {activeTab === 'dashboard' && (
          <div className="space-y-6">
            {/* Urgent / Priority Due Payments */}
            <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs">
              <h2 className="text-base font-bold text-slate-800 dark:text-slate-100 mb-4 flex items-center gap-2">
                <AlertTriangle className="w-4 h-4 text-amber-500" /> Immediate Upcoming Payments
              </h2>

              <div className="space-y-3">
                {installments
                  .flatMap(item => item.schedule.map(s => ({
                    ...s,
                    itemTitle: item.title,
                    provider: item.provider,
                    parentId: item.id,
                    phoneNumber: item.phone_number
                  })))
                  .filter(s => s.status !== 'Paid')
                  .sort((a, b) => a.due_date.localeCompare(b.due_date))
                  .slice(0, 5)
                  .map(pay => {
                    const isOverdue = new Date(pay.due_date) < new Date() && pay.status !== 'Paid';
                    const config = PROVIDER_CONFIG[pay.provider] || PROVIDER_CONFIG['Other'];

                    return (
                      <div
                        key={pay.id}
                        className="flex items-center justify-between p-3 rounded-xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-800 hover:border-slate-300 transition"
                      >
                        <div className="flex items-center gap-3">
                          <span className={`px-2.5 py-1 rounded-lg text-xs font-extrabold ${config.badgeBg}`}>
                            {pay.provider}
                          </span>
                          <div>
                            <div className="font-semibold text-sm flex items-center gap-2">
                              {pay.itemTitle}
                              {pay.phoneNumber && (
                                <span className="text-[10px] bg-purple-100 text-purple-700 dark:bg-purple-900/60 dark:text-purple-300 px-1.5 py-0.5 rounded font-mono">
                                  {pay.phoneNumber}
                                </span>
                              )}
                            </div>
                            <div className="text-xs text-slate-400 flex items-center gap-1 mt-0.5">
                              <Calendar className="w-3 h-3" /> Due: {pay.due_date}
                              {isOverdue && <span className="text-red-500 font-bold ml-1 text-[10px] uppercase">Overdue</span>}
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center gap-3">
                          <span className="font-extrabold text-sm">
                            {pay.amount.toLocaleString()} {currency}
                          </span>
                          <button
                            onClick={() => togglePaymentStatus(pay.parentId, pay.id)}
                            className="p-1.5 rounded-lg bg-emerald-100 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-200 transition text-xs font-semibold flex items-center gap-1"
                          >
                            <Check className="w-3.5 h-3.5" /> Mark Paid
                          </button>
                        </div>
                      </div>
                    );
                  })}

                {installments.flatMap(i => i.schedule).filter(s => s.status !== 'Paid').length === 0 && (
                  <div className="text-center py-6 text-slate-400 text-sm">
                    🎉 All installments are completely paid off!
                  </div>
                )}
              </div>
            </div>

            {/* Active Items Overview */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <h2 className="text-base font-bold text-slate-800 dark:text-slate-100">
                  Active Installments Overview ({filteredInstallments.length})
                </h2>
                <button
                  onClick={() => setActiveTab('list')}
                  className="text-xs text-emerald-600 dark:text-emerald-400 font-semibold hover:underline"
                >
                  View All &rarr;
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {filteredInstallments.slice(0, 4).map(item => (
                  <InstallmentCard
                    key={item.id}
                    item={item}
                    currency={currency}
                    onTogglePayment={togglePaymentStatus}
                    onEdit={openEditModal}
                    onDelete={handleDelete}
                    expanded={expandedId === item.id}
                    onToggleExpand={() => setExpandedId(expandedId === item.id ? null : item.id)}
                  />
                ))}
              </div>
            </div>
          </div>
        )}

        {/* TAB 2: ALL INSTALLMENTS LIST */}
        {activeTab === 'list' && (
          <div className="space-y-4">
            {filteredInstallments.length === 0 ? (
              <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-12 text-center text-slate-400">
                <ShoppingBag className="w-12 h-12 mx-auto mb-3 opacity-30" />
                <p className="text-base font-medium">No installment plans match your search or filter criteria.</p>
                <p className="text-xs mt-1 text-slate-500">Try changing provider or status dropdown filter.</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 gap-4">
                {filteredInstallments.map(item => (
                  <InstallmentCard
                    key={item.id}
                    item={item}
                    currency={currency}
                    onTogglePayment={togglePaymentStatus}
                    onEdit={openEditModal}
                    onDelete={handleDelete}
                    expanded={expandedId === item.id}
                    onToggleExpand={() => setExpandedId(expandedId === item.id ? null : item.id)}
                  />
                ))}
              </div>
            )}
          </div>
        )}

        {/* TAB 3: MONTHLY FORECAST TIMELINE */}
        {activeTab === 'calendar' && (
          <div className="space-y-6">
            <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 shadow-xs">
              <h2 className="text-base font-bold text-slate-800 dark:text-slate-100 mb-2 flex items-center gap-2">
                <Calendar className="w-5 h-5 text-emerald-500" /> Monthly Forecast Timeline
              </h2>
              <p className="text-xs text-slate-500 dark:text-slate-400 mb-6">
                Monthly commitment view stored in SQLite database.
              </p>

              <div className="space-y-6">
                {calendarTimeline.map(monthGroup => (
                  <div key={monthGroup.key} className="border border-slate-200 dark:border-slate-800 rounded-xl p-4 bg-slate-50/50 dark:bg-slate-900/50">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between pb-3 mb-3 border-b border-slate-200 dark:border-slate-800 gap-2">
                      <div className="flex items-center gap-2">
                        <span className="text-base font-extrabold text-slate-800 dark:text-slate-100">
                          {monthGroup.label}
                        </span>
                        <span className="text-xs bg-slate-200 dark:bg-slate-800 text-slate-600 dark:text-slate-300 px-2 py-0.5 rounded-full font-medium">
                          {monthGroup.payments.length} items
                        </span>
                      </div>

                      <div className="flex items-center gap-4 text-xs font-semibold">
                        <div className="text-slate-500">
                          Total: <span className="text-slate-900 dark:text-white font-bold">{monthGroup.totalDue.toLocaleString()} {currency}</span>
                        </div>
                        <div className="text-emerald-600">
                          Paid: {monthGroup.paidTotal.toLocaleString()} {currency}
                        </div>
                        <div className="text-amber-600">
                          Pending: {monthGroup.pendingTotal.toLocaleString()} {currency}
                        </div>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                      {monthGroup.payments.map(pay => {
                        const config = PROVIDER_CONFIG[pay.provider] || PROVIDER_CONFIG['Other'];
                        return (
                          <div
                            key={pay.id}
                            className={`p-3 rounded-xl border flex items-center justify-between ${pay.status === 'Paid'
                              ? 'bg-emerald-50/50 dark:bg-emerald-950/20 border-emerald-200 dark:border-emerald-900/50 opacity-80'
                              : 'bg-white dark:bg-slate-800 border-slate-200 dark:border-slate-700'
                              }`}
                          >
                            <div>
                              <div className="flex items-center gap-1.5">
                                <span className={`text-[10px] font-extrabold px-1.5 py-0.5 rounded ${config.badgeBg}`}>
                                  {pay.provider}
                                </span>
                                <span className="font-semibold text-xs truncate max-w-[120px]">{pay.title}</span>
                              </div>
                              <div className="text-[11px] text-slate-400 mt-1">
                                Due: {pay.due_date}
                              </div>
                            </div>

                            <div className="text-right">
                              <div className="font-extrabold text-xs">
                                {pay.amount.toLocaleString()} {currency}
                              </div>
                              <button
                                onClick={() => togglePaymentStatus(pay.parentId, pay.id)}
                                className={`mt-1 text-[10px] font-bold px-2 py-0.5 rounded transition ${pay.status === 'Paid'
                                  ? 'bg-emerald-200 dark:bg-emerald-900 text-emerald-800 dark:text-emerald-200'
                                  : 'bg-amber-100 dark:bg-amber-950 text-amber-800 dark:text-amber-200 hover:bg-amber-200'
                                  }`}
                              >
                                {pay.status === 'Paid' ? 'Paid ✓' : 'Mark Paid'}
                              </button>
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </main>

      {/* CLOUD SYNC & DB CONFIGURATION MODAL */}
      {isCloudModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-xs p-4 overflow-y-auto">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl w-full max-w-lg shadow-2xl overflow-hidden my-8">
            <div className="px-6 py-4 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between">
              <h3 className="font-bold text-base text-slate-800 dark:text-slate-100 flex items-center gap-2">
                <Database className="w-4 h-4 text-emerald-500" /> Database & Cloud Sync Options
              </h3>
              <button
                onClick={() => setIsCloudModalOpen(false)}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 font-bold text-lg"
              >
                ✕
              </button>
            </div>

            <div className="p-6 space-y-4">
              <div className="p-3 bg-emerald-50 dark:bg-emerald-950/40 rounded-2xl border border-emerald-200 dark:border-emerald-800 flex items-center gap-3">
                <HardDrive className="w-6 h-6 text-emerald-600 dark:text-emerald-400 flex-shrink-0" />
                <div className="text-xs">
                  <div className="font-bold text-emerald-800 dark:text-emerald-200">Local SQLite DB Engine Active</div>
                  <div className="text-emerald-600 dark:text-emerald-400 mt-0.5">
                    Data persists locally on Android APK, Desktop, and Web via standard SQL schema.
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                  Select Cloud Sync Engine
                </label>
                <div className="grid grid-cols-2 gap-2">
                  <button
                    type="button"
                    onClick={() => setCloudSettings({ ...cloudSettings, provider: 'firebase' })}
                    className={`p-3 rounded-xl border text-xs font-bold text-left transition ${cloudSettings.provider === 'firebase'
                      ? 'border-blue-500 bg-blue-50/50 dark:bg-blue-950/30 text-blue-700 dark:text-blue-300'
                      : 'border-slate-200 dark:border-slate-800'
                      }`}
                  >
                    🔥 Firebase Firestore
                  </button>
                  <button
                    type="button"
                    onClick={() => setCloudSettings({ ...cloudSettings, provider: 'supabase' })}
                    className={`p-3 rounded-xl border text-xs font-bold text-left transition ${cloudSettings.provider === 'supabase'
                      ? 'border-emerald-500 bg-emerald-50/50 dark:bg-emerald-950/30 text-emerald-700 dark:text-emerald-300'
                      : 'border-slate-200 dark:border-slate-800'
                      }`}
                  >
                    ⚡ Supabase (PostgreSQL)
                  </button>
                </div>
              </div>

              <div className="space-y-3 pt-2">
                <div>
                  <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                    API Key / Config JSON
                  </label>
                  <input
                    type="text"
                    placeholder={cloudSettings.provider === 'firebase' ? 'Firebase API Key' : 'Supabase Anon Key'}
                    value={cloudSettings.apiKey}
                    onChange={(e) => setCloudSettings({ ...cloudSettings, apiKey: e.target.value })}
                    className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                  />
                </div>

                <div>
                  <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                    Project URL / Database Endpoint
                  </label>
                  <input
                    type="text"
                    placeholder="https://your-project.supabase.co"
                    value={cloudSettings.projectUrl}
                    onChange={(e) => setCloudSettings({ ...cloudSettings, projectUrl: e.target.value })}
                    className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                  />
                </div>
              </div>

              <div className="pt-4 border-t border-slate-200 dark:border-slate-800 flex justify-end gap-2">
                <button
                  onClick={() => setIsCloudModalOpen(false)}
                  className="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold"
                >
                  Save Cloud Configuration
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* DYNAMIC MODAL: ADD / EDIT INSTALLMENT */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-xs p-4 overflow-y-auto">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl w-full max-w-xl shadow-2xl overflow-hidden my-8">
            <div className="px-6 py-4 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between">
              <h3 className="font-bold text-base text-slate-800 dark:text-slate-100 flex items-center gap-2">
                <Sparkles className="w-4 h-4 text-emerald-500" />
                {editingItem ? 'Edit Installment Plan' : 'Add New Installment'}
              </h3>
              <button
                onClick={closeModal}
                className="text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 font-bold text-lg"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleSubmitForm} className="p-6 space-y-4">
              {/* Provider Selection */}
              <div>
                <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                  Select Provider / Category Type
                </label>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                  {Object.keys(PROVIDER_CONFIG).map(pKey => (
                    <button
                      type="button"
                      key={pKey}
                      onClick={() => handleProviderChange(pKey)}
                      className={`p-2.5 rounded-xl text-xs font-bold text-left border transition ${formData.provider === pKey
                        ? 'border-emerald-500 ring-2 ring-emerald-500/20 bg-emerald-50/50 dark:bg-emerald-950/30 text-emerald-700 dark:text-emerald-300'
                        : 'border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50 text-slate-700 dark:text-slate-300'
                        }`}
                    >
                      <div>{pKey}</div>
                      <div className="text-[10px] font-normal opacity-75">{PROVIDER_CONFIG[pKey].description}</div>
                    </button>
                  ))}
                </div>
              </div>

              {/* Title */}
              <div>
                <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                  Plan Title / Item Name *
                </label>
                <input
                  type="text"
                  required
                  placeholder={
                    formData.provider === 'Car Loan'
                      ? 'e.g. Hyundai Tucson 2025 Smart'
                      : formData.provider === 'Telecom / Phone Contract'
                        ? 'e.g. STC Postpaid 4 Plan + iPhone 16 Pro'
                        : 'e.g. iPhone 16 Pro Max, Sofa Set'
                  }
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>

              {/* CAR LOAN SPECIFIC DYNAMIC FIELDS */}
              {formData.provider === 'Car Loan' ? (
                <div className="space-y-3 bg-blue-50/40 dark:bg-blue-950/20 p-4 rounded-2xl border border-blue-100 dark:border-blue-900/40">
                  <div className="text-xs font-bold text-blue-700 dark:text-blue-300 flex items-center gap-1.5">
                    <Car className="w-4 h-4" /> Car Loan Details
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Car Make & Model</label>
                      <input
                        type="text"
                        placeholder="e.g. Toyota Camry / Hyundai Tucson"
                        value={formData.carMakeModel}
                        onChange={(e) => setFormData({ ...formData, carMakeModel: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Bank / Finance Company</label>
                      <input
                        type="text"
                        placeholder="e.g. Al Rajhi, SNB Auto Finance"
                        value={formData.bankLender}
                        onChange={(e) => setFormData({ ...formData, bankLender: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-3 gap-2">
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Monthly ({currency}) *</label>
                      <input
                        type="number"
                        required
                        placeholder="1450"
                        value={formData.monthlyPayment}
                        onChange={(e) => setFormData({ ...formData, monthlyPayment: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Contract Months</label>
                      <select
                        value={formData.totalSplits}
                        onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      >
                        <option value={12}>12 Months (1 Year)</option>
                        <option value={24}>24 Months (2 Years)</option>
                        <option value={36}>36 Months (3 Years)</option>
                        <option value={48}>48 Months (4 Years)</option>
                        <option value={60}>60 Months (5 Years)</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Balloon Payment ({currency})</label>
                      <input
                        type="number"
                        placeholder="23000"
                        value={formData.balloonPayment}
                        onChange={(e) => setFormData({ ...formData, balloonPayment: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                  </div>
                </div>
              ) : formData.provider === 'Telecom / Phone Contract' ? (
                /* TELECOM / PHONE CONTRACT SPECIFIC DYNAMIC FIELDS */
                <div className="space-y-3 bg-purple-50/40 dark:bg-purple-950/20 p-4 rounded-2xl border border-purple-100 dark:border-purple-900/40">
                  <div className="text-xs font-bold text-purple-700 dark:text-purple-300 flex items-center gap-1.5">
                    <Smartphone className="w-4 h-4" /> Phone Package & Linked Line Details
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Telecom Provider</label>
                      <select
                        value={formData.telecomOperator}
                        onChange={(e) => setFormData({ ...formData, telecomOperator: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      >
                        <option value="STC">STC</option>
                        <option value="Mobily">Mobily</option>
                        <option value="Zain">Zain</option>
                        <option value="Yaqoot">Yaqoot</option>
                        <option value="Virgin Mobile">Virgin Mobile</option>
                        <option value="Other">Other Operator</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Mobile / SIM Line #</label>
                      <input
                        type="text"
                        placeholder="+966 5x xxx xxxx"
                        value={formData.phoneNumber}
                        onChange={(e) => setFormData({ ...formData, phoneNumber: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-3 gap-2">
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Main Plan ({currency})</label>
                      <input
                        type="number"
                        placeholder="287.50"
                        value={formData.mainPlanCost}
                        onChange={(e) => setFormData({ ...formData, mainPlanCost: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Device Add-on ({currency})</label>
                      <input
                        type="number"
                        placeholder="175.00"
                        value={formData.deviceCost}
                        onChange={(e) => setFormData({ ...formData, deviceCost: e.target.value })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      />
                    </div>
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-600 dark:text-slate-300 mb-1">Contract Duration</label>
                      <select
                        value={formData.totalSplits}
                        onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })}
                        className="w-full px-3 py-1.5 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs"
                      >
                        <option value={12}>12 Months</option>
                        <option value={18}>18 Months</option>
                        <option value={24}>24 Months</option>
                        <option value={36}>36 Months</option>
                      </select>
                    </div>
                  </div>
                </div>
              ) : (
                /* STANDARD TABBY / TAMARA / SNB FLEX FIELDS */
                <div className="space-y-3">
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                        Total Amount ({currency}) *
                      </label>
                      <input
                        type="number"
                        step="0.01"
                        required
                        placeholder="0.00"
                        value={formData.totalAmount}
                        onChange={(e) => setFormData({ ...formData, totalAmount: e.target.value })}
                        className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                        Category
                      </label>
                      <select
                        value={formData.category}
                        onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                        className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                      >
                        {CATEGORIES.map(cat => (
                          <option key={cat} value={cat}>{cat}</option>
                        ))}
                      </select>
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                        Installment Period (Splits)
                      </label>
                      {formData.provider === 'SNB Al Ahli Flex Card' ? (
                        <div className="w-full px-3 py-2 bg-slate-100 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-xs font-bold text-slate-600 dark:text-slate-300 flex items-center justify-between">
                          <span>Fixed 4 Months</span>
                          <span className="text-[10px] bg-green-200 text-green-800 px-1.5 py-0.5 rounded">SNB Rule</span>
                        </div>
                      ) : (
                        <select
                          value={formData.totalSplits}
                          onChange={(e) => setFormData({ ...formData, totalSplits: Number(e.target.value) })}
                          className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                        >
                          {Array.from({ length: 21 }, (_, i) => i + 4).map(num => (
                            <option key={num} value={num}>{num} Months / Splits</option>
                          ))}
                        </select>
                      )}
                    </div>

                    <div>
                      <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                        Start / First Payment Date
                      </label>
                      <input
                        type="date"
                        value={formData.startDate}
                        onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                        className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Notes */}
              <div>
                <label className="block text-xs font-semibold text-slate-600 dark:text-slate-300 mb-1">
                  Notes / Merchant / Reference Info
                </label>
                <input
                  type="text"
                  placeholder="e.g. Jarir Order #1234, Jarir online purchase"
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  className="w-full px-3 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-emerald-500"
                />
              </div>

              {/* Modal Buttons */}
              <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-200 dark:border-slate-800">
                <button
                  type="button"
                  onClick={closeModal}
                  className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-500 hover:text-slate-800 dark:hover:text-slate-200 transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition shadow-md"
                >
                  {editingItem ? 'Save Changes' : 'Create Plan'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

// INDIVIDUAL CARD COMPONENT
function InstallmentCard({ item, currency, onTogglePayment, onEdit, onDelete, expanded, onToggleExpand }) {
  const providerConfig = PROVIDER_CONFIG[item.provider] || PROVIDER_CONFIG['Other'];

  const paidItems = item.schedule.filter(s => s.status === 'Paid');
  const paidCount = paidItems.length;
  const totalCount = item.schedule.length;
  const progressPercent = Math.round((paidCount / totalCount) * 100);

  const paidAmount = paidItems.reduce((acc, curr) => acc + curr.amount, 0);
  const remainingAmount = item.total_amount - paidAmount;

  const isCompleted = paidCount === totalCount;
  const nextPending = item.schedule.find(s => s.status !== 'Paid');

  return (
    <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-5 transition shadow-xs hover:border-slate-300 dark:hover:border-slate-700">
      {/* Card Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3">
        <div className="flex items-center gap-3">
          <span className={`px-2.5 py-1 rounded-lg text-xs font-extrabold ${providerConfig.badgeBg}`}>
            {item.provider}
          </span>
          <div>
            <h3 className="font-bold text-base text-slate-800 dark:text-slate-100 flex items-center gap-2">
              {item.title}
              {item.provider === 'Car Loan' && <Car className="w-4 h-4 text-blue-500" />}
              {item.provider === 'Telecom / Phone Contract' && <Smartphone className="w-4 h-4 text-purple-500" />}
            </h3>
            <div className="flex items-center gap-2 text-xs text-slate-400 mt-0.5">
              {item.notes && <span>{item.notes}</span>}
              {item.phone_number && (
                <span className="bg-purple-100 text-purple-700 dark:bg-purple-900/50 dark:text-purple-300 font-mono px-1.5 py-0.5 rounded text-[10px] font-semibold flex items-center gap-1">
                  <Phone className="w-3 h-3" /> {item.phone_number}
                </span>
              )}
              {item.bank_lender && (
                <span className="bg-blue-100 text-blue-700 dark:bg-blue-900/50 dark:text-blue-300 font-mono px-1.5 py-0.5 rounded text-[10px] font-semibold">
                  🏦 {item.bank_lender}
                </span>
              )}
            </div>
          </div>
        </div>

        <div className="flex items-center justify-between sm:justify-end gap-3">
          <div className="text-right">
            <div className="text-base font-extrabold text-slate-900 dark:text-white">
              {item.total_amount.toLocaleString()} <span className="text-xs font-normal text-slate-400">{currency}</span>
            </div>
            <div className="text-[11px] text-slate-400">
              {paidCount} of {totalCount} splits ({progressPercent}%)
            </div>
          </div>

          <div className="flex items-center gap-1">
            <button
              onClick={() => onEdit(item)}
              className="p-1.5 text-slate-400 hover:text-slate-700 dark:hover:text-slate-200 transition"
              title="Edit Plan"
            >
              <Edit3 className="w-4 h-4" />
            </button>
            <button
              onClick={() => onDelete(item.id)}
              className="p-1.5 text-slate-400 hover:text-red-600 transition"
              title="Delete Plan"
            >
              <Trash2 className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Special Breakdown Strip */}
      {(item.provider === 'Car Loan' || item.provider === 'Telecom / Phone Contract') && (
        <div className="my-2 p-2 bg-slate-50 dark:bg-slate-800/40 rounded-xl text-[11px] flex flex-wrap gap-3 font-medium text-slate-600 dark:text-slate-300">
          {item.provider === 'Car Loan' && (
            <>
              <span>Monthly: <strong>{item.monthly_payment?.toLocaleString()} {currency}</strong></span>
              {item.balloon_payment > 0 && <span>Balloon Final: <strong>{item.balloon_payment?.toLocaleString()} {currency}</strong></span>}
            </>
          )}
          {item.provider === 'Telecom / Phone Contract' && (
            <>
              {item.main_plan_cost > 0 && <span>Plan: <strong>{item.main_plan_cost} {currency}</strong></span>}
              {item.device_cost > 0 && <span>Device Add-on: <strong>{item.device_cost} {currency}</strong></span>}
            </>
          )}
        </div>
      )}

      {/* Progress Bar */}
      <div className="space-y-1.5 my-3">
        <div className="w-full bg-slate-100 dark:bg-slate-800 h-2.5 rounded-full overflow-hidden flex">
          <div
            className={`h-full transition-all duration-500 ${providerConfig.color}`}
            style={{ width: `${progressPercent}%` }}
          />
        </div>
        <div className="flex justify-between text-[11px] text-slate-400">
          <span>Paid: {paidAmount.toLocaleString()} {currency}</span>
          <span>Remaining: {remainingAmount.toLocaleString()} {currency}</span>
        </div>
      </div>

      {/* Next Payment Banner */}
      {!isCompleted && nextPending && (
        <div className="bg-slate-50 dark:bg-slate-800/60 rounded-xl p-2.5 flex items-center justify-between text-xs mt-3">
          <div className="flex items-center gap-2">
            <Clock className="w-3.5 h-3.5 text-amber-500" />
            <span className="text-slate-600 dark:text-slate-300 font-medium">
              Next Due: <strong className="text-slate-900 dark:text-white">{nextPending.due_date}</strong> ({nextPending.amount.toLocaleString()} {currency})
            </span>
          </div>
          <button
            onClick={() => onTogglePayment(item.id, nextPending.id)}
            className="text-[11px] font-bold text-emerald-600 dark:text-emerald-400 hover:underline"
          >
            Pay Now ✓
          </button>
        </div>
      )}

      {isCompleted && (
        <div className="bg-emerald-50 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-300 rounded-xl p-2.5 text-xs font-semibold text-center mt-3 flex items-center justify-center gap-1.5">
          <CheckCircle className="w-4 h-4" /> Plan fully paid off!
        </div>
      )}

      {/* Accordion Toggle */}
      <div className="mt-3 pt-2 border-t border-slate-100 dark:border-slate-800 flex justify-between items-center">
        <button
          onClick={onToggleExpand}
          className="text-xs font-semibold text-slate-500 hover:text-slate-800 dark:hover:text-slate-200 flex items-center gap-1 transition"
        >
          {expanded ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
          <span>{expanded ? 'Hide Breakdown Schedule' : 'View Breakdown Schedule'}</span>
        </button>
        <span className="text-[10px] text-slate-400 uppercase font-mono">{item.category}</span>
      </div>

      {/* Expanded Breakdown Table */}
      {expanded && (
        <div className="mt-3 pt-3 border-t border-slate-100 dark:border-slate-800 space-y-2">
          <div className="grid grid-cols-12 text-[10px] font-bold text-slate-400 uppercase pb-1 border-b border-slate-100 dark:border-slate-800 px-2">
            <span className="col-span-1">#</span>
            <span className="col-span-4">Due Date</span>
            <span className="col-span-3">Amount</span>
            <span className="col-span-4 text-right">Action</span>
          </div>

          {item.schedule.map((pay, idx) => (
            <div
              key={pay.id}
              className={`grid grid-cols-12 items-center text-xs p-2 rounded-lg transition ${pay.status === 'Paid'
                ? 'bg-slate-50 dark:bg-slate-800/30 text-slate-400 line-through'
                : 'bg-white dark:bg-slate-800/80 text-slate-700 dark:text-slate-200 font-medium'
                }`}
            >
              <span className="col-span-1 font-mono text-[10px]">{idx + 1}</span>
              <span className="col-span-4">{pay.due_date}</span>
              <span className="col-span-3 font-semibold">{pay.amount.toLocaleString()} {currency}</span>
              <div className="col-span-4 text-right">
                <button
                  onClick={() => onTogglePayment(item.id, pay.id)}
                  className={`px-2 py-1 rounded-md text-[10px] font-bold transition ${pay.status === 'Paid'
                    ? 'bg-slate-200 dark:bg-slate-700 text-slate-600 dark:text-slate-300'
                    : 'bg-emerald-600 text-white hover:bg-emerald-700'
                    }`}
                >
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