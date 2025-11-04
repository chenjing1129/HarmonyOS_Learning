import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { FormExtensionAbility } from '@kit.FormKit';
import type { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { timeProvider } from '../providers/TimeProvider';

const TAG: string = 'ClockFormAbility';
const DOMAIN: number = 0x0001;

/**
 * 时钟卡片 FormExtensionAbility
 * 负责卡片的生命周期管理和数据更新
 */
export default class ClockFormAbility extends FormExtensionAbility {
  /**
   * 卡片创建时触发
   */
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, '⏰ 时钟卡片创建');

    const formId: string = want.parameters?.['ohos.extra.param.key.form_identity'] as string;
    hilog.info(DOMAIN, TAG, `formId: ${formId}`);

    // 获取当前时间
    const timeData = timeProvider.getCurrentTime();

    // 返回卡片数据
    const formData: Record<string, Object> = {
      'year': timeData.year,
      'month': timeData.month,
      'day': timeData.day,
      'weekday': timeData.weekday,
      'hour': timeData.hour,
      'minute': timeData.minute,
      'second': timeData.second,
      'timestamp': timeData.timestamp
    };

    hilog.info(DOMAIN, TAG, `📅 初始时间: ${timeData.year}-${timeData.month}-${timeData.day} ${timeData.hour}:${timeData.minute}:${timeData.second}`);

    return formBindingData.createFormBindingData(formData);
  }

  /**
   * 卡片更新时触发
   */
  onUpdateForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `🔄 卡片更新: ${formId}`);

    // 获取最新时间
    const timeData = timeProvider.getCurrentTime();

    const formData: Record<string, Object> = {
      'year': timeData.year,
      'month': timeData.month,
      'day': timeData.day,
      'weekday': timeData.weekday,
      'hour': timeData.hour,
      'minute': timeData.minute,
      'second': timeData.second,
      'timestamp': timeData.timestamp
    };

    hilog.info(DOMAIN, TAG, `⏰ 更新时间: ${timeData.hour}:${timeData.minute}:${timeData.second}`);

    // 更新卡片数据
    const formBindData: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);

    // 通知卡片刷新
    formProvider.updateForm(formId, formBindData).then(() => {
      hilog.info(DOMAIN, TAG, `✅ 卡片更新成功`);
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `❌ 卡片更新失败: ${error.message}`);
    });
  }

  /**
   * 卡片删除时触发
   */
  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `🗑️ 卡片删除: ${formId}`);
  }

  /**
   * 卡片事件处理
   */
  onFormEvent(formId: string, message: string): void {
    hilog.info(DOMAIN, TAG, `🔔 收到事件 - formId: ${formId}, message: ${message}`);

    // 处理刷新事件
    if (message === 'refresh') {
      hilog.info(DOMAIN, TAG, '🔄 开始刷新时间...');
      this.onUpdateForm(formId);
    }
  }

  /**
   * 获取卡片状态
   */
  onAcquireFormState(want: Want): formInfo.FormState {
    hilog.info(DOMAIN, TAG, '获取卡片状态');
    return formInfo.FormState.READY;
  }
}
