/**
 * 玩安卓API数据模型
 */
import http from '@ohos.net.http';

// 基础响应结构
export interface BaseResponse<T> {
  data: T;
  errorCode: number;
  errorMsg: string;
}

// 文章数据模型
export interface Article {
  id: number;
  title: string;
  link: string;
  author: string;
  shareUser: string;
  niceDate: string;
  desc: string;
  chapterName: string;
  superChapterName: string;
  collect: boolean;
  fresh: boolean;
  tags: Tag[];
  envelopePic: string;
}

// 标签模型
export interface Tag {
  name: string;
  url: string;
}

// 分页数据模型
export interface PageData<T> {
  curPage: number;
  datas: T[];
  offset: number;
  over: boolean;
  pageCount: number;
  size: number;
  total: number;
}

// Banner数据模型
export interface Banner {
  id: number;
  desc: string;
  imagePath: string;
  isVisible: number;
  order: number;
  title: string;
  type: number;
  url: string;
}

// 常用网站模型
export interface FriendLink {
  id: number;
  name: string;
  link: string;
  order: number;
  visible: number;
}

// 搜索热词模型
export interface HotKey {
  id: number;
  link: string;
  name: string;
  order: number;
  visible: number;
}

// 体系数据模型
export interface TreeNode {
  id: number;
  name: string;
  courseId: number;
  order: number;
  parentChapterId: number;
  visible: number;
  children: TreeNode[];
}

// HTTP请求选项接口
export interface RequestOptions {
  method: http.RequestMethod;
  header: Record<string, string>;
  connectTimeout: number;
  readTimeout: number;
}

// 错误对象接口
export interface ErrorObject {
  code: number;
  message?: string;
}
