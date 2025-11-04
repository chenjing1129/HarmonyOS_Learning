import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Title()
      Button('玩安卓API示例')
        .width(200)
        .margin(10)
        .backgroundColor('#1976D2')
        .onClick(() => {
          router.pushUrl({ url: 'pages/WanAndroidPage' });
        })
      Button('Text 组件')
        .width(200)
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/TextExamplePage' });
        })
      Button('Image 组件')
        .width(200)
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/ImageExamplePage' });
        })
      Button('Button 组件')
        .width(200)
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/ButtonExamplePage' });
        })
      Button('TextInput 组件')
        .width(200)
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/TextInputExamplePage' });
        })
      Button('List 组件')
        .width(200)
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/ListExamplePage' });
        })
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}

@Component
struct Title {
  build() {
    Text('基础组件示例')
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 20 })
  }
}