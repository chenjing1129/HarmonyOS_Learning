/**
 * 通用按钮组件
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'

export enum ButtonType {
  PRIMARY = 'primary',
  DANGER = 'danger',
  WARNING = 'warning',
  DEFAULT = 'default'
}

@Component
export struct CommonButton {
  // 按钮文本
  @Prop text: string = '按钮'
  // 按钮类型
  @Prop type: ButtonType = ButtonType.PRIMARY
  // 是否禁用
  @Prop disabled: boolean = false
  // 是否加载中
  @Prop loading: boolean = false
  // 点击回调
  onButtonClick?: () => void
  
  /**
   * 获取按钮背景色
   */
  private getBackgroundColor(): string {
    if (this.disabled) {
      return ThemeConstants.BG_DISABLED
    }
    
    switch (this.type) {
      case ButtonType.PRIMARY:
        return ThemeConstants.PRIMARY_COLOR
      case ButtonType.DANGER:
        return ThemeConstants.DANGER_COLOR
      case ButtonType.WARNING:
        return ThemeConstants.WARNING_COLOR
      default:
        return ThemeConstants.BG_WHITE
    }
  }
  
  /**
   * 获取按钮文字颜色
   */
  private getFontColor(): string {
    if (this.disabled) {
      return ThemeConstants.TEXT_TERTIARY
    }
    
    if (this.type === ButtonType.DEFAULT) {
      return ThemeConstants.TEXT_PRIMARY
    }
    
    return ThemeConstants.TEXT_WHITE
  }
  
  build() {
    Button(this.loading ? '加载中...' : this.text)
      .width('100%')
      .height(ThemeConstants.BUTTON_HEIGHT)
      .fontSize(ThemeConstants.FONT_SIZE_BASE)
      .fontColor(this.getFontColor())
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(ThemeConstants.BORDER_RADIUS_XL)
      .enabled(!this.disabled && !this.loading)
      .onClick(() => {
        if (this.onButtonClick && !this.disabled && !this.loading) {
          this.onButtonClick()
        }
      })
  }
}

