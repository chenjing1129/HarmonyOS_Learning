/**
 * 认证接口配置
 */
interface AuthEndpoints {
  LOGIN: string
  SMS_LOGIN: string
  SEND_SMS_CODE: string
  LOGOUT: string
}

/**
 * 用户接口配置
 */
interface UserEndpoints {
  USER_INFO: string
  UPDATE_PROFILE: string
}

/**
 * API常量配置
 */
export class ApiConstants {
  // 基础URL
  static readonly BASE_URL: string = 'http://10.20.222.182:8080'
  
  // 认证相关接口
  static readonly AUTH: AuthEndpoints = {
    LOGIN: '/api/auth/login', // 账号密码登录
    SMS_LOGIN: '/api/auth/sms-login', // 短信验证码登录
    SEND_SMS_CODE: '/api/auth/send-sms-code', // 发送短信验证码
    LOGOUT: '/api/auth/logout' // 登出
  }
  
  // 用户相关接口
  static readonly USER: UserEndpoints = {
    USER_INFO: '/api/user/user-info', // 获取当前登录用户信息
    UPDATE_PROFILE: '/api/user/update-profile' // 修改个人信息
  }
}

