import { hilog } from '@kit.PerformanceAnalysisKit';
import { timeProvider } from '../providers/TimeProvider';
import type { TimeData } from '../providers/TimeProvider';
import { weatherProvider } from '../providers/WeatherProvider';
import type { WeatherData } from '../providers/WeatherProvider';
import { counterProvider } from '../providers/CounterProvider';
import type { CounterData } from '../providers/CounterProvider';

// 定义SelectOption类型
interface SelectOption {
  value: string;
  icon?: string;
  selectedIcon?: Resource;
}

const TAG: string = 'Index';
const DOMAIN: number = 0x0001;

/**
 * 时钟天气卡片应用主页面
 */
@Entry
@Component
struct Index {
  @State currentTime: TimeData | null = null;
  @State currentWeather: WeatherData | null = null;
  @State counterData: CounterData | null = null;
  @State selectedCity: string = '北京';
  @State cities: string[] = [];
  @State activeTab: number = 0; // 0: 时钟, 1: 天气, 2: 计数器
  private timer: number = -1; // 定时器ID

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, 'aboutToAppear');
    this.cities = weatherProvider.getCities();
    
    // 初始化计数器提供者
    try {
      const context = this.getUIContext().getHostContext();
      if (context) {
        counterProvider.initialize(context).then(() => {
          hilog.info(DOMAIN, TAG, '计数器提供者初始化完成');
          this.updateTime();
          this.updateWeather();
          this.updateCounter();
          
          // 设置定时器，每5秒更新一次
          this.timer = setInterval(() => {
            this.updateTime();
            this.updateWeather();
            this.updateCounter();
            hilog.info(DOMAIN, TAG, '定时器触发: 时间、天气和计数器已更新');
          }, 5000);
        }).catch((error: Error) => {
          hilog.error(DOMAIN, TAG, `计数器提供者初始化失败: ${error.message}`);
          // 即使初始化失败，也要更新时间和天气
          this.updateTime();
          this.updateWeather();
          
          // 设置定时器，每5秒更新一次
          this.timer = setInterval(() => {
            this.updateTime();
            this.updateWeather();
            hilog.info(DOMAIN, TAG, '定时器触发: 时间和天气已更新');
          }, 5000);
        });
      } else {
        hilog.error(DOMAIN, TAG, '无法获取上下文');
        // 即使获取上下文失败，也要更新时间和天气
        this.updateTime();
        this.updateWeather();
        
        // 设置定时器，每5秒更新一次
        this.timer = setInterval(() => {
          this.updateTime();
          this.updateWeather();
          hilog.info(DOMAIN, TAG, '定时器触发: 时间和天气已更新');
        }, 5000);
      }
    } catch (error) {
      hilog.error(DOMAIN, TAG, `获取上下文异常: ${error}`);
      // 即使获取上下文失败，也要更新时间和天气
      this.updateTime();
      this.updateWeather();
      
      // 设置定时器，每5秒更新一次
      this.timer = setInterval(() => {
        this.updateTime();
        this.updateWeather();
        hilog.info(DOMAIN, TAG, '定时器触发: 时间和天气已更新');
      }, 5000);
    }
  }

  aboutToDisappear(): void {
    // 清除定时器
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
      hilog.info(DOMAIN, TAG, '定时器已清除');
    }
  }

  /**
   * 更新时间
   */
  updateTime(): void {
    this.currentTime = timeProvider.getCurrentTime();
    hilog.info(DOMAIN, TAG, `时间更新: ${this.currentTime.hour}:${this.currentTime.minute}:${this.currentTime.second}`);
  }

  /**
   * 更新天气
   */
  updateWeather(): void {
    this.currentWeather = weatherProvider.getWeatherByCity(this.selectedCity);
    hilog.info(DOMAIN, TAG,
      `天气更新: ${this.currentWeather.city} ${this.currentWeather.temperature}°C ${this.currentWeather.weather}`);
  }

  /**
   * 更新计数器
   */
  updateCounter(): void {
    this.counterData = counterProvider.getCounterData();
    hilog.info(DOMAIN, TAG, `计数器更新: ${this.counterData.value}, 来源: ${this.counterData.lastUpdateSource}`);
  }

  /**
   * 刷新计数器数据
   */
  refreshCounter(): void {
    this.updateCounter();
    // 触发UI更新
    if (this.activeTab === 2) {
      // 如果当前在计数器标签页，强制刷新UI
      this.activeTab = 1;
      setTimeout(() => {
        this.activeTab = 2;
      }, 100);
    }
  }

  build() {
    Column({ space: 20 }) {
      // 标题
      Row() {
        Text('时钟天气卡片示例')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Blank()

        Button('刷新')
          .fontSize(14)
          .height(32)
          .onClick(() => {
            hilog.info(DOMAIN, TAG, `用户点击刷新按钮，当前标签页: ${this.activeTab === 0 ? '时钟' : this.activeTab === 1 ? '天气' : '计数器'}`);
            if (this.activeTab === 0) {
              this.updateTime();
            } else if (this.activeTab === 1) {
              this.updateWeather();
            } else {
              this.updateCounter();
            }
          })
      }
      .width('90%')
      .padding({ top: 20 })

      // 选项卡
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          this.clockTabContent()
        }
        .tabBar('时钟卡片')
        .backgroundColor($r('app.color.page_background'))

        TabContent() {
          this.weatherTabContent()
        }
        .tabBar('天气卡片')
        .backgroundColor($r('app.color.page_background'))

        TabContent() {
          this.counterTabContent()
        }
        .tabBar('计数器卡片')
        .backgroundColor($r('app.color.page_background'))
      }
      .barHeight(48)
      .animationDuration(300)
      .onChange((index: number) => {
        hilog.info(DOMAIN, TAG, `标签页切换: 从 ${this.activeTab === 0 ? '时钟' : this.activeTab === 1 ? '天气' : '计数器'} 切换到 ${index === 0 ? '时钟' : index === 1 ? '天气' : '计数器'}`);
        this.activeTab = index;
      })
      .width('90%')
      .layoutWeight(1)
      .width('90%')
      .padding(16)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(12)
      .shadow({
        radius: 8,
        color: $r('app.color.shadow'),
        offsetX: 0,
        offsetY: 2
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
  }

  @Builder
  clockTabContent() {
    Column({ space: 20 }) {
      // 当前时间显示
      if (this.currentTime) {
        Column({ space: 15 }) {
          Text('当前时间')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .width('100%')

          // 日期
          Text(`${this.currentTime.year}-${this.currentTime.month}-${this.currentTime.day}`)
            .fontSize(18)
            .fontColor($r('app.color.text_primary'))

          Text(this.currentTime.weekday)
            .fontSize(16)
            .fontColor($r('app.color.text_secondary'))

          // 时间（大字体，自适应屏幕）
          Row({ space: 4 }) {
            Text(this.currentTime.hour)
              .fontSize(60)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.primary_blue'))
              .maxFontSize(72)
              .minFontSize(36)

            Text(':')
              .fontSize(60)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.primary_blue'))
              .maxFontSize(72)
              .minFontSize(36)

            Text(this.currentTime.minute)
              .fontSize(60)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.primary_blue'))
              .maxFontSize(72)
              .minFontSize(36)

            Text(':')
              .fontSize(60)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.primary_blue'))
              .maxFontSize(72)
              .minFontSize(36)

            Text(this.currentTime.second)
              .fontSize(60)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.primary_blue'))
              .maxFontSize(72)
              .minFontSize(36)
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })

          // 时间戳（自适应屏幕）
          Text(`时间戳: ${this.currentTime.timestamp}`)
            .fontSize(12)
            .fontColor($r('app.color.text_tertiary'))
            .maxFontSize(14)
            .minFontSize(10)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
        }
        .width('90%')
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
      }
    }
  }

  @Builder
  weatherTabContent() {
    Column({ space: 20 }) {
      // 城市选择
      Row() {
        Text('选择城市:')
          .fontSize(16)
          .fontColor($r('app.color.text_primary'))

        Blank()

        Select(this.cities.map((city: string): SelectOption => {
          return { value: city };
        }))
          .selected(0)
          .value(this.selectedCity)
          .font({ size: 16 })
          .onSelect((index: number, value: string) => {
            hilog.info(DOMAIN, TAG, `城市选择: 从 ${this.selectedCity} 切换到 ${value}`);
            this.selectedCity = value;
            this.updateWeather();
            hilog.info(DOMAIN, TAG, `已加载 ${value} 的天气数据`);
          })
      }
      .width('90%')
      .padding(16)
      .backgroundColor($r('app.color.card_background'))
      .borderRadius(12)
      .shadow({
        radius: 8,
        color: $r('app.color.shadow'),
        offsetX: 0,
        offsetY: 2
      })

      // 当前天气显示
      if (this.currentWeather) {
        Column({ space: 15 }) {
          Text('当前天气')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .width('100%')

          // 城市和天气
          Row({ space: 16 }) {
            Column() {
              Text(this.currentWeather.city)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))

              Text(this.currentWeather.weather)
                .fontSize(16)
                .fontColor($r('app.color.text_secondary'))
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text(weatherProvider.getWeatherIcon(this.currentWeather.weatherCode))
              .fontSize(48)
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)

          // 温度
          Text(`${this.currentWeather.temperature}°C`)
            .fontSize(48)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.primary_blue'))
            .width('100%')
            .textAlign(TextAlign.Center)

          // 详细信息
          Row({ space: 24 }) {
            // 湿度
            Column({ space: 4 }) {
              Text('💧')
                .fontSize(18)
              Text(`${this.currentWeather.humidity}%`)
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
                .fontSize(18)
              Text(`${this.currentWeather.windSpeed}km/h`)
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
              Text('风速')
                .fontSize(12)
                .fontColor($r('app.color.text_tertiary'))
            }
            .alignItems(HorizontalAlign.Center)

            Blank()

            // 时间戳（自适应屏幕）
            Text(`更新时间: ${new Date(this.currentWeather.timestamp).toLocaleTimeString()}`)
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))
              .maxFontSize(14)
              .minFontSize(10)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(1)
          }
          .width('100%')
          .padding({ top: 8 })
        }
        .width('90%')
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
        .width('90%')
        .padding(16)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 2
        })
      }
    }
  }

  @Builder
  counterTabContent() {
    Column({ space: 20 }) {
      // 当前计数器显示
      if (this.counterData) {
        Column({ space: 15 }) {
          Text('计数器')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))
            .width('100%')

          // 计数器值（大字体，自适应屏幕）
          Text(`${this.counterData.value}`)
            .fontSize(72)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.primary_blue'))
            .maxFontSize(96)
            .minFontSize(48)
            .width('100%')
            .textAlign(TextAlign.Center)

          // 操作按钮
            Row({ space: 16 }) {
              Button({ type: ButtonType.Circle }) {
                Text('-')
                  .fontSize(24)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
                .width(64)
                .height(64)
                .backgroundColor($r('app.color.button_background'))
                .onClick(() => {
                  hilog.info(DOMAIN, TAG, '用户点击减少按钮');
                  counterProvider.decrementCounter(1, 'page').then((success) => {
                    if (success) {
                      this.refreshCounter();
                    }
                  });
                })
              
              Button({ type: ButtonType.Circle }) {
                Text('↻')
                  .fontSize(24)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
                .width(64)
                .height(64)
                .backgroundColor($r('app.color.button_background'))
                .onClick(() => {
                  hilog.info(DOMAIN, TAG, '用户点击重置按钮');
                  counterProvider.resetCounter('page').then((success) => {
                    if (success) {
                      this.refreshCounter();
                    }
                  });
                })
              
              Button({ type: ButtonType.Circle }) {
                Text('+')
                  .fontSize(24)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
                .width(64)
                .height(64)
                .backgroundColor($r('app.color.button_background'))
                .onClick(() => {
                  hilog.info(DOMAIN, TAG, '用户点击增加按钮');
                  counterProvider.incrementCounter(1, 'page').then((success) => {
                    if (success) {
                      this.refreshCounter();
                    }
                  });
                })
            }
          .width('100%')
          .justifyContent(FlexAlign.SpaceEvenly)
          .width('100%')
          .padding({ top: 16 })
        }
        .width('90%')
        .padding(20)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius(16)
        .shadow({
          radius: 12,
          color: $r('app.color.shadow'),
          offsetX: 0,
          offsetY: 4
        })
      }
    }
  }
}
