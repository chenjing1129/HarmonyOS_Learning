/**
 * 通用卡片组件
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'

@Component
export struct CommonCard {
  // 内边距
  @Prop padding: number = ThemeConstants.SPACE_MD
  // 圆角
  @Prop borderRadius: number = ThemeConstants.BORDER_RADIUS_MD
  // 背景色
  @Prop backgroundColor: string = ThemeConstants.BG_WHITE
  // 是否显示阴影
  @Prop showShadow: boolean = true
  // 点击回调
  onClick?: () => void
  // 内容插槽
  @BuilderParam content: () => void
  
  build() {
    Column() {
      if (this.content) {
        this.content()
      }
    }
    .width('100%')
    .padding(this.padding)
    .backgroundColor(this.backgroundColor)
    .borderRadius(this.borderRadius)
    .shadow(this.showShadow ? ThemeConstants.SHADOW_NORMAL : undefined)
    .onClick(() => {
      if (this.onClick) {
        this.onClick()
      }
    })
  }
}

