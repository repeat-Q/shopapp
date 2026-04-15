import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { userDB } from './UserDatabase';

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
  .backgroundColor(Color.White)
}

@Entry
@Component
struct RegistPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';

  build() {
    Stack() {
      // 背景图片
      Image($r("app.media.bg5050"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        // Logo区域
        Image($r("app.media.food1111"))
          .width(120)
          .height(120)
          .margin({ top: 80, bottom: 40 })
          .shadow({ radius: 10, color: '#EB5E1A', offsetX: 0, offsetY: 5 })

        // 标题
        Text('用户注册')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 50 })
          .fontColor('#EB5E1A')
          .textShadow({ radius: 2, color: '#F5A07A', offsetX: 1, offsetY: 1 })

        // 表单区域
        Column() {
          TextInput({ placeholder: '请输入用户名' })
            .inputStyle()
            .onChange((value: string) => this.username = value)

          TextInput({ placeholder: '请输入密码' })
            .inputStyle()
            .type(InputType.Password)
            .onChange((value: string) => this.password = value)
            .margin({ top: 20 })

          TextInput({ placeholder: '确认密码' })
            .inputStyle()
            .type(InputType.Password)
            .onChange((value: string) => this.confirmPassword = value)
            .margin({ top: 20 })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        // 注册按钮
        Button('注册', { type: ButtonType.Capsule })
          .width('80%')
          .height(50)
          .margin(40)
          .backgroundColor('#EB5E1A')
          .fontColor(Color.White)
          .fontSize(18)
          .onClick(() => this.handleRegistration())

        // 登录链接
        Row() {
          Text('已有账号？')
            .fontColor('#666666')

          Text('立即登录')
            .fontColor('#EB5E1A')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 5 })
            .onClick(() => router.back())
        }
        .margin({ top: 20 })
      }
      .width('100%')
      .height('100%')
      .padding(20)
    }
  }

  async handleRegistration() {
    if (!this.username || !this.password || !this.confirmPassword) {
      promptAction.showToast({ message: '请填写完整信息', duration: 1000 });
      return;
    }

    if (this.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次密码不一致', duration: 1000 });
      return;
    }

    try {
      const exists = await userDB.checkUserExists(this.username);
      if (exists) {
        promptAction.showToast({ message: '用户名已存在', duration: 1000 });
        return;
      }

      const success = await userDB.registerUser(this.username, this.password);
      if (success) {
        promptAction.showToast({ message: '注册成功', duration: 1000 });
        setTimeout(() => router.back(), 1500);
      }
    } catch (err) {
      promptAction.showToast({ message: '注册失败，请重试', duration: 1000 });
    }
  }
}