/**
 * 通用输入框组件
 */
import { ThemeConstants } from '../common/constants/ThemeConstants'

@Component
export struct CommonInput {
  // 标签文本
  @Prop label: string = ''
  // 占位符
  @Prop placeholder: string = ''
  // 输入值
  @Link value: string
  // 输入类型
  @Prop type: InputType = InputType.Normal
  // 最大长度
  @Prop maxLength: number = -1
  // 是否显示清除按钮
  @Prop showClear: boolean = false
  // 右侧插槽内容
  @BuilderParam rightSlot?: () => void
  // 输入变化回调
  onChange?: (value: string) => void
  
  build() {
    Column({ space: ThemeConstants.SPACE_XS }) {
      // 标签
      if (this.label) {
        Text(this.label)
          .fontSize(ThemeConstants.FONT_SIZE_XS)
          .fontColor(ThemeConstants.TEXT_SECONDARY)
          .alignSelf(ItemAlign.Start)
      }
      
      // 输入框容器
      Row({ space: ThemeConstants.SPACE_SM }) {
        TextInput({
          placeholder: this.placeholder,
          text: this.value
        })
          .layoutWeight(1)
          .height(ThemeConstants.INPUT_HEIGHT)
          .fontSize(ThemeConstants.FONT_SIZE_SM)
          .type(this.type)
          .maxLength(this.maxLength)
          .backgroundColor(ThemeConstants.BG_GRAY)
          .borderRadius(ThemeConstants.BORDER_RADIUS_SM)
          .onChange((value: string) => {
            this.value = value
            if (this.onChange) {
              this.onChange(value)
            }
          })
        
        // 右侧插槽(如验证码按钮)
        if (this.rightSlot) {
          this.rightSlot()
        }
      }
      .width('100%')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

