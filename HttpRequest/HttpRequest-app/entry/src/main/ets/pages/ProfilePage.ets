import { PromptAction } from '@kit.ArkUI';
import { CustomDialog } from '../components/CustomDialog';
import { UserVO } from '../type/UserType';
import { storageUtil } from '../utils/StorageUtil';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UserApi } from '../api/userApi';
import { AuthApi } from '../api/authApi';

@Component
export struct ProfilePage {
  @StorageLink('isLoggedIn') @Watch('onLoginStateChange') globalLoginState: boolean = false;
  @State isLoggedIn: boolean = false;
  @State points: number = 100; // 默认积分
  @State collections: number = 5; // 收藏数
  @State hasSignedToday: boolean = false; // 今日是否已签到
  @State showCustomDialog: boolean = false;
  @State showBindMobileDialog: boolean = false; // 绑定手机号弹窗
  @State dialogTitle: string = '';
  @State dialogContent: string = '';
  @State bindMobile: string = ''; // 要绑定的手机号
  @State bindCode: string = ''; // 绑定手机号的验证码
  @State bindCountdown: number = 0; // 绑定验证码倒计时
  @State canSendBindCode: boolean = true; // 是否可以发送绑定验证码
  @State bindLoading: boolean = false; // 绑定操作加载中
  private bindTimer: number = -1; // 绑定验证码定时器
  // 获取当前 UI 上下文的 PromptAction 实例
  private promptAction: PromptAction = this.getUIContext().getPromptAction();
  @State userInfo: UserVO | null = null;

  // 组件即将显示时检查登录状态
  async aboutToAppear() {
    await this.checkLoginStatus();
  }

  // 监听全局登录状态变化
  onLoginStateChange() {
    // 当登录状态改变时，重新检查登录状态并获取用户信息
    this.checkLoginStatus();
  }

  // 手机号脱敏显示、隐藏中间四位
  private maskMobile(mobile: string): string {
    if (!mobile || mobile.length !== 11) {
      return '未绑定';
    }
    // 显示前3位和后4位，中间用*号代替
    return `${mobile.substring(0, 3)}****${mobile.substring(7)}`;
  }

  // 检查手机号是否已绑定
  private hasMobile(): boolean {
    return !!(this.userInfo && this.userInfo.mobile && this.userInfo.mobile.length === 11);
  }

  // 重置绑定表单
  private resetBindForm(): void {
    this.bindMobile = '';
    this.bindCode = '';
    this.bindCountdown = 0;
    this.canSendBindCode = true;
    this.bindLoading = false;
    if (this.bindTimer !== -1) {
      clearInterval(this.bindTimer);
      this.bindTimer = -1;
    }
  }

  // 检查登录状态并加载用户信息
  async checkLoginStatus() {
    try {
      const token = await storageUtil.get('token');

      if (token != null && token !== '') {
        this.isLoggedIn = true;

        // 优先从后端获取最新用户信息
        const userInfo = await UserApi.getUserInfo();

        if (userInfo) {
          this.userInfo = userInfo;
          await storageUtil.setObject('userInfo', userInfo);
        } else {
          // 如果后端获取失败，尝试从本地缓存读取
          const cachedUserInfo = await storageUtil.getObject<UserVO>('userInfo');
          if (cachedUserInfo) {
            this.userInfo = cachedUserInfo;
          }
        }

        // 检查今日是否已签到
        const lastSignDate = await storageUtil.get('lastSignDate');
        const today = new Date().toDateString();
        this.hasSignedToday = lastSignDate === today;
      } else {
        this.isLoggedIn = false;
        this.userInfo = null;
      }
    } catch (error) {
      hilog.error(0x0000, 'ProfilePage', `检查登录状态异常: ${JSON.stringify(error)}`);
      this.isLoggedIn = false;
      this.userInfo = null;
    }
  }

  // 跳转到登录页
  navigateToLogin() {
    // 保存当前页面索引（个人中心页是索引 2）
    AppStorage.set<number>('beforeLoginPageIndex', 2);
    this.getUIContext().getRouter().pushUrl({ url: 'pages/LoginPage' });
  }

  // 显示收藏弹窗
  showCollection() {
    if (!this.isLoggedIn) {
      this.promptAction.openToast({ message: '请先登录', duration: 1500 });
      this.navigateToLogin();
      return;
    }
    this.dialogTitle = '我的收藏';
    this.dialogContent =
      `您有 ${this.collections} 个收藏内容\n\n1. 收藏文章 A\n2. 收藏文章 B\n3. 收藏文章 C\n4. 收藏文章 D\n5. 收藏文章 E`;
    this.showCustomDialog = true;
  }

  // 显示积分弹窗
  showPoints() {
    if (!this.isLoggedIn) {
      this.promptAction.openToast({ message: '请先登录', duration: 1500 });
      this.navigateToLogin();
      return;
    }
    this.dialogTitle = '我的积分';
    this.dialogContent =
      `当前积分: ${this.points} 分\n\n积分明细:\n- 签到获得: 50 分\n- 浏览获得: 30 分\n- 分享获得: 20 分`;
    this.showCustomDialog = true;
  }

  // 今日签到
  async signIn() {
    if (!this.isLoggedIn) {
      this.promptAction.openToast({ message: '请先登录', duration: 1500 });
      this.navigateToLogin();
      return;
    }

    if (this.hasSignedToday) {
      this.promptAction.openToast({ message: '今日已签到', duration: 1500 });
      return;
    }

    // 签到成功，增加积分
    this.points += 10;
    this.hasSignedToday = true;

    // 保存签到日期
    const today = new Date().toDateString();
    await storageUtil.set('lastSignDate', today);

    this.promptAction.openToast({ message: '签到成功，获得 10 积分', duration: 2000 });
  }

  // 退出登录
  async logout() {
    try {
      // 清除本地存储
      await storageUtil.delete('token');
      await storageUtil.delete('userInfo');

      // 更新全局登录状态
      AppStorage.setOrCreate('isLoggedIn', false);

      this.promptAction.openToast({ message: '退出登录成功', duration: 1500 });

      // 更新状态，停留在当前页面显示未登录状态
      this.isLoggedIn = false;
      this.userInfo = null;
    } catch (error) {
      hilog.error(0x0000, 'ProfilePage', `退出登录异常: ${error}`);
      this.promptAction.openToast({ message: '退出登录失败', duration: 1500 }).catch(() => {
        // TODO: Implement error handling.
      });
    }
  }

  // 显示绑定手机号弹窗
  showBindMobile() {
    if (!this.isLoggedIn) {
      this.promptAction.openToast({ message: '请先登录', duration: 1500 });
      this.navigateToLogin();
      return;
    }
    this.bindMobile = '';
    this.bindCode = '';
    this.showBindMobileDialog = true;
  }

  // 发送绑定手机号验证码
  async sendBindCode() {
    const mobileReg = /^1[3-9]\d{9}$/;
    if (!mobileReg.test(this.bindMobile)) {
      this.promptAction.openToast({ message: '请输入正确的手机号', duration: 1500 });
      return;
    }

    this.bindLoading = true;
    try {
      const result = await AuthApi.sendSmsCode(this.bindMobile);
      this.bindLoading = false;

      if (result !== null) {
        const message = result ? `验证码发送成功: ${result}` : '验证码发送成功';
        this.promptAction.openToast({ message: message, duration: 2000 });
        // 开始倒计时
        this.startBindCountdown();
      } else {
        this.promptAction.openToast({ message: '验证码发送失败', duration: 2000 });
      }
    } catch (error) {
      this.bindLoading = false;
      hilog.error(0x0000, 'ProfilePage', `发送验证码异常: ${error}`);
      this.promptAction.openToast({ message: '发送异常,请重试', duration: 2000 });
    }
  }

  // 开始绑定验证码倒计时
  private startBindCountdown() {
    this.bindCountdown = 60;
    this.canSendBindCode = false;

    this.bindTimer = setInterval(() => {
      if (this.bindCountdown > 0) {
        this.bindCountdown--;
      } else {
        this.canSendBindCode = true;
        clearInterval(this.bindTimer);
        this.bindTimer = -1;
      }
    }, 1000);
  }

  // 确认绑定手机号
  async confirmBindMobile() {
    const mobileReg = /^1[3-9]\d{9}$/;
    if (!mobileReg.test(this.bindMobile)) {
      this.promptAction.openToast({ message: '请输入正确的手机号', duration: 1500 });
      return;
    }

    if (!this.bindCode || this.bindCode.length !== 4) {
      this.promptAction.openToast({ message: '请输入4位验证码', duration: 1500 });
      return;
    }

    this.bindLoading = true;
    try {
      const result = await AuthApi.bindMobile({ mobile: this.bindMobile, code: this.bindCode });
      this.bindLoading = false;

      if (result !== null) {
        this.promptAction.openToast({ message: '绑定成功', duration: 2000 });
        this.showBindMobileDialog = false;

        // 更新用户信息
        if (this.userInfo) {
          this.userInfo.mobile = this.bindMobile;
          await storageUtil.setObject('userInfo', this.userInfo);
        }
      } else {
        this.promptAction.openToast({ message: '绑定失败，请检查验证码', duration: 2000 });
      }
    } catch (error) {
      this.bindLoading = false;
      hilog.error(0x0000, 'ProfilePage', `绑定手机号异常: ${error}`);
      this.promptAction.openToast({ message: '绑定异常,请重试', duration: 2000 });
    }
  }

  // 组件销毁时清除定时器
  aboutToDisappear(): void {
    if (this.bindTimer !== -1) {
      clearInterval(this.bindTimer);
    }
  }

  build() {
    Stack() {
      Column({ space: 15 }) {
        // 用户信息区域
        if (this.isLoggedIn && this.userInfo) {
          // 已登录状态
          Column() {
            Row({ space: 15 }) {
              // 头像
              if (this.userInfo.avatar) {
                Image(this.userInfo.avatar)
                  .width(70)
                  .height(70)
                  .borderRadius(35)
              } else {
                Image($r('app.media.ic_avatar_placeholder'))
                  .width(70)
                  .height(70)
                  .borderRadius(35)
              }

              Column({ space: 8 }) {
                Text(this.userInfo.nickname || this.userInfo.username)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333')

                Row({ space: 5 }) {
                  Text('手机号:')
                    .fontSize(14)
                    .fontColor('#999')

                  if (this.hasMobile()) {
                    Text(this.maskMobile(this.userInfo!.mobile!))
                      .fontSize(14)
                      .fontColor('#333')
                  } else {
                    Row({ space: 5 }) {
                      Text('未绑定')
                        .fontSize(14)
                        .fontColor('#FF6B35')

                      Button('去绑定')
                        .fontSize(12)
                        .fontColor('#007DFF')
                        .backgroundColor(Color.Transparent)
                        .height(24)
                        .padding({ left: 8, right: 8 })
                        .onClick(() => this.showBindMobile())
                    }
                  }
                }

                Row({ space: 20 }) {
                  Text(`积分: ${this.points}`)
                    .fontSize(14)
                    .fontColor('#FF6B35')

                  Text(`收藏: ${this.collections}`)
                    .fontSize(14)
                    .fontColor('#007DFF')
                }
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .width('100%')
            .padding(20)
            .backgroundColor(Color.White)
            .borderRadius(12)

            // 签到按钮
            Button(this.hasSignedToday ? '今日已签到' : '今日签到')
              .width('100%')
              .height(44)
              .fontSize(16)
              .backgroundColor(this.hasSignedToday ? '#CCCCCC' : '#FF6B35')
              .fontColor(Color.White)
              .onClick(() => this.signIn())
              .enabled(!this.hasSignedToday)
              .margin({ top: 10 })
          }
          .width('90%')
          .margin({ top: 20 })
        } else {
          // 未登录状态
          Column() {
            Row({ space: 15 }) {
              Image($r('app.media.ic_avatar_placeholder'))
                .width(70)
                .height(70)
                .borderRadius(35)

              Column({ space: 8 }) {
                Text('未登录')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333')

                Text('登录后查看个人信息')
                  .fontSize(14)
                  .fontColor('#999')
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .padding(20)
            .backgroundColor(Color.White)
            .borderRadius(12)

            Button('去登录')
              .width('100%')
              .height(44)
              .fontSize(16)
              .backgroundColor('#007DFF')
              .fontColor(Color.White)
              .onClick(() => this.navigateToLogin())
              .margin({ top: 10 })
          }
          .width('90%')
          .margin({ top: 20 })
        }

        // 功能列表
        List({ space: 12 }) {
          ListItem() {
            ProfileItem({
              title: '我的收藏',
              subtitle: `${this.collections} 个收藏`,
              onItemClick: (): void => this.showCollection()
            })
          }

          ListItem() {
            ProfileItem({
              title: '我的积分',
              subtitle: `当前积分 ${this.points}`,
              onItemClick: (): void => this.showPoints()
            })
          }

          ListItem() {
            ProfileItem({
              title: this.hasMobile() ? '更换手机号' : '绑定手机号',
              subtitle: this.hasMobile() ? this.maskMobile(this.userInfo!.mobile!) : '点击绑定手机号',
              onItemClick: (): void => this.showBindMobile()
            })
          }

          if (this.isLoggedIn) {
            ListItem() {
              ProfileItem({
                title: '退出登录',
                subtitle: '',
                onItemClick: (): Promise<void> => this.logout()
              })
            }
          }
        }
        .width('90%')
        .height('100%')
        .margin({ top: 20 })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')

      // 自定义弹窗
      if (this.showCustomDialog) {
        CustomDialog({
          title: this.dialogTitle,
          content: this.dialogContent,
          onConfirm: () => {
            this.showCustomDialog = false;
          },
          onCancel: () => {
            this.showCustomDialog = false;
          }
        })
      }

      // 绑定手机号弹窗
      if (this.showBindMobileDialog) {
        Column() {
          // 弹窗背景
          Column({ space: 20 }) {
            // 标题
            Text('绑定手机号')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333')

            // 输入框
            Column({ space: 15 }) {
              // 手机号输入
              TextInput({ placeholder: '请输入手机号' })
                .width('100%')
                .height(50)
                .fontSize(16)
                .type(InputType.PhoneNumber)
                .maxLength(11)
                .onChange((value: string) => this.bindMobile = value)

              // 验证码输入
              Row({ space: 10 }) {
                TextInput({ placeholder: '请输入验证码' })
                  .height(50)
                  .fontSize(16)
                  .type(InputType.Number)
                  .maxLength(4)
                  .layoutWeight(1)
                  .onChange((value: string) => this.bindCode = value)

                Button(this.bindCountdown > 0 ? `${this.bindCountdown}秒` : '获取验证码')
                  .width(100)
                  .height(50)
                  .fontSize(12)
                  .onClick(() => this.sendBindCode())
                  .enabled(this.canSendBindCode && this.bindMobile.length === 11 && !this.bindLoading)
              }
            }

            // 按钮区域
            Row({ space: 12 }) {
              Button('取消')
                .width('48%')
                .height(44)
                .fontSize(16)
                .backgroundColor('#F0F0F0')
                .fontColor('#666')
                .onClick(() => {
                  this.showBindMobileDialog = false;
                  this.resetBindForm();
                })

              Button('确认绑定')
                .width('48%')
                .height(44)
                .fontSize(16)
                .backgroundColor('#007DFF')
                .fontColor(Color.White)
                .onClick(() => this.confirmBindMobile())
                .enabled(!this.bindLoading)
            }
            .width('100%')
          }
          .width('85%')
          .padding(25)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .shadow({
            radius: 20,
            color: '#40000000',
            offsetX: 0,
            offsetY: 4
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#80000000')
        .onClick(() => {
          // 阻止背景点击穿透
          // ArkTS 中 ClickEvent 没有 stopPropagation 方法
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ProfileItem {
  @Prop title: string = '';
  @Prop subtitle: string = '';
  onItemClick: () => void | Promise<void> = () => {
  };

  build() {
    Row({ space: 10 }) {
      Column({ space: 5 }) {
        Text(this.title)
          .fontSize(16)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)

        if (this.subtitle) {
          Text(this.subtitle)
            .fontSize(13)
            .fontColor('#999')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

        Text('›')
          .fontSize(20)
          .fontColor('#CCCCCC')
    }
    .width('100%')
    .height(this.subtitle ? 70 : 56)
    .backgroundColor(Color.White)
    .padding({ left: 20, right: 20 })
    .borderRadius(8)
    .onClick(() => this.onItemClick())
  }
}
