# HttpRequest 鸿蒙应用

基于 HarmonyOS 6.0 开发的 HTTP 请求示例应用,演示了完整的用户认证流程和个人中心功能。

## 功能特性

### 1. 三大主页面
- **首页**: 展示应用介绍和功能特性
- **发现页**: 展示探索内容的网格布局
- **个人中心**: 用户信息管理和功能入口

### 2. 用户认证
- **账号密码登录**: 传统的用户名密码登录方式
- **短信验证码登录**: 手机号+验证码快速登录
- **登录状态持久化**: Token 本地存储,自动保持登录状态
- **登录方式切换**: 在同一页面可以自由切换两种登录方式

### 3. 个人中心功能

#### 未登录状态
- 显示默认头像
- "去登录"按钮引导用户登录
- 功能菜单(我的收藏、我的积分等)点击后跳转登录

#### 登录后状态
- 显示用户头像、昵称、手机号等信息
- "今日签到"按钮
- 功能菜单可正常使用
- 点击收藏、积分等按钮弹出自定义弹窗展示数据
- 退出登录功能

### 4. 自定义组件
- **CustomDialog**: 封装的自定义弹窗组件,支持自定义标题、内容、按钮等

## 项目结构

```
entry/src/main/ets/
├── common/
│   └── constants/         # 常量定义
│       ├── ApiConstants.ets      # API接口常量
│       └── StorageKeys.ets       # 本地存储Key常量
├── components/            # 自定义组件
│   └── CustomDialog.ets          # 自定义弹窗组件
├── models/               # 数据模型
│   ├── AuthModels.ets           # 认证相关模型
│   └── UserModels.ets           # 用户相关模型
├── pages/                # 页面
│   ├── Index.ets                # 主页面(含底部导航)
│   ├── HomePage.ets             # 首页
│   ├── DiscoverPage.ets         # 发现页
│   ├── MinePage.ets             # 个人中心页
│   └── LoginPage.ets            # 登录页
├── services/             # 服务层
│   ├── HttpService.ets          # HTTP请求服务
│   ├── AuthService.ets          # 认证服务
│   └── UserService.ets          # 用户服务
└── utils/                # 工具类
    └── PreferencesUtil.ets      # 本地存储工具
```

## 后端API接口

应用对接的后端API包括:

### 认证接口
- `POST /api/auth/login` - 账号密码登录
- `POST /api/auth/send-sms-code` - 发送短信验证码
- `POST /api/auth/sms-login` - 短信验证码登录
- `POST /api/auth/logout` - 登出

### 用户接口
- `GET /api/user/user-info` - 获取当前用户信息

## 配置说明

### API 基础地址配置
在 `ApiConstants.ets` 中修改基础URL:

```typescript
static readonly BASE_URL = 'http://localhost:8083'
```

### 网络权限
已在 `module.json5` 中配置网络权限:

```json
"requestPermissions": [
  {
    "name": "ohos.permission.INTERNET"
  }
]
```

## 运行说明

1. **启动后端服务**
   - 进入 `api-template` 目录
   - 确保配置文件正确(数据库、Redis等)
   - 运行 Spring Boot 应用

2. **配置API地址**
   - 如果后端不在本地,修改 `ApiConstants.ets` 中的 `BASE_URL`

3. **运行鸿蒙应用**
   - 使用 DevEco Studio 打开 `HttpRequest-app` 项目
   - 连接真机或启动模拟器
   - 点击运行按钮

## 使用流程

1. **首次使用**
   - 启动应用,默认显示首页
   - 可以切换到发现页浏览内容
   - 切换到个人中心,显示未登录状态

2. **登录流程**
   - 点击"去登录"按钮进入登录页
   - 选择登录方式:
     - **账号密码登录**: 输入用户名和密码
     - **短信登录**: 输入手机号,点击获取验证码,输入收到的验证码
   - 点击登录按钮
   - 登录成功后自动返回个人中心

3. **登录后功能**
   - 查看个人信息
   - 点击"今日签到"按钮进行签到
   - 点击"我的收藏"查看收藏列表(弹窗展示)
   - 点击"我的积分"查看积分详情(弹窗展示)
   - 点击"退出登录"退出账号

## 技术特点

1. **模块化设计**: 清晰的目录结构,职责分明
2. **服务层封装**: HTTP请求、认证、用户等服务独立封装
3. **数据持久化**: 使用 Preferences 实现本地数据存储
4. **状态管理**: 使用 @State 管理组件状态
5. **错误处理**: 完善的错误处理和用户提示
6. **UI设计**: 现代化的UI设计,良好的用户体验

## 注意事项

1. **网络配置**: 确保设备可以访问后端API地址
2. **权限配置**: 已配置网络权限,无需额外操作
3. **Token过期**: Token过期后需要重新登录
4. **数据安全**: Token存储在本地,请注意数据安全

## 后续扩展

- [ ] 添加用户注册功能
- [ ] 完善个人信息编辑
- [ ] 实现真实的签到功能
- [ ] 添加更多业务功能
- [ ] 优化UI交互体验
- [ ] 添加加载状态和错误提示
- [ ] 实现下拉刷新和上拉加载

## 开发环境

- HarmonyOS SDK: API 12+
- DevEco Studio: 最新版本
- 语言: ArkTS
- 后端: Spring Boot + MySQL + Redis

