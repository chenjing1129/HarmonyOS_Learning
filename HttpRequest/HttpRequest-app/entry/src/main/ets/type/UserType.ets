/**
 * 用户相关类型定义
 */

/**
 * 用户信息 VO (与后端接口对应)
 */
export interface UserVO {
  id: number
  username: string
  realName?: string
  email?: string
  mobile?: string
  avatar?: string
  nickname?: string
  gender?: number // 0-未知,1-男,2-女
  status?: number // 0-禁用,1-正常
  createTime?: string
}

