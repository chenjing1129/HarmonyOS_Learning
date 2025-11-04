/**
 * Tab列表项类型定义
 */
export interface TabListItem {
  // Tab标签文本
  label: string;
  // 默认图标
  icon: Resource;
  // 选中图标
  selectedIcon: Resource;
  // Tab对应的组件Builder
  component: WrappedBuilder<[]>;
}

