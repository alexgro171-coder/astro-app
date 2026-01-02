import { LucideIcon } from 'lucide-react';

interface MetricCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  color?: string;
  subtitle?: string;
}

export default function MetricCard({
  title,
  value,
  icon: Icon,
  color = 'cosmic',
  subtitle,
}: MetricCardProps) {
  const colorClasses: Record<string, string> = {
    cosmic: 'bg-cosmic-600/20 text-cosmic-400',
    green: 'bg-green-600/20 text-green-400',
    blue: 'bg-blue-600/20 text-blue-400',
    yellow: 'bg-yellow-600/20 text-yellow-400',
    red: 'bg-red-600/20 text-red-400',
  };

  return (
    <div className="card">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-gray-400 text-sm">{title}</p>
          <p className="text-3xl font-bold text-white mt-1">{value}</p>
          {subtitle && <p className="text-gray-500 text-sm mt-1">{subtitle}</p>}
        </div>
        <div className={`p-3 rounded-lg ${colorClasses[color]}`}>
          <Icon className="w-6 h-6" />
        </div>
      </div>
    </div>
  );
}

