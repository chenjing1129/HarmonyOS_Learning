/**
 * 认证相关类型定义
 */

// 账号密码登录DTO
export interface LoginDTO {
  username: string
  password: string
}

// 短信登录、绑定手机号、换绑手机号DTO
export interface SmsDTO {
  mobile: string
  code: string
}

// 登录返回Token
export interface TokenVO {
  token: string
  expiresIn: number
}

