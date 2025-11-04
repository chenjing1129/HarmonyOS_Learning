/**
 * 首页 - 玩安卓内容
 */
import { WanAndroidApi } from '../api/wanAndroidApi'
import { Article, Banner, PageData, HotKey } from '../type/WanAndroidType'
import { ThemeConstants } from '../common/constants/ThemeConstants'

@Component
export struct HomePage {
  @State articles: Article[] = []
  @State banners: Banner[] = []
  @State hotKeys: HotKey[] = []
  @State loading: boolean = false
  @State errorMessage: string = ''
  @State currentPage: number = 0
  @State hasMore: boolean = true
  private isDestroyed: boolean = false

  async aboutToAppear() {
    this.isDestroyed = false
    await this.loadData()
  }

  aboutToDisappear() {
    // 标记组件已销毁,避免异步操作继续执行
    this.isDestroyed = true
    // 清理数据,释放内存
    this.articles = []
    this.banners = []
    this.hotKeys = []
  }

  /**
   * 加载数据
   */
  async loadData() {
    if (this.isDestroyed) return

    this.loading = true
    this.errorMessage = ''

    try {
      console.info('开始加载数据...')

      // 串行加载以减少内存压力
      console.info('开始加载文章数据...')
      const articlesData = await WanAndroidApi.getArticleList(0)
      if (this.isDestroyed) return

      // 处理文章数据
      if (articlesData) {
        this.articles = articlesData.datas.slice(0, 10) // 限制初始加载数量
        this.hasMore = !articlesData.over
        console.info(`成功加载 ${this.articles.length} 篇文章`)
      } else {
        this.errorMessage = '获取文章失败'
        console.error('文章数据错误')
        return
      }

      // 加载Banner数据
      console.info('开始加载Banner数据...')
      const bannersData = await WanAndroidApi.getBanner()
      if (this.isDestroyed) return

      if (bannersData) {
        this.banners = bannersData.slice(0, 3) // 限制Banner数量
        console.info(`成功加载 ${this.banners.length} 个Banner`)
      } else {
        console.warn('Banner加载失败')
      }

      // 加载热词数据
      console.info('开始加载热词数据...')
      const hotKeysData = await WanAndroidApi.getHotKeys()
      if (this.isDestroyed) return

      if (hotKeysData) {
        this.hotKeys = hotKeysData.slice(0, 10) // 限制热词数量
        console.info(`成功加载 ${this.hotKeys.length} 个热词`)
      } else {
        console.warn('热词加载失败')
      }

      console.info('所有数据加载完成')

    } catch (error) {
      if (this.isDestroyed) return
      console.error('Load data error:', error)

      // 根据错误类型提供更具体的错误信息
      if (typeof error === 'string') {
        this.errorMessage = error
      } else {
        this.errorMessage = '网络请求失败,请检查网络连接'
      }
    } finally {
      if (!this.isDestroyed) {
        this.loading = false
      }
    }
  }

  /**
   * 加载更多文章
   */
  async loadMoreArticles() {
    if (this.loading || !this.hasMore || this.isDestroyed) return

    this.loading = true
    try {
      const response = await WanAndroidApi.getArticleList(this.currentPage + 1)
      if (this.isDestroyed) return

      if (response) {
        // 限制总文章数量,避免内存过载
        const newArticles = response.datas.slice(0, 10)
        const totalArticles = [...this.articles, ...newArticles]

        // 如果文章总数超过50,移除最旧的文章
        if (totalArticles.length > 50) {
          this.articles = totalArticles.slice(-50)
        } else {
          this.articles = totalArticles
        }

        this.currentPage++
        this.hasMore = !response.over
      }
    } catch (error) {
      if (this.isDestroyed) return
      console.error('Load more error:', error)
    } finally {
      if (!this.isDestroyed) {
        this.loading = false
      }
    }
  }

  /**
   * 刷新数据
   */
  async refreshData() {
    if (this.isDestroyed) return

    this.currentPage = 0
    this.articles = []
    this.banners = []
    this.hotKeys = []
    await this.loadData()
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('玩安卓')
          .fontSize(ThemeConstants.FONT_SIZE_LG)
          .fontWeight(FontWeight.Bold)
          .fontColor(ThemeConstants.TEXT_WHITE)
      }
      .width('100%')
      .height(ThemeConstants.NAVBAR_HEIGHT)
      .backgroundColor(ThemeConstants.PRIMARY_COLOR)
      .justifyContent(FlexAlign.Center)

      if (this.loading && this.articles.length === 0) {
        // 加载状态
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color(ThemeConstants.PRIMARY_COLOR)
          Text('加载中...')
            .fontSize(ThemeConstants.FONT_SIZE_XS)
            .fontColor(ThemeConstants.TEXT_SECONDARY)
            .margin({ top: 10 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else if (this.errorMessage) {
        // 错误状态
        Column() {
          Text('😞')
            .fontSize(48)
          Text('网络请求失败')
            .fontSize(ThemeConstants.FONT_SIZE_MD)
            .fontWeight(FontWeight.Bold)
            .fontColor(ThemeConstants.TEXT_PRIMARY)
            .margin({ top: 10 })

          Text(this.errorMessage)
            .fontSize(ThemeConstants.FONT_SIZE_XS)
            .fontColor(ThemeConstants.TEXT_SECONDARY)
            .margin({ top: 8 })
            .textAlign(TextAlign.Center)
            .padding({ left: 20, right: 20 })

          Column() {
            Text('可能的解决方案:')
              .fontSize(ThemeConstants.FONT_SIZE_BASE)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 20, bottom: 10 })

            Text('1. 检查设备网络连接')
              .fontSize(ThemeConstants.FONT_SIZE_XS)
              .fontColor(ThemeConstants.TEXT_SECONDARY)
              .margin({ bottom: 5 })
              .alignSelf(ItemAlign.Start)

            Text('2. 确认网络权限已授予')
              .fontSize(ThemeConstants.FONT_SIZE_XS)
              .fontColor(ThemeConstants.TEXT_SECONDARY)
              .margin({ bottom: 5 })
              .alignSelf(ItemAlign.Start)

            Text('3. 尝试切换网络环境')
              .fontSize(ThemeConstants.FONT_SIZE_XS)
              .fontColor(ThemeConstants.TEXT_SECONDARY)
              .margin({ bottom: 5 })
              .alignSelf(ItemAlign.Start)

            Text('4. 检查防火墙设置')
              .fontSize(ThemeConstants.FONT_SIZE_XS)
              .fontColor(ThemeConstants.TEXT_SECONDARY)
              .margin({ bottom: 20 })
              .alignSelf(ItemAlign.Start)
          }
          .padding({ left: 20, right: 20 })

          Button('重试')
            .margin({ top: 10 })
            .backgroundColor(ThemeConstants.PRIMARY_COLOR)
            .onClick(() => this.refreshData())
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 内容区域
        Refresh({ refreshing: this.loading }) {
          List() {
            // Banner区域
            if (this.banners.length > 0) {
              ListItem() {
                this.BannerSection()
              }
            }

            // 热词区域
            if (this.hotKeys.length > 0) {
              ListItem() {
                this.HotKeysSection()
              }
            }

            // 文章列表
            ForEach(this.articles, (article: Article, index: number) => {
              ListItem() {
                this.ArticleItem(article)
              }
              .onClick(() => {
                console.info(`点击文章: ${article.title}`)
                // 这里可以跳转到文章详情页或打开浏览器
              })
            })

            // 加载更多
            if (this.hasMore) {
              ListItem() {
                Row() {
                  if (this.loading) {
                    LoadingProgress()
                      .width(20)
                      .height(20)
                      .margin({ right: 10 })
                  }
                  Text(this.loading ? '加载中...' : '上拉加载更多')
                    .fontSize(ThemeConstants.FONT_SIZE_XS)
                    .fontColor(ThemeConstants.TEXT_TERTIARY)
                }
                .width('100%')
                .height(50)
                .justifyContent(FlexAlign.Center)
              }
              .onClick(() => this.loadMoreArticles())
            } else if (this.articles.length > 0) {
              ListItem() {
                Row() {
                  Text('- 没有更多了 -')
                    .fontSize(ThemeConstants.FONT_SIZE_XXS)
                    .fontColor(ThemeConstants.TEXT_TERTIARY)
                }
                .width('100%')
                .height(50)
                .justifyContent(FlexAlign.Center)
              }
            }
          }
          .width('100%')
          .layoutWeight(1)
          .onReachEnd(() => {
            this.loadMoreArticles()
          })
        }
        .onRefreshing(() => this.refreshData())
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ThemeConstants.BG_PAGE)
  }

  /**
   * Banner组件
   */
  @Builder
  BannerSection() {
    Column() {
      Swiper() {
        ForEach(this.banners, (banner: Banner) => {
          Stack() {
            Image(banner.imagePath)
              .width('100%')
              .height(180)
              .objectFit(ImageFit.Cover)
              .borderRadius(ThemeConstants.BORDER_RADIUS_MD)
              .onError(() => {
                console.error('Banner image load failed:', banner.imagePath)
              })
              .onComplete(() => {
                console.info('Banner image loaded successfully')
              })

            Column() {
              Text(banner.title)
                .fontSize(ThemeConstants.FONT_SIZE_BASE)
                .fontColor(ThemeConstants.TEXT_WHITE)
                .fontWeight(FontWeight.Bold)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('100%')
            .height('100%')
            .padding(ThemeConstants.SPACE_MD)
            .justifyContent(FlexAlign.End)
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('rgba(0,0,0,0.3)')
            .borderRadius(ThemeConstants.BORDER_RADIUS_MD)
          }
          .onClick(() => {
            console.info(`点击Banner: ${banner.title}`)
          })
        })
      }
      .width('100%')
      .height(180)
      .autoPlay(true)
      .interval(3000)
      .indicator(true)
      .borderRadius(ThemeConstants.BORDER_RADIUS_MD)
    }
    .width('100%')
    .padding(ThemeConstants.SPACE_MD)
    .backgroundColor(ThemeConstants.BG_WHITE)
    .margin({ bottom: ThemeConstants.SPACE_XS })
  }

  /**
   * 热词组件
   */
  @Builder
  HotKeysSection() {
    Column() {
      Text('热门搜索')
        .fontSize(ThemeConstants.FONT_SIZE_BASE)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: ThemeConstants.SPACE_SM })
        .alignSelf(ItemAlign.Start)

      Flex({ wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
        ForEach(this.hotKeys, (hotKey: HotKey) => {
          Text(hotKey.name)
            .fontSize(ThemeConstants.FONT_SIZE_XXS)
            .fontColor(ThemeConstants.PRIMARY_COLOR)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(ThemeConstants.PRIMARY_LIGHT_COLOR)
            .borderRadius(16)
            .margin({ right: ThemeConstants.SPACE_XS, bottom: ThemeConstants.SPACE_XS })
            .onClick(() => {
              console.info(`点击热词: ${hotKey.name}`)
              // 这里可以执行搜索操作
            })
        })
      }
    }
    .width('100%')
    .padding(ThemeConstants.SPACE_MD)
    .backgroundColor(ThemeConstants.BG_WHITE)
    .margin({ bottom: ThemeConstants.SPACE_XS })
  }

  /**
   * 文章项组件
   */
  @Builder
  ArticleItem(article: Article) {
    Column() {
      Row() {
        Column() {
          Text(article.title)
            .fontSize(ThemeConstants.FONT_SIZE_BASE)
            .fontColor(ThemeConstants.TEXT_PRIMARY)
            .fontWeight(FontWeight.Medium)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(22)

          if (article.desc) {
            Text(article.desc)
              .fontSize(ThemeConstants.FONT_SIZE_XS)
              .fontColor(ThemeConstants.TEXT_SECONDARY)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: ThemeConstants.SPACE_XS })
              .lineHeight(20)
          }

          Row() {
            Text(`作者: ${article.author || article.shareUser || '未知'}`)
              .fontSize(ThemeConstants.FONT_SIZE_XXS)
              .fontColor(ThemeConstants.TEXT_TERTIARY)

            Blank()

            Text(article.niceDate)
              .fontSize(ThemeConstants.FONT_SIZE_XXS)
              .fontColor(ThemeConstants.TEXT_TERTIARY)
          }
          .width('100%')
          .margin({ top: ThemeConstants.SPACE_SM })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        if (article.envelopePic) {
          Image(article.envelopePic)
            .width(80)
            .height(60)
            .objectFit(ImageFit.Cover)
            .borderRadius(ThemeConstants.BORDER_RADIUS_XS)
            .margin({ left: ThemeConstants.SPACE_SM })
            .onError(() => {
              console.error('Article image load failed:', article.envelopePic)
            })
            .alt('图片加载失败')
        }
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)

      Row() {
        if (article.fresh) {
          Text('新')
            .fontSize(10)
            .fontColor(ThemeConstants.TEXT_WHITE)
            .backgroundColor(ThemeConstants.DANGER_COLOR)
            .padding({ left: 4, right: 4, top: 2, bottom: 2 })
            .borderRadius(2)
            .margin({ right: ThemeConstants.SPACE_XS })
        }

        Text(`${article.superChapterName} / ${article.chapterName}`)
          .fontSize(ThemeConstants.FONT_SIZE_XXS)
          .fontColor(ThemeConstants.PRIMARY_COLOR)
          .backgroundColor(ThemeConstants.PRIMARY_LIGHT_COLOR)
          .padding({ left: 8, right: 8, top: 4, bottom: 4 })
          .borderRadius(12)

        Blank()

        if (article.collect) {
          Text('♥')
            .fontSize(16)
            .fontColor(ThemeConstants.DANGER_COLOR)
        }
      }
      .width('100%')
      .margin({ top: ThemeConstants.SPACE_SM })
    }
    .width('100%')
    .padding(ThemeConstants.SPACE_MD)
    .backgroundColor(ThemeConstants.BG_WHITE)
    .borderRadius(ThemeConstants.BORDER_RADIUS_SM)
    .margin({ left: ThemeConstants.SPACE_MD, right: ThemeConstants.SPACE_MD, bottom: ThemeConstants.SPACE_XS })
  }
}
