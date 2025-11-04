import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { FormExtensionAbility } from '@kit.FormKit';
import type { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { weatherProvider } from '../providers/WeatherProvider';

const TAG: string = 'WeatherFormAbility';
const DOMAIN: number = 0x0001;

/**
 * 天气卡片 FormExtensionAbility
 * 负责卡片的生命周期管理和数据更新
 */
export default class WeatherFormAbility extends FormExtensionAbility {
  private updateTimer: number = -1;

  /**
   * 卡片创建时触发
   */
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, '🌤️ 天气卡片创建');

    const formId: string = want.parameters?.['ohos.extra.param.key.form_identity'] as string;
    hilog.info(DOMAIN, TAG, `formId: ${formId}`);

    // 获取随机天气数据
    const weatherData = weatherProvider.getRandomWeather();

    // 计算更新时间
    const lastUpdate = this.formatUpdateTime(weatherData.timestamp);

    // 返回卡片数据
    const formData: Record<string, Object> = {
      'city': weatherData.city,
      'temperature': weatherData.temperature,
      'weather': weatherData.weather,
      'weatherCode': weatherData.weatherCode,
      'humidity': weatherData.humidity,
      'windSpeed': weatherData.windSpeed,
      'timestamp': weatherData.timestamp,
      'lastUpdate': lastUpdate
    };

    hilog.info(DOMAIN, TAG, `🌤️ 初始天气: ${weatherData.city} ${weatherData.temperature}°C ${weatherData.weather}`);

    // 启动定时更新
    this.startPeriodicUpdate(formId);

    return formBindingData.createFormBindingData(formData);
  }

  /**
   * 卡片更新时触发
   */
  onUpdateForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `🔄 天气卡片更新: ${formId}`);

    // 获取最新天气数据
    const weatherData = weatherProvider.getRandomWeather();

    // 计算更新时间
    const lastUpdate = this.formatUpdateTime(weatherData.timestamp);

    const formData: Record<string, Object> = {
      'city': weatherData.city,
      'temperature': weatherData.temperature,
      'weather': weatherData.weather,
      'weatherCode': weatherData.weatherCode,
      'humidity': weatherData.humidity,
      'windSpeed': weatherData.windSpeed,
      'timestamp': weatherData.timestamp,
      'lastUpdate': lastUpdate
    };

    hilog.info(DOMAIN, TAG, `🌤️ 更新天气: ${weatherData.city} ${weatherData.temperature}°C ${weatherData.weather}`);

    // 更新卡片数据
    const formBindData: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);

    // 通知卡片刷新
    formProvider.updateForm(formId, formBindData).then(() => {
      hilog.info(DOMAIN, TAG, `✅ 天气卡片更新成功`);
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `❌ 天气卡片更新失败: ${error.message}`);
    });
  }

  /**
   * 卡片删除时触发
   */
  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `🗑️ 天气卡片删除: ${formId}`);
    
    // 停止定时更新
    this.stopPeriodicUpdate();
  }

  /**
   * 卡片事件处理
   */
  onFormEvent(formId: string, message: string): void {
    hilog.info(DOMAIN, TAG, `🔔 收到事件 - formId: ${formId}, message: ${message}`);

    // 处理刷新事件
    if (message === 'refresh') {
      hilog.info(DOMAIN, TAG, '🔄 开始刷新天气...');
      this.onUpdateForm(formId);
    }
  }

  /**
   * 获取卡片状态
   */
  onAcquireFormState(want: Want): formInfo.FormState {
    hilog.info(DOMAIN, TAG, '获取天气卡片状态');
    return formInfo.FormState.READY;
  }

  /**
   * 启动定时更新
   */
  private startPeriodicUpdate(formId: string): void {
    // 清除之前的定时器
    this.stopPeriodicUpdate();
    
    // 每5秒更新一次
    this.updateTimer = setInterval(() => {
      hilog.info(DOMAIN, TAG, '⏰ 定时更新天气卡片');
      this.onUpdateForm(formId);
    }, 5000);
    
    hilog.info(DOMAIN, TAG, '✅ 已启动定时更新，间隔5秒');
  }

  /**
   * 停止定时更新
   */
  private stopPeriodicUpdate(): void {
    if (this.updateTimer !== -1) {
      clearInterval(this.updateTimer);
      this.updateTimer = -1;
      hilog.info(DOMAIN, TAG, '⏹️ 已停止定时更新');
    }
  }

  /**
   * 格式化更新时间
   */
  private formatUpdateTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    
    if (diff < 60000) { // 小于1分钟
      return '刚刚更新';
    } else if (diff < 3600000) { // 小于1小时
      const minutes = Math.floor(diff / 60000);
      return `${minutes}分钟前更新`;
    } else {
      const date = new Date(timestamp);
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `今天 ${hours}:${minutes} 更新`;
    }
  }
}