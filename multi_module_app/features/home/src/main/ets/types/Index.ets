@ObservedV2
export class CourseInfo {
  @Trace id: number = 0
  @Trace title: string = ''
  @Trace instructor: string = ''
  @Trace thumbnail: ResourceStr = ''
  @Trace rating: number = 0
}

export interface CourseDetailParams {
  courseId: number;
  courseTitle: string;
}