import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { counterProvider } from '../providers/CounterProvider';

const TAG: string = 'CounterFormAbility';
const DOMAIN: number = 0x0005;

/**
 * 计数器卡片 FormExtensionAbility
 * 负责计数器卡片的生命周期管理和数据更新
 */
export default class CounterFormAbility extends FormExtensionAbility {
  /**
   * 卡片创建时触发
   */
  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, '🔢 计数器卡片创建');

    const formId: string = want.parameters?.['ohos.extra.param.key.form_identity'] as string;
    hilog.info(DOMAIN, TAG, `formId: ${formId}`);

    // 初始化计数器提供者（异步执行，不阻塞卡片创建）
    const applicationContext = this.context.getApplicationContext();
    counterProvider.initialize(applicationContext).then(() => {
      hilog.info(DOMAIN, TAG, '计数器提供者初始化成功');
      // 初始化完成后更新卡片
      this.onUpdateForm(formId);
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `计数器提供者初始化失败: ${error.message}`);
    });

    // 获取当前计数器数据
    const counterData = counterProvider.getCounterDataObject();

    // 返回卡片数据
    const formData: Record<string, Object> = {
      'value': counterData.value,
      'lastUpdateTime': counterData.lastUpdateTime,
      'lastUpdateSource': counterData.lastUpdateSource,
      'lastUpdateTimeString': counterData.lastUpdateTimeString
    };

    hilog.info(DOMAIN, TAG, `🔢 初始计数器值: ${counterData.value}`);

    // 设置定时器，每30秒自动刷新一次卡片
    setInterval(() => {
      this.onUpdateForm(formId);
    }, 30000);

    return formBindingData.createFormBindingData(formData);
  }

  /**
   * 卡片更新时触发
   */
  async onUpdateForm(formId: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `🔄 计数器卡片更新: ${formId}`);

    // 获取最新计数器数据
    const counterData = counterProvider.getCounterDataObject();

    const formData: Record<string, Object> = {
      'value': counterData.value,
      'lastUpdateTime': counterData.lastUpdateTime,
      'lastUpdateSource': counterData.lastUpdateSource,
      'lastUpdateTimeString': counterData.lastUpdateTimeString
    };

    hilog.info(DOMAIN, TAG, `🔢 更新计数器值: ${counterData.value}`);

    // 更新卡片数据
    const formBindData: formBindingData.FormBindingData = formBindingData.createFormBindingData(formData);

    // 通知卡片刷新
    formProvider.updateForm(formId, formBindData).then(() => {
      hilog.info(DOMAIN, TAG, `✅ 计数器卡片更新成功`);
    }).catch((error: Error) => {
      hilog.error(DOMAIN, TAG, `❌ 计数器卡片更新失败: ${error.message}`);
    });
  }

  /**
   * 卡片删除时触发
   */
  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `🗑️ 计数器卡片删除: ${formId}`);
  }

  /**
   * 卡片事件处理
   */
  async onFormEvent(formId: string, message: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `🔔 收到事件 - formId: ${formId}, message: ${message}`);

    // 初始化计数器提供者
    try {
      // 使用this.context.getApplicationContext()获取应用上下文
      const applicationContext = this.context.getApplicationContext();
      await counterProvider.initialize(applicationContext);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `计数器提供者初始化失败: ${error.message}`);
      return;
    }

    // 解析消息（可能是JSON字符串）
    let eventMessage = message;
    try {
      const messageObj = JSON.parse(message) as Record<string, string>;
      if (messageObj.message) {
        eventMessage = messageObj.message;
      }
    } catch (e) {
      // 如果解析失败，直接使用原始消息
      eventMessage = message;
    }

    hilog.info(DOMAIN, TAG, `🔔 解析后的事件消息: ${eventMessage}`);

    // 处理不同的事件
    if (eventMessage === 'increment') {
      hilog.info(DOMAIN, TAG, '➕ 增加计数器值');
      await counterProvider.incrementCounter(1, 'card');
      await this.onUpdateForm(formId);
    } else if (eventMessage === 'decrement') {
      hilog.info(DOMAIN, TAG, '➖ 减少计数器值');
      await counterProvider.decrementCounter(1, 'card');
      await this.onUpdateForm(formId);
    } else if (eventMessage === 'reset') {
      hilog.info(DOMAIN, TAG, '🔄 重置计数器值');
      await counterProvider.resetCounter('card');
      await this.onUpdateForm(formId);
    } else if (eventMessage === 'refresh') {
      hilog.info(DOMAIN, TAG, '🔄 刷新计数器值');
      await this.onUpdateForm(formId);
    }
  }

  /**
   * 获取卡片状态
   */
  onAcquireFormState(want: Want): formInfo.FormState {
    hilog.info(DOMAIN, TAG, '获取计数器卡片状态');
    return formInfo.FormState.READY;
  }
}