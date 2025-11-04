import { WanAndroidAxios } from '../utils/AxiosUtils'
import { BannerVO, ArticleVO, PageVO, TopArticleVO, HotKeyVO } from '../type/WanAndroidType'

/**
 * 玩安卓API接口
 */
export class WanAndroidApi {
  /**
   * 获取首页Banner
   */
  static async getBanner(): Promise<BannerVO[] | null> {
    try {
      const response = await WanAndroidAxios.get<BannerVO[]>('/banner/json')
      if (response.data.errorCode === 0) {
        return response.data.data
      } else {
        console.error(`获取Banner失败,errorCode: ${response.data.errorCode}, errorMsg: ${response.data.errorMsg}`)
        return null
      }
    } catch (error) {
      console.error('获取Banner异常:', error)
      return null
    }
  }

  /**
   * 获取首页文章列表
   * @param page 页码,从0开始
   */
  static async getArticleList(page: number = 0): Promise<PageVO<ArticleVO> | null> {
    try {
      const response = await WanAndroidAxios.get<PageVO<ArticleVO>>(
        `/article/list/${page}/json`
      )
      if (response.data.errorCode === 0) {
        return response.data.data
      } else {
        console.error(`获取文章列表失败,errorCode: ${response.data.errorCode}, errorMsg: ${response.data.errorMsg}`)
        return null
      }
    } catch (error) {
      console.error('获取文章列表异常:', error)
      return null
    }
  }

  /**
   * 获取置顶文章
   */
  static async getTopArticles(): Promise<TopArticleVO[] | null> {
    try {
      const response = await WanAndroidAxios.get<TopArticleVO[]>('/article/top/json')
      if (response.data.errorCode === 0) {
        return response.data.data
      } else {
        console.error(`获取置顶文章失败,errorCode: ${response.data.errorCode}, errorMsg: ${response.data.errorMsg}`)
        return null
      }
    } catch (error) {
      console.error('获取置顶文章异常:', error)
      return null
    }
  }

  /**
   * 获取搜索热词
   */
  static async getHotKeys(): Promise<HotKeyVO[] | null> {
    try {
      const response = await WanAndroidAxios.get<HotKeyVO[]>(
        '/hotkey/json'
      )
      if (response.data.errorCode === 0) {
        return response.data.data
      } else {
        console.error(`获取热词失败,errorCode: ${response.data.errorCode}, errorMsg: ${response.data.errorMsg}`)
        return null
      }
    } catch (error) {
      console.error('获取热词异常:', error)
      return null
    }
  }
}

