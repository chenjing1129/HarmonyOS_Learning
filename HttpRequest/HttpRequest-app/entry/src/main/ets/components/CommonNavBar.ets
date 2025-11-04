/**
 * 通用导航栏组件
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'
import { RouterUtil } from '../utils/RouterUtil'

@Component
export struct CommonNavBar {
  // 标题
  @Prop title: string = ''
  // 是否显示返回按钮
  @Prop showBack: boolean = true
  // 返回按钮点击回调
  onBack?: () => void
  // 右侧插槽
  @BuilderParam rightSlot?: () => void
  
  build() {
    Row() {
      // 左侧返回按钮
      if (this.showBack) {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .width(ThemeConstants.ICON_SIZE_SM)
          .height(ThemeConstants.ICON_SIZE_SM)
          .fillColor(ThemeConstants.TEXT_PRIMARY)
          .onClick(() => {
            if (this.onBack) {
              this.onBack()
            } else {
              RouterUtil.back()
            }
          })
      } else {
        // 占位,保持标题居中
        Row()
          .width(ThemeConstants.ICON_SIZE_SM)
          .height(ThemeConstants.ICON_SIZE_SM)
      }
      
      // 标题
      Text(this.title)
        .fontSize(ThemeConstants.FONT_SIZE_MD)
        .fontWeight(FontWeight.Medium)
        .fontColor(ThemeConstants.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
      
      // 右侧插槽
      if (this.rightSlot) {
        this.rightSlot()
      } else {
        // 占位,保持标题居中
        Row()
          .width(ThemeConstants.ICON_SIZE_SM)
          .height(ThemeConstants.ICON_SIZE_SM)
      }
    }
    .width('100%')
    .height(ThemeConstants.NAVBAR_HEIGHT)
    .padding({ left: ThemeConstants.SPACE_MD, right: ThemeConstants.SPACE_MD })
    .backgroundColor(ThemeConstants.BG_WHITE)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }
}

