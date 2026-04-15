import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { userDB } from './UserDatabase';

@Styles
function redTheme() {
  .backgroundColor(Color.Transparent)
}

@Extend(TextInput)
function inputStyle() {
  .placeholderColor(0x999999)
  .padding(12)
  .margin(10)
  .width('90%')
  .height(40)
  .borderRadius(8)
  .borderWidth(1)
  .borderColor('#EB5E1A')
}

@Entry
@Component
export struct LoginPage {
  @State user: string = '';
  @State password: string = '';

  build() {
    Stack() {
      // 背景图片 - 使用image01
      Image($r("app.media.bg5050"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .opacity(0.9)

      // 半透明遮罩层，增强文字可读性
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(235, 94, 26, 0.1)')

      Column() {
        // Logo区域
        Column() {
          Image($r("app.media.food1111"))
            .width(120)
            .height(120)
            .margin({ top: 80, bottom: 20 })
            .shadow({ radius: 10, color: '#EB5E1A', offsetX: 0, offsetY: 5 })
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')

        // 标题区域
        Column() {
          Text('用户登录')
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })
            .fontColor('#EB5E1A')
            .textShadow({ radius: 2, color: '#F5A07A', offsetX: 1, offsetY: 1 })

          Text('欢迎回来，请登录您的账号')
            .fontSize(14)
            .fontColor('#FFFFFFFF')
            .margin({ bottom: 40 })
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')

        // 输入框区域
        Column() {
          TextInput({ placeholder: '请输入用户名' })
            .inputStyle()
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .onChange((value: string) => this.user = value)

          TextInput({ placeholder: '请输入密码' })
            .inputStyle()
            .backgroundColor('rgba(255, 255, 255, 0.8)')
            .type(InputType.Password)
            .onChange((value: string) => this.password = value)
            .margin({ top: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 登录按钮
        Button('登 录', { type: ButtonType.Capsule })
          .width('80%')
          .height(50)
          .margin({ top: 40, bottom: 20 })
          .backgroundColor('#EB5E1A')
          .fontColor(Color.White)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .shadow({ radius: 5, color: '#B84A14', offsetX: 0, offsetY: 3 })
          .onClick(() => this.handleLogin())

        // 注册链接
        Row() {
          Text('没有账号？')
            .fontColor('#EB5E1A')

          Text('立即注册')
            .fontColor('#EB5E1A')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 5 })
            .decoration({ type: TextDecorationType.Underline })
            .onClick(() => router.pushUrl({ url: 'pages/RegistPage' }))
        }
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
  }

  async handleLogin() {
    if (!this.user || !this.password) {
      promptAction.showToast({ message: '请输入完整信息', duration: 1000 });
      return;
    }

    try {
      const isValid = await userDB.validateUser(this.user, this.password);
      if (isValid) {
        promptAction.showToast({ message: '登录成功', duration: 1000 });
        router.replaceUrl({ url: 'pages/MainPage' });
      } else {
        promptAction.showToast({ message: '用户名或密码错误', duration: 1000 });
      }
    } catch (err) {
      promptAction.showToast({ message: '登录失败，请重试', duration: 1000 });
    }
  }
}