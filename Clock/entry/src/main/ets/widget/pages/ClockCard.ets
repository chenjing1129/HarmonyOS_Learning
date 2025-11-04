/**
 * 时钟卡片UI页面
 * 展示当前日期和时间
 */
// import { hilog } from '@kit.PerformanceAnalysisKit'; // 卡片中不支持hilog

const TAG: string = 'ClockCard';
const DOMAIN: number = 0x0002;

// 创建LocalStorage实例
let storage = new LocalStorage();

@Entry(storage)
@Component
struct ClockCard {
  // 卡片数据
  @LocalStorageProp('year') year: string = '2025';
  @LocalStorageProp('month') month: string = '10';
  @LocalStorageProp('day') day: string = '14';
  @LocalStorageProp('weekday') weekday: string = '周二';
  @LocalStorageProp('hour') hour: string = '15';
  @LocalStorageProp('minute') minute: string = '37';
  @LocalStorageProp('second') second: string = '51';
  @LocalStorageProp('timestamp') timestamp: number = 0;
  
  // 卡片尺寸
  @State cardWidth: number = 2;
  @State cardHeight: number = 2;

  aboutToAppear(): void {
    // 卡片中不支持hilog，使用console.log替代
    console.log(`[${TAG}] 时钟卡片初始化完成，当前时间: ${this.year}-${this.month}-${this.day} ${this.hour}:${this.minute}:${this.second}`);
    
    // 获取卡片尺寸信息
    this.getCardDimensions();
  }

  // 获取卡片尺寸
  getCardDimensions(): void {
    try {
      // 卡片应用不支持getUIContext()，使用默认尺寸2*2
      this.cardWidth = 2;
      this.cardHeight = 2;
      console.log(`[${TAG}] 使用默认卡片尺寸: ${this.cardWidth}*${this.cardHeight}`);
    } catch (error) {
      console.error(`[${TAG}] 获取卡片尺寸失败`);
    }
  }

  // 根据卡片尺寸判断布局类型
  getLayoutType(): string {
    if (this.cardWidth === 1 && this.cardHeight === 2) {
      return 'vertical'; // 竖向长条形
    } else if (this.cardWidth === 2 && this.cardHeight === 1) {
      return 'horizontal'; // 横向长条形
    } else if (this.cardWidth === 2 && this.cardHeight === 4) {
      return 'verticalLarge'; // 竖向大长条
    } else if (this.cardWidth === 4 && this.cardHeight === 2) {
      return 'horizontalLarge'; // 横向大长条
    } else {
      return 'square'; // 正方形 (2*2, 4*4)
    }
  }

  build() {
    Stack() {
      // 主要内容区域
      Column({ space: 8 }) {
        if (this.getLayoutType() === 'vertical') {
          // 竖向长条形布局 (1*2)
          this.buildVerticalLayout();
        } else if (this.getLayoutType() === 'horizontal') {
          // 横向长条形布局 (2*1)
          this.buildHorizontalLayout();
        } else if (this.getLayoutType() === 'verticalLarge') {
          // 竖向大长条布局 (2*4)
          this.buildVerticalLargeLayout();
        } else if (this.getLayoutType() === 'horizontalLarge') {
          // 横向大长条布局 (4*2)
          this.buildHorizontalLargeLayout();
        } else {
          // 正方形布局 (2*2, 4*4)
          this.buildSquareLayout();
        }
      }
      .width('100%')
      .height('100%')
      .padding(12)
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(12)
      .shadow({
        radius: 6,
        color: $r('app.color.shadow'),
        offsetX: 0,
        offsetY: 2
      })
      .onClick(() => {
        // 点击卡片跳转到应用
        console.log(`[${TAG}] 用户点击时钟卡片，准备跳转到应用`);
        postCardAction(this, {
          action: 'router',
          abilityName: 'EntryAbility',
          params: {
            page: 'pages/Index'
          }
        });
      })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.BottomEnd)
    .padding({ right: 12, bottom: 8 })
  }

  // 竖向长条形布局 (1*2)
  @Builder buildVerticalLayout() {
    Column({ space: 6 }) {
      // 时间部分
      Text(`${this.hour}:${this.minute}:${this.second}`)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_blue'))
        .maxFontSize(22)
        .minFontSize(14)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip })
      
      // 日期部分
      Text(`${this.year}-${this.month}-${this.day}`)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .maxFontSize(14)
        .minFontSize(10)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      
      Text(this.weekday)
        .fontSize(11)
        .fontColor($r('app.color.text_secondary'))
        .maxFontSize(12)
        .minFontSize(9)
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 横向长条形布局 (2*1)
  @Builder buildHorizontalLayout() {
    Row({ space: 8 }) {
      // 时间部分
      Text(`${this.hour}:${this.minute}:${this.second}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_blue'))
        .maxFontSize(24)
        .minFontSize(16)
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip })
      
      // 日期部分
      Column({ space: 2 }) {
        Text(`${this.year}-${this.month}-${this.day}`)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxFontSize(13)
          .minFontSize(9)
          .textAlign(TextAlign.End)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Text(this.weekday)
          .fontSize(10)
          .fontColor($r('app.color.text_secondary'))
          .maxFontSize(12)
          .minFontSize(8)
          .textAlign(TextAlign.End)
          .maxLines(1)
      }
      .constraintSize({ maxWidth: '40%' })
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 竖向大长条布局 (2*4)
  @Builder buildVerticalLargeLayout() {
    Column({ space: 12 }) {
      // 日期部分
      Column({ space: 4 }) {
        Text(`${this.year}-${this.month}-${this.day}`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxFontSize(22)
          .minFontSize(16)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.weekday)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .maxFontSize(16)
          .minFontSize(12)
          .maxLines(1)
      }
      .width('100%')

      // 时间部分
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(this.hour)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(32)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Text(':')
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(32)
          .margin({ left: 1, right: 1 })

        Text(this.minute)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(32)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Text(':')
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(32)
          .margin({ left: 1, right: 1 })

        Text(this.second)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(32)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)
      .constraintSize({ minHeight: 100, maxHeight: 180 })

      // 时间戳
      Text(`时间戳: ${this.timestamp}`)
        .fontSize(10)
        .fontColor($r('app.color.text_tertiary'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .maxFontSize(12)
        .minFontSize(8)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 横向大长条布局 (4*2)
  @Builder buildHorizontalLargeLayout() {
    Row({ space: 16 }) {
      // 时间部分
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text(this.hour)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(52)
          .minFontSize(28)

        Text(':')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(52)
          .minFontSize(28)
          .margin({ left: 1, right: 1 })

        Text(this.minute)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(52)
          .minFontSize(28)

        Text(':')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(52)
          .minFontSize(28)
          .margin({ left: 1, right: 1 })

        Text(this.second)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(52)
          .minFontSize(28)
      }
      .layoutWeight(1)

      // 日期部分
      Column({ space: 6 }) {
        Text(`${this.year}-${this.month}-${this.day}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxFontSize(20)
          .minFontSize(14)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.weekday)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .maxFontSize(16)
          .minFontSize(12)
          .maxLines(1)

        Text(`时间戳: ${this.timestamp}`)
          .fontSize(9)
          .fontColor($r('app.color.text_tertiary'))
          .maxFontSize(11)
          .minFontSize(7)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .constraintSize({ maxWidth: '35%' })
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 正方形布局 (2*2, 4*4)
  @Builder buildSquareLayout() {
    Column({ space: 8 }) {
      // 日期部分
      Column({ space: 3 }) {
        Text(`${this.year}-${this.month}-${this.day}`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))
          .maxFontSize(20)
          .minFontSize(14)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.weekday)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
          .maxFontSize(15)
          .minFontSize(11)
          .maxLines(1)
      }
      .width('100%')

      // 时间部分（大字体显示，自适应屏幕）
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text(this.hour)
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(24)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Text(':')
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(24)
          .margin({ left: 1, right: 1 })

        Text(this.minute)
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(24)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Text(':')
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(24)
          .margin({ left: 1, right: 1 })

        Text(this.second)
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(64)
          .minFontSize(24)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)
      .constraintSize({ minHeight: 80, maxHeight: 160 })

      // 时间戳（用于验证更新，自适应屏幕）
      Text(`时间戳: ${this.timestamp}`)
        .fontSize(9)
        .fontColor($r('app.color.text_tertiary'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .maxFontSize(11)
        .minFontSize(7)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}
