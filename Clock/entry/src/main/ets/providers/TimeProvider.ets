/**
 * 时间提供者
 * 负责获取当前时间数据
 */
export interface TimeData {
  year: string;
  month: string;
  day: string;
  weekday: string;
  hour: string;
  minute: string;
  second: string;
  timestamp: number;
}

export class TimeProvider {
  /**
   * 获取当前时间数据
   * @returns 当前时间数据对象
   */
  getCurrentTime(): TimeData {
    const now = new Date();
    
    // 获取年月日
    const year = now.getFullYear().toString();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    
    // 获取星期
    const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    const weekday = weekdays[now.getDay()];
    
    // 获取时分秒
    const hour = now.getHours().toString().padStart(2, '0');
    const minute = now.getMinutes().toString().padStart(2, '0');
    const second = now.getSeconds().toString().padStart(2, '0');
    
    // 获取时间戳
    const timestamp = now.getTime();
    
    return {
      year,
      month,
      day,
      weekday,
      hour,
      minute,
      second,
      timestamp
    };
  }
}

// 导出单例实例
export const timeProvider = new TimeProvider();