# 智能备忘录 (SmartMemo)

一款基于 HarmonyOS 6.0.0 开发的现代化个人备忘录应用。

## ✨ 功能特性

### 🎯 核心功能
- **备忘录管理** - 创建、编辑、删除、标记完成
- **智能分类** - 标签系统、优先级管理
- **搜索筛选** - 全文搜索、多维度筛选
- **主题系统** - 明暗主题切换、字体大小调节
- **数据管理** - 导入导出、备份恢复

### 🚀 技术亮点
- **HarmonyOS 6.0.0** - 使用最新 API Level 20
- **ArkTS/ETS** - TypeScript 扩展语言开发
- **MVVM 架构** - 响应式数据绑定
- **Stage 模型** - 现代化应用框架
- **响应式设计** - 适配多设备屏幕

### 🎨 用户体验
- **精美动画** - 流畅的页面转场和交互反馈
- **无障碍支持** - 完整的无障碍功能
- **手势操作** - 滑动删除、长按选择
- **智能提醒** - 时间提醒、位置提醒（扩展功能）

## 📱 页面结构

### 主要页面
- **SplashPage** - 启动页面，应用初始化
- **MainPage** - 主页面，TabBar 导航结构
- **MemoListPage** - 备忘录列表，支持搜索筛选
- **MemoDetailPage** - 备忘录详情，编辑和查看
- **SettingsPage** - 设置页面，主题和配置管理

### 核心组件
- **MemoCard** - 备忘录卡片组件
- **PrioritySelector** - 优先级选择器
- **LoadingDialog** - 加载对话框
- **ThemeManager** - 主题管理器

## 🏗️ 项目架构

```
SmartMemo/
├── AppScope/                   # 应用级配置
│   └── app.json5               # 应用配置文件
├── entry/                      # 主模块
│   ├── src/main/
│   │   ├── ets/               # ArkTS源码
│   │   │   ├── entryability/  # 应用入口
│   │   │   ├── pages/         # 页面
│   │   │   ├── components/    # 组件
│   │   │   ├── viewmodel/     # 视图模型
│   │   │   ├── model/         # 数据模型
│   │   │   ├── service/       # 业务服务
│   │   │   ├── utils/         # 工具类
│   │   │   └── constants/     # 常量定义
│   │   └── resources/         # 资源文件
│   │       ├── base/          # 基础资源
│   │       ├── en_US/         # 英文资源
│   │       └── zh_CN/         # 中文资源
│   ├── build-profile.json5    # 构建配置
│   └── oh-package.json5       # 模块包配置
├── build-profile.json5        # 项目构建配置
├── oh-package.json5           # 项目包配置
└── hvigorfile.ts             # 构建脚本
```

## 💾 数据存储

### 存储方案
- **轻量级数据** - 使用 @ohos.data.preferences 存储设置
- **结构化数据** - 备忘录数据使用 JSON 格式持久化
- **文件存储** - 支持附件和多媒体文件

### 数据模型

可以这样设计备忘录的数据模型（第一版没有做这么多属性）

```typescript
interface MemoItem {
  id: string;              // 唯一标识
  title: string;           // 标题
  content: string;         // 内容
  tags: string[];          // 标签
  priority: Priority;      // 优先级
  createTime: number;      // 创建时间
  updateTime: number;      // 更新时间
  reminderTime?: number;   // 提醒时间
  location?: LocationInfo; // 位置信息
  attachments: Attachment[]; // 附件
  isCompleted: boolean;    // 完成状态
  isStarred: boolean;      // 星标状态
}
```

## 🎨 主题系统

### 主题模式
- **自动模式** - 跟随系统主题
- **浅色主题** - 明亮清新的界面风格
- **深色主题** - 护眼的暗色界面

### 颜色规范
```typescript
lightTheme = {
  background: '#F1F3F5',    // 背景色
  surface: '#FFFFFF',       // 表面色
  primary: '#007DFF',       // 主色调
  textPrimary: '#182431',   // 主要文本
  textSecondary: '#666666'  // 次要文本
}
```

## 🚀 开发指南

### 环境要求
- **DevEco Studio** 5.0+
- **HarmonyOS SDK** 6.0.0(20)
- **Node.js** 18+

### 构建命令
```bash
# 安装依赖
npm install

# 开发构建
hvigor assembleHap --mode debug

# 发布构建
hvigor assembleHap --mode release

# 清理构建
hvigor clean
```

### 测试命令
```bash
# 运行测试
hvigor test

# 代码检查
npm run lint
```

## 🎯 扩展功能规划

### Phase 1 - 多媒体支持
- **图片附件** - 支持图片查看和编辑
- **音频记录** - 语音备忘录功能
- **文件管理** - 附件管理和预览

### Phase 2 - 智能功能
- **语音转文字** - AI语音识别
- **OCR识别** - 图片文字提取
- **智能分类** - 自动标签推荐

### Phase 3 - 协作功能
- **云端同步** - 多设备数据同步
- **分享功能** - 备忘录分享
- **团队协作** - 共享备忘录空间
