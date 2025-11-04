/**
 * 登录页面
 */
import { LoginDTO, SmsDTO, TokenVO } from '../type/AuthType'
import { AuthApi } from '../api/authApi'
import { storageUtil } from '../utils/StorageUtil'
import { ThemeConstants } from '../common/constants/ThemeConstants'
import { RouterUtil } from '../utils/RouterUtil'
import { ToastUtil } from '../utils/ToastUtil'
import { CommonNavBar } from '../components/CommonNavBar'
import { CommonInput } from '../components/CommonInput'
import { CommonButton, ButtonType } from '../components/CommonButton'
import { PromptAction } from '@kit.ArkUI'

@Entry
@Component
struct LoginPage {
  @State loginType: number = 0 // 0-账号密码, 1-短信验证码
  @State username: string = ''
  @State password: string = ''
  @State mobile: string = ''
  @State smsCode: string = ''
  @State countdown: number = 0
  @State isLoading: boolean = false

  private timer: number = -1
  private promptAction: PromptAction = this.getUIContext().getPromptAction()

  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer)
    }
  }

  /**
   * 切换登录方式
   */
  switchLoginType() {
    this.loginType = this.loginType === 0 ? 1 : 0
    this.clearInputs()
  }

  /**
   * 清空输入
   */
  clearInputs() {
    this.username = ''
    this.password = ''
    this.mobile = ''
    this.smsCode = ''
  }

  /**
   * 账号密码登录
   */
  async handlePasswordLogin() {
    if (!this.username) {
      ToastUtil.warning('请输入用户名')
      return
    }
    if (!this.password) {
      ToastUtil.warning('请输入密码')
      return
    }

    this.isLoading = true
    try {
      const loginDTO: LoginDTO = {
        username: this.username,
        password: this.password
      }
      const tokenVO = await AuthApi.passwordLogin(loginDTO)

      if (tokenVO) {
        // 保存 Token 到本地
        await storageUtil.set('token', tokenVO.token)
        await storageUtil.set('expiresIn', tokenVO.expiresIn)

        // 更新全局登录状态
        AppStorage.setOrCreate('isLoggedIn', true)

        // 切换到个人中心标签页
        AppStorage.setOrCreate('currentTabIndex', 2)

        ToastUtil.success('登录成功')

        // 延迟跳转，确保状态已同步
        setTimeout(() => {
          RouterUtil.replace('pages/MainPage')
        }, 200)
      } else {
        ToastUtil.error('登录失败,请检查用户名和密码')
      }
    } catch (err) {
      console.error('登录失败', JSON.stringify(err))
      ToastUtil.error('登录失败,请检查用户名和密码')
    } finally {
      this.isLoading = false
    }
  }

  /**
   * 发送短信验证码
   */
  async sendSmsCode() {
    if (!this.mobile) {
      ToastUtil.warning('请输入手机号')
      return
    }

    const mobileReg = /^1[3-9]\d{9}$/
    if (!mobileReg.test(this.mobile)) {
      ToastUtil.warning('手机号格式不正确')
      return
    }

    try {
      const result = await AuthApi.sendSmsCode(this.mobile)
      if (result !== null) {
        ToastUtil.success('验证码已发送')

        // 开始倒计时
        this.countdown = 60
        this.timer = setInterval(() => {
          this.countdown--
          if (this.countdown <= 0) {
            clearInterval(this.timer)
            this.timer = -1
          }
        }, 1000)
      } else {
        ToastUtil.error('发送验证码失败')
      }
    } catch (err) {
      console.error('发送验证码失败', JSON.stringify(err))
      ToastUtil.error('发送验证码失败')
    }
  }

  /**
   * 短信验证码登录
   */
  async handleSmsLogin() {
    if (!this.mobile) {
      ToastUtil.warning('请输入手机号')
      return
    }
    if (!this.smsCode) {
      ToastUtil.warning('请输入验证码')
      return
    }

    this.isLoading = true
    try {
      const smsLoginDTO: SmsDTO = {
        mobile: this.mobile,
        code: this.smsCode
      }
      const tokenVO = await AuthApi.smsLogin(smsLoginDTO)

      if (tokenVO) {
        // 保存 Token 到本地
        await storageUtil.set('token', tokenVO.token)
        await storageUtil.set('expiresIn', tokenVO.expiresIn)

        // 更新全局登录状态
        AppStorage.setOrCreate('isLoggedIn', true)

        // 切换到个人中心标签页
        AppStorage.setOrCreate('currentTabIndex', 2)

        ToastUtil.success('登录成功')

        // 延迟跳转，确保状态已同步
        setTimeout(() => {
          RouterUtil.replace('pages/MainPage')
        }, 200)
      } else {
        ToastUtil.error('登录失败,请检查手机号和验证码')
      }
    } catch (err) {
      console.error('登录失败', JSON.stringify(err))
      ToastUtil.error('登录失败,请检查手机号和验证码')
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Column() {
      // 导航栏
      CommonNavBar({ title: '登录' })

      Scroll() {
        Column({ space: ThemeConstants.SPACE_LG }) {
          // Logo区域
          this.LogoSection()

          // 登录表单
          Column({ space: ThemeConstants.SPACE_MD }) {
            if (this.loginType === 0) {
              this.PasswordLoginForm()
            } else {
              this.SmsLoginForm()
            }

            // 登录按钮
            CommonButton({
              text: '登录',
              loading: this.isLoading,
              onButtonClick: () => {
                if (this.loginType === 0) {
                  this.handlePasswordLogin()
                } else {
                  this.handleSmsLogin()
                }
              }
            })

            // 切换登录方式
            this.SwitchLoginType()
          }
          .width('100%')
        }
        .padding(ThemeConstants.SPACE_LG)
      }
      .layoutWeight(1)
      .backgroundColor(ThemeConstants.BG_WHITE)
    }
    .width('100%')
    .height('100%')
  }

  /**
   * Logo区域
   */
  @Builder
  LogoSection() {
    Column({ space: ThemeConstants.SPACE_SM }) {
      Image($r('app.media.startIcon'))
        .width(ThemeConstants.ICON_SIZE_LG)
        .height(ThemeConstants.ICON_SIZE_LG)
        .borderRadius(ThemeConstants.BORDER_RADIUS_LG)

      Text('欢迎回来')
        .fontSize(ThemeConstants.FONT_SIZE_XL)
        .fontWeight(FontWeight.Bold)
        .fontColor(ThemeConstants.TEXT_PRIMARY)

      Text(this.loginType === 0 ? '使用账号密码登录' : '使用手机号验证码登录')
        .fontSize(ThemeConstants.FONT_SIZE_XS)
        .fontColor(ThemeConstants.TEXT_TERTIARY)
    }
    .margin({ top: 40, bottom: 20 })
  }

  /**
   * 账号密码登录表单
   */
  @Builder
  PasswordLoginForm() {
    Column({ space: ThemeConstants.SPACE_MD }) {
      CommonInput({
        label: '用户名',
        placeholder: '请输入用户名',
        value: $username
      })

      CommonInput({
        label: '密码',
        placeholder: '请输入密码',
        value: $password,
        type: InputType.Password
      })
    }
  }

  /**
   * 短信验证码登录表单
   */
  @Builder
  SmsLoginForm() {
    Column({ space: ThemeConstants.SPACE_MD }) {
      CommonInput({
        label: '手机号',
        placeholder: '请输入手机号',
        value: $mobile,
        type: InputType.PhoneNumber,
        maxLength: 11
      })

      CommonInput({
        label: '验证码',
        placeholder: '请输入验证码',
        value: $smsCode,
        type: InputType.Number,
        maxLength: 6,
        rightSlot: () => {
          this.SmsCodeButton()
        }
      })
    }
  }

  /**
   * 验证码按钮
   */
  @Builder
  SmsCodeButton() {
    Button(this.countdown > 0 ? `${this.countdown}秒` : '获取验证码')
      .height(ThemeConstants.INPUT_HEIGHT)
      .fontSize(ThemeConstants.FONT_SIZE_XS)
      .fontColor(this.countdown > 0 ? ThemeConstants.TEXT_TERTIARY : ThemeConstants.PRIMARY_COLOR)
      .backgroundColor(this.countdown > 0 ? ThemeConstants.BG_DISABLED : ThemeConstants.PRIMARY_LIGHT_COLOR)
      .borderRadius(ThemeConstants.BORDER_RADIUS_SM)
      .enabled(this.countdown <= 0)
      .onClick(() => {
        this.sendSmsCode()
      })
  }

  /**
   * 切换登录方式
   */
  @Builder
  SwitchLoginType() {
    Row() {
      Text(this.loginType === 0 ? '使用短信验证码登录' : '使用账号密码登录')
        .fontSize(ThemeConstants.FONT_SIZE_XS)
        .fontColor(ThemeConstants.PRIMARY_COLOR)
        .onClick(() => {
          this.switchLoginType()
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .margin({ top: ThemeConstants.SPACE_MD })
  }
}
