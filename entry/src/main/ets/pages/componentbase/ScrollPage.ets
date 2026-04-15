@Entry
@Component
struct ScrollPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Scroll() {
        Column({ space: 10 }) {
          ForEach(Array.from({ length: 10 }), (item: string, index: number) => {
            Text('测试' + (index + 1))
              .width('100%')
              .height(100)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.Orange)
              .fontSize(20)
              .fontColor(Color.Black)
              .borderRadius(10)
          })
        }
        .padding(10)
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .height(400)
    }
    // .height('100%')
    // .width('100%')
  }
}