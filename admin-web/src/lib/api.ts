import axios from 'axios';
import Cookies from 'js-cookie';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

const api = axios.create({
  baseURL: `${API_URL}/api/v1`,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = Cookies.get('admin_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 responses
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      Cookies.remove('admin_token');
      if (typeof window !== 'undefined') {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

// Auth
export const adminLogin = async (email: string, password: string) => {
  const { data } = await api.post('/admin/auth/login', { email, password });
  return data;
};

// Metrics
export const getMetricsOverview = async (range: '1d' | '7d' | '30d' | '90d') => {
  const { data } = await api.get(`/admin/metrics/overview?range=${range}`);
  return data;
};

// Learn Articles
export const getLearnArticles = async (params?: {
  category?: string;
  locale?: string;
  status?: string;
}) => {
  const { data } = await api.get('/admin/learn/list', { params });
  return data;
};

export const getLearnArticle = async (id: string) => {
  const { data } = await api.get(`/admin/learn/${id}`);
  return data;
};

export const updateLearnArticle = async (
  id: string,
  updates: { title?: string; content?: string; status?: string }
) => {
  const { data } = await api.patch(`/admin/learn/${id}`, updates);
  return data;
};

export const uploadLearnFile = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  const { data } = await api.post('/admin/learn/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return data;
};

export const uploadLearnZip = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  const { data } = await api.post('/admin/learn/upload-zip', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return data;
};

export default api;

