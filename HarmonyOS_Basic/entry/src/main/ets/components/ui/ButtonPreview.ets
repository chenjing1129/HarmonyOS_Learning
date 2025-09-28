/**
 * ButtonPreview.ets
 * 简要描述：可预览按钮组件
 * 作者：cj
 * 日期：2025/9/11
 */
// 类似Vite的HMR热更新预览
@Preview
@Component
struct ButtonPreview {
  build() {
    Column({ space: 10 }) {
      Button('主要按钮')
        .type(ButtonType.Normal)
        .backgroundColor('#007AFF')

      Button('次要按钮')
        .type(ButtonType.Normal)
        .backgroundColor('#34C759')

      Button('危险按钮')
        .type(ButtonType.Normal)
        .backgroundColor('#FF3B30')
    }
    .padding(20)
  }
}