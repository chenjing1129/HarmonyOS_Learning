import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { BaseResponse, WanAndroidResponse } from '../type/CommonType'
import { storageUtil } from './StorageUtil'

// 主axios实例 - 用于自己的后端API
export const axiosInstance = axios.create({
  baseURL: 'http://10.20.222.182:8080',
  timeout: 60000,
  headers: {}
})

// 玩安卓axios实例 - 用于玩安卓开放API
export const wanAndroidInstance = axios.create({
  baseURL: 'https://www.wanandroid.com',
  timeout: 60000,
  headers: {}
})

// 请求拦截器：添加 Authorization 头部
axiosInstance.interceptors.request.use(
  async (config: InternalAxiosRequestConfig): Promise<InternalAxiosRequestConfig> => {
    try {
      // 获取 token（可能在 storageUtil 初始化前被调用）
      const token = await storageUtil.get('token')
      if (token != null && token !== '') {
        const tokenString = token.toString()
        config.headers.set('Authorization', `Bearer ${tokenString}`)
      }
    } catch (error) {
      // 如果 storageUtil 未初始化，忽略错误继续请求
      console.warn('获取 token 失败，可能 storageUtil 未初始化:', error)
    }
    return config
  },
  (error: AxiosError): Promise<AxiosError> => {
    return Promise.reject(error)
  }
)

// 响应拦截器
axiosInstance.interceptors.response.use((response: AxiosResponse) => {
  return response
}, (error: AxiosError) => {
  return Promise.reject(error)
})

// 玩安卓实例不需要token,但也添加响应拦截器
wanAndroidInstance.interceptors.response.use((response: AxiosResponse) => {
  return response
}, (error: AxiosError) => {
  return Promise.reject(error)
})


export type ResType<T> = AxiosResponse<BaseResponse<T>>
export type WanAndroidResType<T> = AxiosResponse<WanAndroidResponse<T>>

/**
 * 通用Axios工具类 - 用于自己的后端API
 */
export class AxiosUtil {
  static get<T>(url: string, params?: object): Promise<ResType<T>> {
    return axiosInstance.get<null, ResType<T>>(url, { params })
  }

  static post<T>(url: string, data?: object): Promise<ResType<T>> {
    return axiosInstance.post<null, ResType<T>>(url, data)
  }

  static put<T>(url: string, data?: object): Promise<ResType<T>> {
    return axiosInstance.put<null, ResType<T>>(url, data)
  }

  static delete<T>(url: string, params?: object): Promise<ResType<T>> {
    return axiosInstance.delete<null, ResType<T>>(url, { params })
  }
}

/**
 * 玩安卓Axios工具类 - 用于玩安卓开放API
 */
export class WanAndroidAxios {
  static get<T>(url: string, params?: object): Promise<WanAndroidResType<T>> {
    return wanAndroidInstance.get<null, WanAndroidResType<T>>(url, { params })
  }

  static post<T>(url: string, data?: object): Promise<WanAndroidResType<T>> {
    return wanAndroidInstance.post<null, WanAndroidResType<T>>(url, data)
  }

  static put<T>(url: string, data?: object): Promise<WanAndroidResType<T>> {
    return wanAndroidInstance.put<null, WanAndroidResType<T>>(url, data)
  }

  static delete<T>(url: string, params?: object): Promise<WanAndroidResType<T>> {
    return wanAndroidInstance.delete<null, WanAndroidResType<T>>(url, { params })
  }
}