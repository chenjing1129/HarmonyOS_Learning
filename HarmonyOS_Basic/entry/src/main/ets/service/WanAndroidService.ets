import http from '@ohos.net.http';
import { BaseResponse, Article, PageData, Banner, FriendLink, HotKey, TreeNode, RequestOptions, ErrorObject } from '../model/WanAndroidModels';

/**
 * 玩安卓API服务类
 */
export class WanAndroidService {
  private static readonly BASE_URL = 'https://www.wanandroid.com';
  
  /**
   * 创建HTTP请求
   */
  private static createHttpRequest(): http.HttpRequest {
    return http.createHttp();
  }

  /**
   * 通用请求方法
   */
  private static async request<T>(url: string): Promise<BaseResponse<T>> {
    let httpRequest: http.HttpRequest | null = null;
    
    console.info('开始请求:', url);
    
    try {
      httpRequest = WanAndroidService.createHttpRequest();
      
      const requestOptions: RequestOptions = {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json',
          'User-Agent': 'HarmonyOS-App/1.0'
        },
        connectTimeout: 10000,  // 增加超时时间
        readTimeout: 15000      // 增加超时时间
      };
      
      console.info('请求配置:', JSON.stringify(requestOptions));
      
      const response = await httpRequest.request(url, requestOptions);
      
      console.info('响应状态码:', response.responseCode);
      console.info('响应头:', JSON.stringify(response.header));

      if (response.responseCode === 200) {
        const resultString = response.result as string;
        console.info('响应数据长度:', resultString.length);
        console.info('响应数据前200字符:', resultString.substring(0, 200));
        
        try {
          const result = JSON.parse(resultString) as BaseResponse<T>;
          console.info('解析成功, errorCode:', result.errorCode);
          return result;
        } catch (parseError) {
          console.error('JSON解析失败:', parseError);
          console.error('原始响应:', resultString.substring(0, 500));
          return Promise.reject(`JSON解析失败: ${parseError}`);
        }
      } else {
        const errorMsg = `HTTP请求失败: ${response.responseCode} - ${response.result}`;
        console.error(errorMsg);
        return Promise.reject(errorMsg);
      }
    } catch (error) {
      console.error('网络请求异常:', error);
      console.error('错误详情:', JSON.stringify(error));
      
      // 提供更友好的错误信息
      let friendlyError = '网络请求失败';
      if (typeof error === 'object' && error !== null) {
        const errorObj = error as ErrorObject;
        if (errorObj.code) {
          switch (errorObj.code) {
            case 2300001:
              friendlyError = '网络连接失败，请检查网络设置';
              break;
            case 2300002:
              friendlyError = '系统内部错误';
              break;
            case 2300003:
              friendlyError = 'URL格式错误';
              break;
            case 2300005:
              friendlyError = '网络协议错误';
              break;
            case 2300006:
              friendlyError = '网络连接超时';
              break;
            case 2300007:
              friendlyError = '网络写入超时';
              break;
            case 2300008:
              friendlyError = '网络读取超时';
              break;
            default:
              friendlyError = `网络错误 (${errorObj.code}): ${errorObj.message || '未知错误'}`;
          }
        }
      }
      
      return Promise.reject(friendlyError);
    } finally {
      // 确保HTTP请求对象被正确销毁
      if (httpRequest) {
        try {
          httpRequest.destroy();
          console.info('HTTP请求对象已销毁');
        } catch (destroyError) {
          console.error('销毁HTTP请求对象失败:', destroyError);
        }
        httpRequest = null;
      }
    }
  }

  /**
   * 获取首页文章列表
   * @param page 页码，从0开始
   */
  static async getHomeArticles(page: number = 0): Promise<BaseResponse<PageData<Article>>> {
    const url = `${WanAndroidService.BASE_URL}/article/list/${page}/json`;
    return WanAndroidService.request<PageData<Article>>(url);
  }

  /**
   * 获取首页Banner
   */
  static async getBanner(): Promise<BaseResponse<Banner[]>> {
    const url = `${WanAndroidService.BASE_URL}/banner/json`;
    return WanAndroidService.request<Banner[]>(url);
  }

  /**
   * 获取常用网站
   */
  static async getFriendLinks(): Promise<BaseResponse<FriendLink[]>> {
    const url = `${WanAndroidService.BASE_URL}/friend/json`;
    return WanAndroidService.request<FriendLink[]>(url);
  }

  /**
   * 获取搜索热词
   */
  static async getHotKeys(): Promise<BaseResponse<HotKey[]>> {
    const url = `${WanAndroidService.BASE_URL}/hotkey/json`;
    return WanAndroidService.request<HotKey[]>(url);
  }

  /**
   * 获取置顶文章
   */
  static async getTopArticles(): Promise<BaseResponse<Article[]>> {
    const url = `${WanAndroidService.BASE_URL}/article/top/json`;
    return WanAndroidService.request<Article[]>(url);
  }

  /**
   * 获取体系数据
   */
  static async getTree(): Promise<BaseResponse<TreeNode[]>> {
    const url = `${WanAndroidService.BASE_URL}/tree/json`;
    return WanAndroidService.request<TreeNode[]>(url);
  }

  /**
   * 根据分类ID获取文章
   * @param cid 分类ID
   * @param page 页码，从0开始
   */
  static async getArticlesByCategory(cid: number, page: number = 0): Promise<BaseResponse<PageData<Article>>> {
    const url = `${WanAndroidService.BASE_URL}/article/list/${page}/json?cid=${cid}`;
    return WanAndroidService.request<PageData<Article>>(url);
  }

  /**
   * 搜索文章
   * @param keyword 搜索关键词
   * @param page 页码，从0开始
   */
  static async searchArticles(keyword: string, page: number = 0): Promise<BaseResponse<PageData<Article>>> {
    const url = `${WanAndroidService.BASE_URL}/article/query/${page}/json?k=${encodeURIComponent(keyword)}`;
    return WanAndroidService.request<PageData<Article>>(url);
  }

  /**
   * 测试网络连接
   */
  static async testConnection(): Promise<boolean> {
    try {
      console.info('开始测试网络连接...');
      const response = await WanAndroidService.getBanner();
      console.info('网络连接测试成功');
      return response.errorCode === 0;
    } catch (error) {
      console.error('网络连接测试失败:', error);
      return false;
    }
  }
}
