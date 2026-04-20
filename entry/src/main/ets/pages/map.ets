import webview from '@ohos.web.webview'
import { router } from '@kit.ArkUI'

@Entry
@Component
export struct map {
  private webviewController: webview.WebviewController = new webview.WebviewController()
  @State isLoaded: boolean = false

  build() {
    Column() {
      // 顶部透明占位（隐藏原生导航栏，由H5面板做顶栏）
      Row()
        .width('100%')
        .height(0)
        .visibility(Visibility.Hidden)

      // 地图WebView（占据全屏，H5负责顶部面板和工具栏）
      Web({
        src: $rawfile('map.html'),
        controller: this.webviewController
      })
        .width('100%')
        .layoutWeight(1)
        .javaScriptAccess(true)
        .geolocationAccess(true)
        .domStorageAccess(true)
        .onPageEnd(() => {
          this.isLoaded = true
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
