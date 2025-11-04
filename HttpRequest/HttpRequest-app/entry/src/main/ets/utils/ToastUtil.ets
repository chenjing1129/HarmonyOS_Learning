/**
 * Toast提示工具类
 * 封装消息提示逻辑
 */
import promptAction from '@ohos.promptAction'

export class ToastUtil {
  /**
   * 显示普通提示
   */
  static show(message: string, duration: number = 2000): void {
    try {
      promptAction.showToast({
        message: message,
        duration: duration
      })
    } catch (err) {
      console.error('Toast显示失败', err)
    }
  }
  
  /**
   * 显示成功提示
   */
  static success(message: string): void {
    ToastUtil.show(`✓ ${message}`)
  }
  
  /**
   * 显示错误提示
   */
  static error(message: string): void {
    ToastUtil.show(`✗ ${message}`)
  }
  
  /**
   * 显示警告提示
   */
  static warning(message: string): void {
    ToastUtil.show(`⚠ ${message}`)
  }
  
  /**
   * 显示信息提示
   */
  static info(message: string): void {
    ToastUtil.show(`ℹ ${message}`)
  }
}

