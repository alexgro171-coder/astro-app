'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Navbar from '@/components/Navbar';
import { isAuthenticated } from '@/lib/auth';
import { runUiTranslations } from '@/lib/api';

export default function TranslationsPage() {
  const router = useRouter();
  const [running, setRunning] = useState(false);
  const [output, setOutput] = useState('');
  const [error, setError] = useState('');
  const [lastRun, setLastRun] = useState<string | null>(null);

  useEffect(() => {
    if (!isAuthenticated()) {
      router.push('/login');
    }
  }, [router]);

  const handleRun = async () => {
    setRunning(true);
    setError('');
    setOutput('');
    try {
      const data = await runUiTranslations();
      const stdout = data?.stdout ?? '';
      const stderr = data?.stderr ?? '';
      const combined = [stdout, stderr].filter(Boolean).join('\n');
      setOutput(combined || 'Done. No output.');
      setLastRun(new Date().toISOString());
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Failed to run translations');
    } finally {
      setRunning(false);
    }
  };

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="max-w-4xl mx-auto px-4 py-8">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">UI Translations</h1>
          <p className="text-gray-400">
            Run the OpenAI translation script to update missing ARB keys.
          </p>
        </div>

        <div className="card mb-6">
          <div className="flex items-center justify-between gap-4">
            <div>
              <p className="text-white font-semibold">Translate new UI keys</p>
              <p className="text-gray-400 text-sm">
                Requires OPENAI_API_KEY on the server.
              </p>
            </div>
            <button
              onClick={handleRun}
              disabled={running}
              className={`px-4 py-2 rounded-lg transition-colors ${
                running
                  ? 'bg-gray-700 text-gray-400 cursor-not-allowed'
                  : 'bg-cosmic-600 text-white hover:bg-cosmic-500'
              }`}
            >
              {running ? 'Running...' : 'Run Script'}
            </button>
          </div>
          {lastRun && (
            <p className="text-gray-500 text-xs mt-3">
              Last run: {new Date(lastRun).toLocaleString()}
            </p>
          )}
        </div>

        {error && (
          <div className="bg-red-500/10 border border-red-500/30 text-red-400 px-4 py-3 rounded-lg mb-6">
            {error}
          </div>
        )}

        <div className="card">
          <h2 className="text-lg font-semibold text-white mb-3">Output</h2>
          <pre className="bg-gray-900/60 text-gray-300 text-sm p-4 rounded-lg whitespace-pre-wrap">
            {output || 'No output yet.'}
          </pre>
        </div>
      </main>
    </div>
  );
}
