@Entry
@Component
struct ExplictAnimationPage {
  @State isMoved: boolean = false
  @State heartScale: number = 1.0
  @State rotateAngle: number = 0
  private heartBeatTimer: number = -1

  aboutToAppear() {
    // 启动心跳定时器，每800ms触发一次状态变化
    this.heartBeatTimer = setInterval(() => {
      this.heartScale = this.heartScale === 1.0 ? 1.2 : 1.0
      this.rotateAngle = this.rotateAngle + 90 // 每次旋转90度
    }, 800)
  }

  aboutToDisappear() {
    // 清理定时器，避免内存泄漏
    if (this.heartBeatTimer !== -1) {
      clearInterval(this.heartBeatTimer)
    }
  }

  build() {
    Navigation() {
      Column({ space: 30 }) {
        Text('显式动画演示')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Button('改变位置').onClick(() => {
          this.isMoved = !this.isMoved
        })

        Circle({ width: 60, height: 60})
          .fill("#ff4fa9a3")
          .translate({ x: this.isMoved ? 200 : 0, y: 0})
          .animation({
            duration: 1000,
            curve: Curve.Smooth
          })

        Rect({ width: 80, height: 50 })
          .fill(this.isMoved ? Color.Red : Color.Blue)
          .translate({ x: this.isMoved ? 100 : 0, y: 0 })
          .animation({
            duration: 800,
            curve: Curve.EaseInOut
          })
        
        Button('角度变化')
          .rotate({ angle: this.rotateAngle })
          .animation({
            duration: 600,
            curve: Curve.Friction,
            iterations: -1,
            playMode: PlayMode.Normal,
            expectedFrameRateRange: {
              expected: 60,
              min: 30,
              max: 120
            }
          })

        // 美化的心脏图案
        Text('💖')
          .fontSize(50)
          .margin({ top: 20 })
          .scale({ x: this.heartScale, y: this.heartScale })
          .animation({
            duration: 600,
            curve: Curve.Friction,
            iterations: -1,
            playMode: PlayMode.Alternate,
            delay: 100,
            expectedFrameRateRange: {
              expected: 60,
              min: 30,
              max: 120
            }
          })
      }
      .alignItems(HorizontalAlign.Center)
      .padding(16)
    }
    .title('显式动画')
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(false)
    .navBarWidth('100%')
    .navBarPosition(NavBarPosition.Start)
  }
}