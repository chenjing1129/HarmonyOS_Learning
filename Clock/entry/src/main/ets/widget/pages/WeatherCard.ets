/**
 * 天气卡片UI页面
 * 展示城市天气信息
 */
import { weatherProvider } from '../../providers/WeatherProvider';

const TAG: string = 'WeatherCard';
const DOMAIN: number = 0x0003;

let storage = new LocalStorage();

@Entry(storage)
@Component
struct WeatherCard {
  // 卡片数据
  @LocalStorageProp('city') city: string = '北京';
  @LocalStorageProp('temperature') temperature: number = 25;
  @LocalStorageProp('weather') weather: string = '晴天';
  @LocalStorageProp('weatherCode') weatherCode: string = 'sunny';
  @LocalStorageProp('humidity') humidity: number = 60;
  @LocalStorageProp('windSpeed') windSpeed: number = 10;
  @LocalStorageProp('timestamp') timestamp: number = 0;
  @LocalStorageProp('lastUpdate') lastUpdate: string = '刚刚更新';
  
  // 卡片尺寸
  @State cardWidth: number = 2;
  @State cardHeight: number = 2;

  aboutToAppear(): void {
    // 卡片中不支持hilog，使用console.log替代
    console.log(`[${TAG}] 天气卡片初始化完成，当前城市: ${this.city}，天气: ${this.weather}，温度: ${this.temperature}°C`);
    
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

  // 获取天气图标
  getWeatherIcon(code: string): string {
    return weatherProvider.getWeatherIcon(code);
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
      .justifyContent(FlexAlign.Start)
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
        // 卡片中不支持hilog，使用console.log替代
        console.log(`[${TAG}] 用户点击天气卡片，当前城市: ${this.city}，准备跳转到应用`);
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
      // 城市和更新时间
      Column({ space: 2 }) {
        Text(this.city)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.lastUpdate)
          .fontSize(8)
          .fontColor($r('app.color.text_tertiary'))
          .textAlign(TextAlign.Center)
          .maxLines(1)
      }
      .width('100%')

      // 天气图标和温度
      Column({ space: 4 }) {
        Text(this.getWeatherIcon(this.weatherCode))
          .fontSize(28)
          .width(36)
          .height(36)
          .textAlign(TextAlign.Center)

        Text(`${this.temperature}°`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
          .maxLines(1)

        Text(this.weather)
          .fontSize(10)
          .fontColor($r('app.color.text_secondary'))
          .textAlign(TextAlign.Center)
          .maxLines(1)
      }
      .width('100%')

      // 详细信息
      Row({ space: 12 }) {
        // 湿度
        Column({ space: 1 }) {
          Text('💧')
            .fontSize(12)
          Text(`${this.humidity}%`)
            .fontSize(10)
            .fontColor($r('app.color.text_secondary'))
        }
        .alignItems(HorizontalAlign.Center)

        // 风速
        Column({ space: 1 }) {
          Text('💨')
            .fontSize(12)
          Text(`${this.windSpeed}km/h`)
            .fontSize(10)
            .fontColor($r('app.color.text_secondary'))
        }
        .alignItems(HorizontalAlign.Center)
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
      // 天气图标和温度
      Row({ space: 6 }) {
        Text(this.getWeatherIcon(this.weatherCode))
          .fontSize(26)
          .width(32)
          .height(32)
          .textAlign(TextAlign.Center)

        Column({ space: 1 }) {
          Text(`${this.temperature}°`)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .maxLines(1)

          Text(this.weather)
            .fontSize(10)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .layoutWeight(1)

      // 城市和详细信息
      Column({ space: 2 }) {
        Text(this.city)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.End)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row({ space: 6 }) {
          // 湿度
          Row({ space: 1 }) {
            Text('💧')
              .fontSize(10)
            Text(`${this.humidity}%`)
              .fontSize(8)
              .fontColor($r('app.color.text_secondary'))
          }
          .alignItems(VerticalAlign.Center)

          // 风速
          Row({ space: 1 }) {
            Text('💨')
              .fontSize(10)
            Text(`${this.windSpeed}km/h`)
              .fontSize(8)
              .fontColor($r('app.color.text_secondary'))
          }
          .alignItems(VerticalAlign.Center)
        }
        .justifyContent(FlexAlign.End)

        Text(this.lastUpdate)
          .fontSize(7)
          .fontColor($r('app.color.text_tertiary'))
          .textAlign(TextAlign.End)
          .maxLines(1)
      }
      .constraintSize({ maxWidth: '50%' })
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
      // 城市和更新时间
      Row() {
        Column({ space: 2 }) {
          Text(this.city)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.lastUpdate)
            .fontSize(11)
            .fontColor($r('app.color.text_tertiary'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 刷新按钮
        Button({ type: ButtonType.Circle }) {
          Text('🔄')
            .fontSize(16)
        }
        .width(32)
        .height(32)
        .backgroundColor($r('app.color.card_background'))
        .onClick(() => {
          // 点击刷新按钮
          // 卡片中不支持hilog，使用console.log替代
          console.log(`[${TAG}] 用户点击天气卡片刷新按钮，当前城市: ${this.city}`);
          postCardAction(this, {
            action: 'refresh',
            params: {
              'refresh': 'true'
            }
          });
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 天气图标和温度
      Column({ space: 10 }) {
        Text(this.getWeatherIcon(this.weatherCode))
          .fontSize(56)
          .width(72)
          .height(72)
          .textAlign(TextAlign.Center)

        Text(`${this.temperature}°`)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(1)

        Text(this.weather)
          .fontSize(16)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(1)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      // 详细信息
      Row({ space: 20 }) {
        // 湿度
        Column({ space: 4 }) {
          Text('💧')
            .fontSize(20)
          Text(`${this.humidity}%`)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text('湿度')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        // 风速
        Column({ space: 4 }) {
          Text('💨')
            .fontSize(20)
          Text(`${this.windSpeed}km/h`)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text('风速')
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        Blank()

        // 时间戳（用于验证更新，自适应屏幕）
        Text(`时间戳: ${this.timestamp}`)
          .fontSize(10)
          .fontColor($r('app.color.text_tertiary'))
          .maxFontSize(12)
          .minFontSize(8)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 横向大长条布局 (4*2)
  @Builder buildHorizontalLargeLayout() {
    Row({ space: 16 }) {
      // 左侧：城市和更新时间
      Column({ space: 6 }) {
        Text(this.city)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.lastUpdate)
          .fontSize(11)
          .fontColor($r('app.color.text_tertiary'))
          .textAlign(TextAlign.Start)
          .maxLines(1)

        // 刷新按钮
        Button({ type: ButtonType.Circle }) {
          Text('🔄')
            .fontSize(14)
        }
        .width(30)
        .height(30)
        .backgroundColor($r('app.color.card_background'))
        .onClick(() => {
          // 点击刷新按钮
          // 卡片中不支持hilog，使用console.log替代
          console.log(`[${TAG}] 用户点击天气卡片刷新按钮，当前城市: ${this.city}`);
          postCardAction(this, {
            action: 'refresh',
            params: {
              'refresh': 'true'
            }
          });
        })
      }
      .constraintSize({ maxWidth: '25%' })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      // 中间：天气图标和温度
      Row({ space: 12 }) {
        Text(this.getWeatherIcon(this.weatherCode))
          .fontSize(48)
          .width(60)
          .height(60)
          .textAlign(TextAlign.Center)

        Column({ space: 4 }) {
          Text(`${this.temperature}°`)
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .maxLines(1)

          Text(this.weather)
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .layoutWeight(1)
      .alignItems(VerticalAlign.Center)

      // 右侧：详细信息
      Column({ space: 12 }) {
        // 湿度
        Column({ space: 4 }) {
          Text('💧')
            .fontSize(16)
          Text(`${this.humidity}%`)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
          Text('湿度')
            .fontSize(11)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        // 风速
        Column({ space: 4 }) {
          Text('💨')
            .fontSize(16)
          Text(`${this.windSpeed}km/h`)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
          Text('风速')
            .fontSize(11)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        // 时间戳
        Text(`时间戳: ${this.timestamp}`)
          .fontSize(8)
          .fontColor($r('app.color.text_tertiary'))
          .maxFontSize(10)
          .minFontSize(7)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .constraintSize({ maxWidth: '30%' })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }

  // 正方形布局 (2*2, 4*4)
  @Builder buildSquareLayout() {
    Column({ space: 8 }) {
      // 城市和更新时间
      Row() {
        Column({ space: 2 }) {
          Text(this.city)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.lastUpdate)
            .fontSize(9)
            .fontColor($r('app.color.text_tertiary'))
            .textAlign(TextAlign.Start)
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 刷新按钮
        Button({ type: ButtonType.Circle }) {
          Text('🔄')
            .fontSize(14)
        }
        .width(28)
        .height(28)
        .backgroundColor($r('app.color.card_background'))
        .onClick(() => {
          // 点击刷新按钮
          // 卡片中不支持hilog，使用console.log替代
          console.log(`[${TAG}] 用户点击天气卡片刷新按钮，当前城市: ${this.city}`);
          postCardAction(this, {
            action: 'refresh',
            params: {
              'refresh': 'true'
            }
          });
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      // 天气图标和温度
      Row({ space: 12 }) {
        // 天气图标
        Text(this.getWeatherIcon(this.weatherCode))
          .fontSize(40)
          .width(52)
          .height(52)
          .textAlign(TextAlign.Center)

        // 温度
        Column({ space: 2 }) {
          Text(`${this.temperature}°`)
            .fontSize(36)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .maxLines(1)

          Text(this.weather)
            .fontSize(13)
            .fontColor($r('app.color.text_secondary'))
            .maxLines(1)
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .layoutWeight(1)

      // 详细信息
      Row({ space: 16 }) {
        // 湿度
        Column({ space: 3 }) {
          Text('💧')
            .fontSize(16)
          Text(`${this.humidity}%`)
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
          Text('湿度')
            .fontSize(10)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        // 风速
        Column({ space: 3 }) {
          Text('💨')
            .fontSize(16)
          Text(`${this.windSpeed}km/h`)
            .fontSize(12)
            .fontColor($r('app.color.text_secondary'))
          Text('风速')
            .fontSize(10)
            .fontColor($r('app.color.text_tertiary'))
        }
        .alignItems(HorizontalAlign.Center)

        Blank()

        // 时间戳（用于验证更新，自适应屏幕）
        Text(`时间戳: ${this.timestamp}`)
          .fontSize(8)
          .fontColor($r('app.color.text_tertiary'))
          .maxFontSize(10)
          .minFontSize(7)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceEvenly)
  }
}