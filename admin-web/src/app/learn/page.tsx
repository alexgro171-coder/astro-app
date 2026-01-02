'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { isAuthenticated } from '@/lib/auth';
import {
  getLearnArticles,
  uploadLearnFile,
  uploadLearnZip,
  updateLearnArticle,
  getLearnArticle,
} from '@/lib/api';
import Navbar from '@/components/Navbar';
import {
  Upload,
  FileArchive,
  Check,
  X,
  Edit,
  Eye,
  EyeOff,
  RefreshCw,
} from 'lucide-react';

interface Article {
  id: string;
  category: string;
  locale: string;
  slug: string;
  title: string;
  status: 'DRAFT' | 'PUBLISHED';
  updatedAt: string;
}

export default function LearnPage() {
  const router = useRouter();
  const [articles, setArticles] = useState<Article[]>([]);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  // Filters
  const [filterCategory, setFilterCategory] = useState('');
  const [filterLocale, setFilterLocale] = useState('');
  const [filterStatus, setFilterStatus] = useState('');

  // Edit modal
  const [editArticle, setEditArticle] = useState<any>(null);
  const [editLoading, setEditLoading] = useState(false);

  useEffect(() => {
    if (!isAuthenticated()) {
      router.push('/login');
      return;
    }
    fetchArticles();
  }, [filterCategory, filterLocale, filterStatus]);

  const fetchArticles = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (filterCategory) params.category = filterCategory;
      if (filterLocale) params.locale = filterLocale;
      if (filterStatus) params.status = filterStatus;
      const data = await getLearnArticles(params);
      setArticles(data);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to load articles');
    } finally {
      setLoading(false);
    }
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    setError('');
    setSuccess('');

    try {
      const result = await uploadLearnFile(file);
      setSuccess(
        `${result.isUpdate ? 'Updated' : 'Created'}: ${result.category}/${result.locale}/${result.slug}`
      );
      fetchArticles();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Upload failed');
    } finally {
      setUploading(false);
      e.target.value = '';
    }
  };

  const handleZipUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    setError('');
    setSuccess('');

    try {
      const result = await uploadLearnZip(file);
      const successCount = result.successes.length;
      const failCount = result.failures.length;
      setSuccess(`Processed ZIP: ${successCount} success, ${failCount} failed`);
      if (failCount > 0) {
        setError(`Failures: ${result.failures.join(', ')}`);
      }
      fetchArticles();
    } catch (err: any) {
      setError(err.response?.data?.message || 'ZIP upload failed');
    } finally {
      setUploading(false);
      e.target.value = '';
    }
  };

  const openEditModal = async (article: Article) => {
    setEditLoading(true);
    try {
      const fullArticle = await getLearnArticle(article.id);
      setEditArticle(fullArticle);
    } catch (err) {
      setError('Failed to load article');
    } finally {
      setEditLoading(false);
    }
  };

  const handleSaveEdit = async () => {
    if (!editArticle) return;
    setEditLoading(true);
    try {
      await updateLearnArticle(editArticle.id, {
        title: editArticle.title,
        content: editArticle.content,
        status: editArticle.status,
      });
      setEditArticle(null);
      setSuccess('Article updated successfully');
      fetchArticles();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to update article');
    } finally {
      setEditLoading(false);
    }
  };

  const toggleStatus = async (article: Article) => {
    const newStatus = article.status === 'PUBLISHED' ? 'DRAFT' : 'PUBLISHED';
    try {
      await updateLearnArticle(article.id, { status: newStatus });
      setSuccess(`Article ${newStatus.toLowerCase()}`);
      fetchArticles();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to update status');
    }
  };

  const categories = ['SIGNS', 'PLANETS', 'HOUSES', 'TRANSITS'];
  const locales = ['EN', 'RO', 'FR', 'DE', 'ES', 'IT', 'HU', 'PL'];
  const statuses = ['DRAFT', 'PUBLISHED'];

  return (
    <div className="min-h-screen">
      <Navbar />

      <main className="max-w-7xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-2xl font-bold text-white">Learn CMS</h1>
            <p className="text-gray-400">Manage educational articles</p>
          </div>

          {/* Upload Buttons */}
          <div className="flex gap-3">
            <label className="btn-secondary flex items-center gap-2 cursor-pointer">
              <Upload className="w-4 h-4" />
              Upload File
              <input
                type="file"
                accept=".md,.txt"
                onChange={handleFileUpload}
                className="hidden"
                disabled={uploading}
              />
            </label>
            <label className="btn-primary flex items-center gap-2 cursor-pointer">
              <FileArchive className="w-4 h-4" />
              Upload ZIP
              <input
                type="file"
                accept=".zip"
                onChange={handleZipUpload}
                className="hidden"
                disabled={uploading}
              />
            </label>
          </div>
        </div>

        {/* Messages */}
        {error && (
          <div className="bg-red-500/10 border border-red-500/30 text-red-400 px-4 py-3 rounded-lg mb-4">
            {error}
          </div>
        )}
        {success && (
          <div className="bg-green-500/10 border border-green-500/30 text-green-400 px-4 py-3 rounded-lg mb-4">
            {success}
          </div>
        )}

        {/* Filters */}
        <div className="card mb-6">
          <div className="flex flex-wrap gap-4 items-center">
            <div>
              <label className="block text-sm text-gray-400 mb-1">Category</label>
              <select
                value={filterCategory}
                onChange={(e) => setFilterCategory(e.target.value)}
                className="input w-40"
              >
                <option value="">All</option>
                {categories.map((c) => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Locale</label>
              <select
                value={filterLocale}
                onChange={(e) => setFilterLocale(e.target.value)}
                className="input w-32"
              >
                <option value="">All</option>
                {locales.map((l) => (
                  <option key={l} value={l}>{l}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm text-gray-400 mb-1">Status</label>
              <select
                value={filterStatus}
                onChange={(e) => setFilterStatus(e.target.value)}
                className="input w-36"
              >
                <option value="">All</option>
                {statuses.map((s) => (
                  <option key={s} value={s}>{s}</option>
                ))}
              </select>
            </div>
            <div className="pt-5">
              <button
                onClick={fetchArticles}
                className="btn-secondary flex items-center gap-2"
              >
                <RefreshCw className="w-4 h-4" />
                Refresh
              </button>
            </div>
          </div>
        </div>

        {/* Articles Table */}
        <div className="card overflow-hidden">
          {loading ? (
            <div className="flex items-center justify-center py-20">
              <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-cosmic-500"></div>
            </div>
          ) : articles.length === 0 ? (
            <p className="text-center text-gray-400 py-20">No articles found</p>
          ) : (
            <table className="w-full">
              <thead>
                <tr className="border-b border-gray-700">
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Category</th>
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Locale</th>
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Slug</th>
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Title</th>
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Status</th>
                  <th className="text-left px-4 py-3 text-gray-400 font-medium">Updated</th>
                  <th className="text-right px-4 py-3 text-gray-400 font-medium">Actions</th>
                </tr>
              </thead>
              <tbody>
                {articles.map((article) => (
                  <tr key={article.id} className="border-b border-gray-700/50 hover:bg-gray-700/30">
                    <td className="px-4 py-3 text-white">{article.category}</td>
                    <td className="px-4 py-3 text-white">{article.locale}</td>
                    <td className="px-4 py-3 text-gray-400">{article.slug}</td>
                    <td className="px-4 py-3 text-white">{article.title}</td>
                    <td className="px-4 py-3">
                      <span
                        className={`px-2 py-1 rounded text-xs ${
                          article.status === 'PUBLISHED'
                            ? 'bg-green-600/20 text-green-400'
                            : 'bg-yellow-600/20 text-yellow-400'
                        }`}
                      >
                        {article.status}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-400 text-sm">
                      {new Date(article.updatedAt).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex justify-end gap-2">
                        <button
                          onClick={() => openEditModal(article)}
                          className="p-2 hover:bg-gray-600 rounded"
                          title="Edit"
                        >
                          <Edit className="w-4 h-4 text-gray-400" />
                        </button>
                        <button
                          onClick={() => toggleStatus(article)}
                          className="p-2 hover:bg-gray-600 rounded"
                          title={article.status === 'PUBLISHED' ? 'Unpublish' : 'Publish'}
                        >
                          {article.status === 'PUBLISHED' ? (
                            <EyeOff className="w-4 h-4 text-gray-400" />
                          ) : (
                            <Eye className="w-4 h-4 text-gray-400" />
                          )}
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>

      {/* Edit Modal */}
      {editArticle && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
          <div className="bg-gray-800 rounded-xl max-w-2xl w-full max-h-[90vh] overflow-hidden">
            <div className="flex items-center justify-between px-6 py-4 border-b border-gray-700">
              <h2 className="text-lg font-semibold text-white">Edit Article</h2>
              <button
                onClick={() => setEditArticle(null)}
                className="p-2 hover:bg-gray-700 rounded"
              >
                <X className="w-5 h-5 text-gray-400" />
              </button>
            </div>
            <div className="p-6 space-y-4 overflow-y-auto" style={{ maxHeight: 'calc(90vh - 140px)' }}>
              <div>
                <label className="block text-sm text-gray-400 mb-1">Title</label>
                <input
                  type="text"
                  value={editArticle.title}
                  onChange={(e) => setEditArticle({ ...editArticle, title: e.target.value })}
                  className="input"
                />
              </div>
              <div>
                <label className="block text-sm text-gray-400 mb-1">Status</label>
                <select
                  value={editArticle.status}
                  onChange={(e) => setEditArticle({ ...editArticle, status: e.target.value })}
                  className="input"
                >
                  <option value="DRAFT">DRAFT</option>
                  <option value="PUBLISHED">PUBLISHED</option>
                </select>
              </div>
              <div>
                <label className="block text-sm text-gray-400 mb-1">Content (Markdown)</label>
                <textarea
                  value={editArticle.content}
                  onChange={(e) => setEditArticle({ ...editArticle, content: e.target.value })}
                  className="input h-64 font-mono text-sm"
                />
              </div>
            </div>
            <div className="flex justify-end gap-3 px-6 py-4 border-t border-gray-700">
              <button
                onClick={() => setEditArticle(null)}
                className="btn-secondary"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveEdit}
                disabled={editLoading}
                className="btn-primary flex items-center gap-2"
              >
                {editLoading ? (
                  <div className="animate-spin rounded-full h-4 w-4 border-t-2 border-b-2 border-white"></div>
                ) : (
                  <Check className="w-4 h-4" />
                )}
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

