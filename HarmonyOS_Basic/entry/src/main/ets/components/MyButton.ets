/**
 * MyButton.ets
 * 简要描述: 自定义按钮组件，支持自定义文字和背景色
 * 作者: cj
 * 日期: 2025/9/9
 */

// 定义按钮属性接口
interface ButtonProps {
  text: string; // 按钮文字
  backgroundColor: string; // 背景颜色
  onClick?: () => void; // 点击事件（可选）
}

@Component
export struct MyButton {
  // 按钮文字，默认值
  @Prop buttonText: string = '按钮'
  // 背景颜色，默认值
  @Prop bgColor: string = '#007DFF'
  // 点击事件回调
  onButtonClick?: () => void
  // 可选的字体颜色和大小
  @Prop fontColor: Color | string = Color.White
  @Prop fontSize: number = 16

  build() {
    Button(this.buttonText)
        .type(ButtonType.Normal)
      .backgroundColor(this.bgColor)
      .fontColor(this.fontColor)
      .fontSize(this.fontSize)
      .borderRadius(8)
      .padding({ left: 20, right: 20, top: 10, bottom: 10 })
      .onClick(() => {
        if (this.onButtonClick) {
          this.onButtonClick()
        }
      })
  }
}

// 预览组件
@Preview
@Component
struct MyButtonPreview {
  build() {
    Column({ space: 20 }) {
      // 默认按钮
      MyButton()
      
      // 主要按钮
      MyButton({
        buttonText: '主要按钮',
        bgColor: '#3698a0'
      })
      
      // 次要按钮
      MyButton({
        buttonText: '次要按钮',
        bgColor: '#82d4db'
      })
      
      // 危险按钮
      MyButton({
        buttonText: '危险按钮',
        bgColor: '#C74533'
      })
      
      // 成功按钮
      MyButton({
        buttonText: '成功按钮',
        bgColor: '#52C41A'
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding(20)
  }
}
