/**
 * 计数器卡片UI页面
 * 展示当前计数器值和操作按钮
 */
// import { hilog } from '@kit.PerformanceAnalysisKit'; // 卡片中不支持hilog
// postCardAction 是全局可用的函数，不需要显式导入

const COUNTER_TAG: string = 'CounterCard';
const COUNTER_DOMAIN: number = 0x0006;

// 创建LocalStorage实例
let counterStorage = new LocalStorage();

@Entry(counterStorage)
@Component
struct CounterCard {
  // 卡片数据
  @LocalStorageProp('value') value: number = 0;
  @LocalStorageProp('lastUpdateTime') lastUpdateTime: number = 0;
  @LocalStorageProp('lastUpdateSource') lastUpdateSource: string = '';
  @LocalStorageProp('lastUpdateTimeString') lastUpdateTimeString: string = '';
  
  // 卡片尺寸
  @State cardWidth: number = 2;
  @State cardHeight: number = 2;

  aboutToAppear(): void {
    // 卡片中不支持hilog，使用console.log替代
    console.log(`[${COUNTER_TAG}] 计数器卡片初始化完成，当前值: ${this.value}`);
    
    // 获取卡片尺寸信息
    this.getCardDimensions();
    
    // 监听数据变化
    counterStorage.set('listenDataChange', (key: string) => {
      if (key === 'value' || key === 'lastUpdateTime' || key === 'lastUpdateSource') {
        this.value = counterStorage.get('value') || 0;
        this.lastUpdateTime = counterStorage.get('lastUpdateTime') || 0;
        this.lastUpdateSource = counterStorage.get('lastUpdateSource') || '';
      }
    });
  }

  // 获取卡片尺寸
  getCardDimensions(): void {
    try {
      // 卡片应用不支持getUIContext()，使用默认尺寸2*2
      this.cardWidth = 2;
      this.cardHeight = 2;
      console.log(`[${COUNTER_TAG}] 使用默认卡片尺寸: ${this.cardWidth}*${this.cardHeight}`);
    } catch (error) {
      console.error(`[${COUNTER_TAG}] 获取卡片尺寸失败`);
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

  // 发送卡片事件
  sendCardEvent(event: string): void {
    console.log(`[${COUNTER_TAG}] 发送卡片事件: ${event}`);
    try {
      postCardAction(this, {
        'action': 'message',
        'params': {
          'message': event
        }
      });
    } catch (error) {
      console.error(`[${COUNTER_TAG}] 发送卡片事件失败: ${error}`);
    }
  }

  build() {
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
      console.log(`[${COUNTER_TAG}] 用户点击计数器卡片，准备跳转到应用`);
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
        params: {
          page: 'pages/Index'
        }
      });
    })
  }

  // 竖向长条形布局 (1*2)
  @Builder buildVerticalLayout() {
    Column({ space: 6 }) {
      // 标题
      Text('计数器')
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      
      // 计数器值
      Text(`${this.value}`)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_blue'))
        .maxFontSize(32)
        .minFontSize(20)
        .width('100%')
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip })
      
      // 操作按钮
      Row({ space: 4 }) {
        Button({ type: ButtonType.Circle }) {
          Text('-')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(28)
          .height(28)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('decrement');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('↻')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(28)
          .height(28)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('reset');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('+')
            .fontSize(14)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(28)
          .height(28)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('increment');
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 横向长条形布局 (2*1)
  @Builder buildHorizontalLayout() {
    Row({ space: 8 }) {
      // 标题和计数器值
      Column({ space: 2 }) {
        Text('计数器')
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Start)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        
        Text(`${this.value}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(24)
          .minFontSize(16)
          .textAlign(TextAlign.Start)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Clip })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      
      // 操作按钮
      Row({ space: 4 }) {
        Button('-')
          .width(24)
          .height(24)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('decrement');
          })
        
        Button('↻')
          .width(24)
          .height(24)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('reset');
          })
        
        Button('+')
          .width(24)
          .height(24)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('increment');
          })
      }
      .constraintSize({ maxWidth: '50%' })
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 竖向大长条布局 (2*4)
  @Builder buildVerticalLargeLayout() {
    Column({ space: 12 }) {
      // 标题
      Text('计数器')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .textAlign(TextAlign.Center)
        .width('100%')
        .maxLines(1)
      
      // 计数器值
      Text(`${this.value}`)
        .fontSize(56)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_blue'))
        .maxFontSize(64)
        .minFontSize(40)
        .textAlign(TextAlign.Center)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip })
        .layoutWeight(1)
      
      // 操作按钮
      Row({ space: 12 }) {
        Button({ type: ButtonType.Circle }) {
          Text('-')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('decrement');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('↻')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('reset');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('+')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('increment');
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 横向大长条布局 (4*2)
  @Builder buildHorizontalLargeLayout() {
    Row({ space: 16 }) {
      // 左侧：标题和计数器值
      Column({ space: 8 }) {
        Text('计数器')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Start)
          .width('100%')
          .maxLines(1)
        
        Text(`${this.value}`)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.primary_blue'))
          .maxFontSize(48)
          .minFontSize(32)
          .textAlign(TextAlign.Start)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Clip })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      
      // 右侧：操作按钮
      Row({ space: 12 }) {
        Button({ type: ButtonType.Circle }) {
          Text('-')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('decrement');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('↻')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('reset');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('+')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(44)
          .height(44)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('increment');
          })
      }
      .constraintSize({ maxWidth: '60%' })
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 正方形布局 (2*2, 4*4)
  @Builder buildSquareLayout() {
    Column({ space: 10 }) {
      // 标题
      Text('计数器')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_primary'))
        .width('100%')
        .maxLines(1)
      
      // 计数器值
      Text(`${this.value}`)
        .fontSize(56)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary_blue'))
        .maxFontSize(72)
        .minFontSize(36)
        .width('100%')
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip })
        .layoutWeight(1)
      
      // 操作按钮
      Row({ space: 10 }) {
        Button({ type: ButtonType.Circle }) {
          Text('-')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(52)
          .height(52)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('decrement');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('↻')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(52)
          .height(52)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('reset');
          })
        
        Button({ type: ButtonType.Circle }) {
          Text('+')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
          .width(52)
          .height(52)
          .backgroundColor($r('app.color.button_background'))
          .onClick(() => {
            this.sendCardEvent('increment');
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}