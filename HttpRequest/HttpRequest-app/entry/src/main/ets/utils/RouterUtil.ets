/**
 * 路由工具类
 * 封装路由跳转逻辑
 */
import { router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'

export class RouterUtil {
  /**
   * 跳转到登录页
   */
  static toLogin(): void {
    router.pushUrl({
      url: 'pages/LoginPage'
    }).catch((err: BusinessError) => {
      console.error('路由跳转失败', JSON.stringify(err))
    })
  }
  
  /**
   * 返回上一页
   */
  static back(): void {
    router.back()
  }
  
  /**
   * 跳转到指定页面
   */
  static push(url: string, params?: object): void {
    router.pushUrl({
      url: url,
      params: params
    }).catch((err: BusinessError) => {
      console.error('路由跳转失败', JSON.stringify(err))
    })
  }
  
  /**
   * 替换当前页面
   */
  static replace(url: string, params?: object): void {
    router.replaceUrl({
      url: url,
      params: params
    }).catch((err: BusinessError) => {
      console.error('路由替换失败', JSON.stringify(err))
    })
  }
  
  /**
   * 清空路由栈并跳转
   */
  static clear(url: string): void {
    router.clear()
    router.pushUrl({
      url: url
    }).catch((err: BusinessError) => {
      console.error('路由跳转失败', JSON.stringify(err))
    })
  }
}

