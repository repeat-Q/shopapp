import router from '@ohos.router';

@Entry
@Component
struct WelcomePage {
  @State showAgreement: boolean = true

  build() {
    Column() {
      Scroll() {
        Column() {
          Text('用户协议及隐私政策')
            .fontSize(24)
            .margin({ bottom: 20 })

          Text('欢迎使用ShopApp服务...')
            .fontSize(16)
            .textAlign(TextAlign.Start)
        }
        .padding(20)
      }
      .flexGrow(1)


      Row() {
        Button('不同意')
          .onClick(() => {
            router.back()
          })
          .backgroundColor('#F0F0F0')
          .fontColor('#333')

        Button('同意')
          .onClick(() => {

            router.replaceUrl({ url: 'pages/MainPage' })
          })
          .backgroundColor('#EB5E1A')
          .fontColor('#FFF')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(20)
    }
    .width('100%')
    .height('100%')
  }


  onPageShow() {
    this.showAgreement = true
  }
}



