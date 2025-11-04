import { hilog } from '@kit.PerformanceAnalysisKit';
import { dataStorageManager } from './DataStorageManager';

const TAG: string = 'CounterProvider';
const DOMAIN: number = 0x0004;

/**
 * 计数器数据提供者
 * 负责计数器数据的管理和同步
 */
export class CounterProvider {
  private static instance: CounterProvider;
  private counterValue: number = 0;
  private lastUpdateTime: number = 0;
  private lastUpdateSource: string = '';
  private isInitialized: boolean = false;

  private constructor() {}

  /**
   * 获取单例实例
   */
  static getInstance(): CounterProvider {
    if (!CounterProvider.instance) {
      CounterProvider.instance = new CounterProvider();
    }
    return CounterProvider.instance;
  }

  /**
   * 初始化计数器数据
   */
  async initialize(context: Context): Promise<void> {
    if (this.isInitialized) {
      hilog.info(DOMAIN, TAG, '计数器提供者已初始化');
      return;
    }

    try {
      // 初始化数据存储
      await dataStorageManager.initialize(context);
      
      // 加载计数器数据
      this.counterValue = await dataStorageManager.getCounterValue();
      this.lastUpdateTime = await dataStorageManager.getLastUpdateTime();
      this.lastUpdateSource = await dataStorageManager.getLastUpdateSource();
      
      this.isInitialized = true;
      hilog.info(DOMAIN, TAG, `计数器提供者初始化完成，当前值: ${this.counterValue}`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `计数器提供者初始化失败: ${error}`);
    }
  }

  /**
   * 获取计数器值
   */
  getCounterValue(): number {
    return this.counterValue;
  }

  /**
   * 设置计数器值
   */
  async setCounterValue(value: number, source: string = 'unknown'): Promise<boolean> {
    try {
      this.counterValue = value;
      this.lastUpdateTime = Date.now();
      this.lastUpdateSource = source;
      
      // 保存到本地存储
      const success = await dataStorageManager.saveCounterValue(value);
      if (success) {
        await dataStorageManager.saveLastUpdateTime(this.lastUpdateTime);
        await dataStorageManager.saveLastUpdateSource(source);
      }
      
      hilog.info(DOMAIN, TAG, `计数器值已更新为: ${value}, 来源: ${source}`);
      return success;
    } catch (error) {
      hilog.error(DOMAIN, TAG, `设置计数器值失败: ${error}`);
      return false;
    }
  }

  /**
   * 增加计数器值
   */
  async incrementCounter(increment: number = 1, source: string = 'unknown'): Promise<boolean> {
    return this.setCounterValue(this.counterValue + increment, source);
  }

  /**
   * 减少计数器值
   */
  async decrementCounter(decrement: number = 1, source: string = 'unknown'): Promise<boolean> {
    return this.setCounterValue(this.counterValue - decrement, source);
  }

  /**
   * 重置计数器
   */
  async resetCounter(source: string = 'unknown'): Promise<boolean> {
    return this.setCounterValue(0, source);
  }

  /**
   * 获取最后更新时间
   */
  getLastUpdateTime(): number {
    return this.lastUpdateTime;
  }

  /**
   * 获取最后更新来源
   */
  getLastUpdateSource(): string {
    return this.lastUpdateSource;
  }

  /**
   * 格式化最后更新时间为可读字符串
   */
  getLastUpdateTimeString(): string {
    if (this.lastUpdateTime === 0) {
      return '从未更新';
    }
    const date = new Date(this.lastUpdateTime);
    return date.toLocaleString();
  }

  /**
   * 格式化时间
   * @param timestamp 时间戳
   * @returns 格式化的时间字符串
   */
  private formatTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    
    // 小于1分钟
    if (diff < 60 * 1000) {
      return '刚刚';
    }
    
    // 小于1小时
    if (diff < 60 * 60 * 1000) {
      const minutes = Math.floor(diff / (60 * 1000));
      return `${minutes}分钟前`;
    }
    
    // 小于1天
    if (diff < 24 * 60 * 60 * 1000) {
      const hours = Math.floor(diff / (60 * 60 * 1000));
      return `${hours}小时前`;
    }
    
    // 大于1天
    const days = Math.floor(diff / (24 * 60 * 60 * 1000));
    return `${days}天前`;
  }

  /**
   * 获取计数器数据
   * @returns 计数器数据
   */
  getCounterData(): CounterData {
    return {
      value: this.counterValue,
      lastUpdateTime: this.lastUpdateTime,
      lastUpdateSource: this.lastUpdateSource,
      lastUpdateTimeString: this.formatTime(this.lastUpdateTime)
    };
  }

  /**
   * 获取计数器数据对象
   * @returns 计数器数据对象
   */
  getCounterDataObject(): CounterDataObject {
    return {
      value: this.counterValue,
      lastUpdateTime: this.lastUpdateTime,
      lastUpdateSource: this.lastUpdateSource,
      lastUpdateTimeString: this.formatTime(this.lastUpdateTime)
    };
  }
}

/**
 * 计数器数据接口
 */
export interface CounterData {
  value: number;
  lastUpdateTime: number;
  lastUpdateSource: string;
  lastUpdateTimeString: string;
}

/**
 * 计数器数据对象接口
 */
export interface CounterDataObject {
  value: number;
  lastUpdateTime: number;
  lastUpdateSource: string;
  lastUpdateTimeString: string;
}

// 导出单例实例
export const counterProvider = CounterProvider.getInstance();