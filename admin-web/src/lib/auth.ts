import Cookies from 'js-cookie';

export interface AdminUser {
  id: string;
  email: string;
  name: string;
  role: string;
}

export const getToken = (): string | undefined => {
  return Cookies.get('admin_token');
};

export const setToken = (token: string): void => {
  Cookies.set('admin_token', token, { expires: 1 }); // 1 day
};

export const removeToken = (): void => {
  Cookies.remove('admin_token');
};

export const isAuthenticated = (): boolean => {
  return !!getToken();
};

export const logout = (): void => {
  removeToken();
  if (typeof window !== 'undefined') {
    window.location.href = '/login';
  }
};

