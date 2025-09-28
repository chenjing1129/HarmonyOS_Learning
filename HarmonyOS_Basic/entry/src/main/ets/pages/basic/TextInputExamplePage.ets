// entry/src/main/ets/pages/TextInputExamplePage.ets
@Entry
@Component
struct TextInputExamplePage {
  @State inputText: string = ''

  build() {
    Column({ space: 20 }) {
      // 基本用法
      TextInput({ placeholder: '请输入内容' })
        .onChange((value) => {
          this.inputText = value
        })
        .height(50)
        .width('80%')
        .fontSize(20)
        .border({ width: 1, color: Color.Gray, radius: 10 })
        .padding({ left: 10, right: 10 })


      Text(`您输入的内容是: ${this.inputText}`)
        .fontSize(20)

      // 密码输入框
      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .height(50)
        .width('80%')
        .fontSize(20)
        .border({ width: 1, color: Color.Gray, radius: 10 })
        .padding({ left: 10, right: 10 })

    }.width('100%').height('100%').padding(20).justifyContent(FlexAlign.Center)
  }
} 