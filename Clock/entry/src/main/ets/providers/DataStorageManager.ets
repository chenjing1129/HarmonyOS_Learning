import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'DataStorageManager';
const DOMAIN: number = 0x0003;
const DATA_PREFERENCES_NAME: string = 'counter_data';

/**
 * 数据存储管理器
 * 负责计数器数据的本地存储和读取
 */
export class DataStorageManager {
  private static instance: DataStorageManager;
  private dataPreferences: preferences.Preferences | null = null;

  private constructor() {}

  /**
   * 获取单例实例
   */
  static getInstance(): DataStorageManager {
    if (!DataStorageManager.instance) {
      DataStorageManager.instance = new DataStorageManager();
    }
    return DataStorageManager.instance;
  }

  /**
   * 初始化数据存储
   */
  async initialize(context: Context): Promise<void> {
    try {
      this.dataPreferences = await preferences.getPreferences(context, DATA_PREFERENCES_NAME);
      hilog.info(DOMAIN, TAG, '数据存储初始化成功');
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `数据存储初始化失败: ${err.code}, ${err.message}`);
    }
  }

  /**
   * 保存计数器值
   */
  async saveCounterValue(value: number): Promise<boolean> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return false;
    }

    try {
      await this.dataPreferences.put('counterValue', value);
      await this.dataPreferences.flush();
      hilog.info(DOMAIN, TAG, `计数器值已保存: ${value}`);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `保存计数器值失败: ${err.code}, ${err.message}`);
      return false;
    }
  }

  /**
   * 获取计数器值
   */
  async getCounterValue(): Promise<number> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return 0;
    }

    try {
      const value = await this.dataPreferences.get('counterValue', 0) as number;
      hilog.info(DOMAIN, TAG, `获取计数器值: ${value}`);
      return value;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `获取计数器值失败: ${err.code}, ${err.message}`);
      return 0;
    }
  }

  /**
   * 保存最后更新时间
   */
  async saveLastUpdateTime(timestamp: number): Promise<boolean> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return false;
    }

    try {
      await this.dataPreferences.put('lastUpdateTime', timestamp);
      await this.dataPreferences.flush();
      hilog.info(DOMAIN, TAG, `最后更新时间已保存: ${timestamp}`);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `保存最后更新时间失败: ${err.code}, ${err.message}`);
      return false;
    }
  }

  /**
   * 获取最后更新时间
   */
  async getLastUpdateTime(): Promise<number> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return 0;
    }

    try {
      const timestamp = await this.dataPreferences.get('lastUpdateTime', 0) as number;
      hilog.info(DOMAIN, TAG, `获取最后更新时间: ${timestamp}`);
      return timestamp;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `获取最后更新时间失败: ${err.code}, ${err.message}`);
      return 0;
    }
  }

  /**
   * 保存最后更新来源
   */
  async saveLastUpdateSource(source: string): Promise<boolean> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return false;
    }

    try {
      await this.dataPreferences.put('lastUpdateSource', source);
      await this.dataPreferences.flush();
      hilog.info(DOMAIN, TAG, `最后更新来源已保存: ${source}`);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `保存最后更新来源失败: ${err.code}, ${err.message}`);
      return false;
    }
  }

  /**
   * 获取最后更新来源
   */
  async getLastUpdateSource(): Promise<string> {
    if (!this.dataPreferences) {
      hilog.error(DOMAIN, TAG, '数据存储未初始化');
      return '';
    }

    try {
      const source = await this.dataPreferences.get('lastUpdateSource', '') as string;
      hilog.info(DOMAIN, TAG, `获取最后更新来源: ${source}`);
      return source;
    } catch (error) {
      const err = error as BusinessError;
      hilog.error(DOMAIN, TAG, `获取最后更新来源失败: ${err.code}, ${err.message}`);
      return '';
    }
  }
}

// 导出单例实例
export const dataStorageManager = DataStorageManager.getInstance();