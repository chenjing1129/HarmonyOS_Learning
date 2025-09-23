// GridDemo.ets
export interface Assignment {
  title: string;
  deadline: string;
  status: 'pending' | 'completed' | 'overdue';
}

@Preview
@Component
export struct GridDemo {
  @State assignments: Assignment[] = [
    { title: '数学作业', deadline: '2025-09-15', status: 'pending' },
    { title: 'Java编程', deadline: '2025-09-16', status: 'completed' },
    { title: '英语作文', deadline: '2025-09-17', status: 'pending' },
    { title: '物理实验', deadline: '2025-09-18', status: 'overdue' },
    { title: '化学报告', deadline: '2025-09-19', status: 'pending' },
    { title: '历史论文', deadline: '2025-09-20', status: 'completed' }
  ];

  /* 根据状态返回图标字符（可换成 Image） */
  getIconByStatus(status: string): string {
    switch (status) {
      case 'pending':  return '⏳';
      case 'completed':return '✅';
      case 'overdue':  return '⚠️';
      default:         return '❓';
    }
  }

  /* 根据状态返回主色调 */
  getColorByStatus(status: string): string {
    switch (status) {
      case 'pending':  return '#FF9800';
      case 'completed':return '#4CAF50';
      case 'overdue':  return '#FF5722';
      default:         return '#CCCCCC';
    }
  }

  build() {
    Grid() {
      ForEach(this.assignments, (assignment: Assignment) => {
        GridItem() {
          Column({ space: 8 }) {
            // 作业标题
            Text(assignment.title)
              .fontSize(16)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')

            // 状态图标
            Text(this.getIconByStatus(assignment.status))
              .fontSize(24)
              .textAlign(TextAlign.Center)

            // 状态文字
            Text(assignment.status)
              .fontColor(this.getColorByStatus(assignment.status))
              .fontSize(14)

            // 截止时间
            Text(assignment.deadline)
              .fontSize(12)
              .fontColor('#666')
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#F5F5F5')
          .borderRadius(12)
        }
        .padding(6)
      }, (assignment: Assignment) => assignment.title)
    }
    .columnsTemplate('1fr 1fr')          // 两列自适应
    .rowsGap(8)
    .columnsGap(8)
    .padding(16)
    .width('100%')
    .height('50%')
  }
}