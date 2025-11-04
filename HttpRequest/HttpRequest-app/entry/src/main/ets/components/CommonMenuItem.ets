/**
 * 通用菜单项组件
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'

@Component
export struct CommonMenuItem {
  // 图标
  @Prop icon: string = ''
  // 标题
  @Prop title: string = ''
  // 右侧文本
  @Prop rightText: string = ''
  // 是否显示分割线
  @Prop showDivider: boolean = false
  // 点击回调
  onClick?: () => void
  
  build() {
    Column() {
      Row({ space: ThemeConstants.SPACE_MD }) {
        // 图标
        if (this.icon) {
          Text(this.icon)
            .fontSize(ThemeConstants.FONT_SIZE_XL)
            .width(ThemeConstants.ICON_SIZE_MD)
            .textAlign(TextAlign.Center)
        }
        
        // 标题
        Text(this.title)
          .fontSize(ThemeConstants.FONT_SIZE_BASE)
          .fontColor(ThemeConstants.TEXT_PRIMARY)
          .layoutWeight(1)
        
        // 右侧文本
        if (this.rightText) {
          Text(this.rightText)
            .fontSize(ThemeConstants.FONT_SIZE_XS)
            .fontColor(ThemeConstants.TEXT_TERTIARY)
        }
        
        // 箭头
        Text('›')
          .fontSize(20)
          .fontColor(ThemeConstants.TEXT_PLACEHOLDER)
      }
      .width('100%')
      .height(56)
      .padding({ left: ThemeConstants.SPACE_MD, right: ThemeConstants.SPACE_MD })
      
      // 分割线
      if (this.showDivider) {
        Divider()
          .color(ThemeConstants.DIVIDER_COLOR)
          .margin({ left: 56 })
      }
    }
    .width('100%')
    .onClick(() => {
      if (this.onClick) {
        this.onClick()
      }
    })
  }
}

