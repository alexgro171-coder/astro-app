'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { isAuthenticated } from '@/lib/auth';
import { getMetricsOverview } from '@/lib/api';
import Navbar from '@/components/Navbar';
import MetricCard from '@/components/MetricCard';
import {
  Users,
  CreditCard,
  ShoppingCart,
  Activity,
  BookOpen,
} from 'lucide-react';

type Range = '1d' | '7d' | '30d' | '90d';

interface MetricsData {
  range: string;
  newUsers: number;
  activeSubscribers: number;
  oneTimePurchasers: number;
  oneTimeByService: Record<string, number>;
  onlineNow: number;
  learnUsers: number;
}

export default function DashboardPage() {
  const router = useRouter();
  const [range, setRange] = useState<Range>('7d');
  const [metrics, setMetrics] = useState<MetricsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!isAuthenticated()) {
      router.push('/login');
      return;
    }
    fetchMetrics();
  }, [range]);

  const fetchMetrics = async () => {
    setLoading(true);
    setError('');
    try {
      const data = await getMetricsOverview(range);
      setMetrics(data);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to load metrics');
    } finally {
      setLoading(false);
    }
  };

  const rangeLabels: Record<Range, string> = {
    '1d': 'Last 24 Hours',
    '7d': 'Last 7 Days',
    '30d': 'Last 30 Days',
    '90d': 'Last 90 Days',
  };

  return (
    <div className="min-h-screen">
      <Navbar />

      <main className="max-w-7xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-2xl font-bold text-white">Dashboard</h1>
            <p className="text-gray-400">Overview of your app metrics</p>
          </div>

          {/* Range Selector */}
          <div className="flex gap-2">
            {(['1d', '7d', '30d', '90d'] as Range[]).map((r) => (
              <button
                key={r}
                onClick={() => setRange(r)}
                className={`px-4 py-2 rounded-lg transition-colors ${
                  range === r
                    ? 'bg-cosmic-600 text-white'
                    : 'bg-gray-800 text-gray-400 hover:bg-gray-700'
                }`}
              >
                {r}
              </button>
            ))}
          </div>
        </div>

        {error && (
          <div className="bg-red-500/10 border border-red-500/30 text-red-400 px-4 py-3 rounded-lg mb-6">
            {error}
          </div>
        )}

        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-cosmic-500"></div>
          </div>
        ) : metrics ? (
          <>
            {/* Live Status */}
            <div className="mb-8">
              <MetricCard
                title="Online Now"
                value={metrics.onlineNow}
                icon={Activity}
                color="green"
                subtitle="Active in last 5 minutes"
              />
            </div>

            {/* Main Metrics Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
              <MetricCard
                title="New Users"
                value={metrics.newUsers}
                icon={Users}
                color="cosmic"
                subtitle={rangeLabels[range]}
              />
              <MetricCard
                title="Active Subscribers"
                value={metrics.activeSubscribers}
                icon={CreditCard}
                color="blue"
                subtitle="Current"
              />
              <MetricCard
                title="One-Time Purchases"
                value={metrics.oneTimePurchasers}
                icon={ShoppingCart}
                color="yellow"
                subtitle={rangeLabels[range]}
              />
              <MetricCard
                title="Learn Users"
                value={metrics.learnUsers}
                icon={BookOpen}
                color="green"
                subtitle={rangeLabels[range]}
              />
            </div>

            {/* One-Time Purchases Breakdown */}
            {Object.keys(metrics.oneTimeByService).length > 0 && (
              <div className="card">
                <h2 className="text-lg font-semibold text-white mb-4">
                  One-Time Purchases by Service
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {Object.entries(metrics.oneTimeByService).map(([service, count]) => (
                    <div
                      key={service}
                      className="bg-gray-700/50 rounded-lg p-4"
                    >
                      <p className="text-gray-400 text-sm capitalize">
                        {service.replace(/_/g, ' ')}
                      </p>
                      <p className="text-2xl font-bold text-white mt-1">{count}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </>
        ) : null}
      </main>
    </div>
  );
}

