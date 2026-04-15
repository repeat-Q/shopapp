import webview from '@ohos.web.webview'

@Entry
@Component
export struct map {
  private webviewController: webview.WebviewController = new webview.WebviewController()

  build() {
    Column() {
      Web({
        src: "https://www.amap.com",
        controller: this.webviewController
      })
        .width('100%')
        .height('100%')
        .onPageBegin((event) => {
        })
        .onPageEnd((event) => {
        })
    }
    .width('100%')
    .height('100%')
  }
}