/**
 * 玩安卓相关类型定义
 */

/**
 * 首页Banner
 */
export interface BannerVO {
  desc: string
  id: number
  imagePath: string
  isVisible: number
  order: number
  title: string
  type: number
  url: string
}

/**
 * 文章数据
 */
export interface ArticleVO {
  id: number
  title: string
  link: string
  author: string
  shareUser: string
  niceDate: string
  desc: string
  envelopePic: string
  chapterName: string
  superChapterName: string
  fresh: boolean
  tags: ArticleTag[]
  collect: boolean
  zan: number
}

/**
 * 文章标签
 */
export interface ArticleTag {
  name: string
  url: string
}

/**
 * 分页数据
 */
export interface PageVO<T> {
  curPage: number
  datas: T[]
  offset: number
  over: boolean
  pageCount: number
  size: number
  total: number
}

/**
 * 置顶文章
 */
export interface TopArticleVO extends ArticleVO {
  type: number
}

/**
 * 搜索热词
 */
export interface HotKeyVO {
  id: number
  link: string
  name: string
  order: number
  visible: number
}

// 类型别名,方便使用
export type Article = ArticleVO
export type Banner = BannerVO
export type PageData<T> = PageVO<T>
export type HotKey = HotKeyVO

