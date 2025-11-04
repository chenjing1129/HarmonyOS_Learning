/**
 * 自定义弹窗组件
 */
@Component
export struct CustomDialog {
  controller?: CustomDialogController
  title: string = '提示'
  content: string = ''
  confirmText: string = '确定'
  cancelText: string = '取消'
  showCancel: boolean = false
  onConfirm?: () => void
  onCancel?: () => void
  onClose?: () => void

  build() {
    Column({ space: 20 }) {
      // 标题
      Text(this.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Center)

      // 内容
      Text(this.content)
        .fontSize(15)
        .fontColor('#666666')
        .width('100%')
        .lineHeight(24)

      // 按钮区域
      Row({ space: 12 }) {
        if (this.showCancel) {
          Button(this.cancelText)
            .fontSize(16)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .layoutWeight(1)
            .height(44)
            .onClick(() => {
              if (this.onCancel) {
                this.onCancel()
              }
              if (this.onClose) {
                this.onClose()
              }
              if (this.controller) {
                this.controller.close()
              }
            })
        }

        Button(this.confirmText)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#007DFF')
          .borderRadius(8)
          .layoutWeight(1)
          .height(44)
          .onClick(() => {
            if (this.onConfirm) {
              this.onConfirm()
            }
            if (this.onClose) {
              this.onClose()
            }
            if (this.controller) {
              this.controller.close()
            }
          })
      }
      .width('100%')
    }
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }
}

