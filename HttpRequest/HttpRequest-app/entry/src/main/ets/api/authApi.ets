import { LoginDTO, SmsDTO, TokenVO } from '../type/AuthType'
import { AxiosUtil } from '../utils/AxiosUtils'

/**
 * 认证相关接口调用集合
 */
export class AuthApi {
  /**
   * 发送短信验证码
   * @param mobile 目标手机号
   * @returns 成功返回 message 或空字符串,失败返回 null
   */
  static async sendSmsCode(mobile: string): Promise<string | null> {
    try {
      // 接口地址:/api/auth/send-sms-code,请求方式:POST,参数以 query 形式传递
      const response = await AxiosUtil.post<string>(`/api/auth/send-sms-code?mobile=${mobile}`)
      // 判断 code 是否为 200,200 表示成功
      if (response.data.code === 200) {
        // 返回 message 或 data(可能都是空字符串)
        return response.data.message || response.data.data || ''
      } else {
        // code 不为 200,表示失败
        console.error(`发送短信验证码失败,code: ${response.data.code}, message: ${response.data.message}`)
        return null
      }
    } catch (error) {
      console.error('发送短信验证码异常:', error)
      return null
    }
  }

  /**
   * 短信验证码登录
   * @param params 短信登录参数(手机号+验证码)
   * @returns 登录成功的Token信息
   */
  static async smsLogin(params: SmsDTO): Promise<TokenVO | null> {
    try {
      const response = await AxiosUtil.post<TokenVO>('/api/auth/sms-login', params)

      // code 200 表示成功
      if (response.data.code === 200) {
        return response.data.data
      } else {
        console.error(`短信验证码登录失败,code: ${response.data.code}, message: ${response.data.message}`)
        return null
      }
    } catch (error) {
      console.error('短信验证码登录异常:', error)
      return null
    }
  }

  /**
   * 账号密码登录
   * @param params 登录参数(用户名+密码)
   * @returns 登录成功的Token信息
   */
  static async passwordLogin(params: LoginDTO): Promise<TokenVO | null> {
    try {
      // 接口地址:/api/auth/login,请求方式:POST,参数在body
      const response = await AxiosUtil.post<TokenVO>('/api/auth/login', params)

      // 判断 code 是否为 200,200 表示成功
      if (response.data.code === 200) {
        return response.data.data
      } else {
        console.error(`账号密码登录失败,code: ${response.data.code}, message: ${response.data.message}`)
        return null
      }
    } catch (error) {
      console.error('账号密码登录异常:', error)
      return null
    }
  }

  /**
   * 绑定手机号
   * @param params 绑定手机号参数(手机号+验证码)
   * @returns 成功返回 message,失败返回 null
   */
  static async bindMobile(params: SmsDTO): Promise<string | null> {
    try {
      const response = await AxiosUtil.post<string>('/api/auth/bind-mobile', params)

      // 判断 code 是否为 200,200 表示成功
      if (response.data.code === 200) {
        return response.data.message || response.data.data || ''
      } else {
        console.error(`绑定手机号失败,code: ${response.data.code}, message: ${response.data.message}`)
        return null
      }
    } catch (error) {
      console.error('绑定手机号异常:', error)
      return null
    }
  }

  /**
   * 退出登录
   * @returns 成功返回 message,失败返回 null
   */
  static async logout(): Promise<string | null> {
    try {
      const response = await AxiosUtil.post<string>('/api/auth/logout')

      if (response.data.code === 200) {
        return response.data.message || response.data.data || ''
      } else {
        console.error(`退出登录失败,code: ${response.data.code}, message: ${response.data.message}`)
        return null
      }
    } catch (error) {
      console.error('退出登录异常:', error)
      return null
    }
  }
}

