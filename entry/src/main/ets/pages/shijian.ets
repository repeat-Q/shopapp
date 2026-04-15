@Entry
@Component
export struct shijian {
  @State countDownSeconds: number = 0
  @State isCounting: boolean = false
  @State currentTime: string = ''
  @State minutes: number = 0
  private timerId: number = 0
  private timeUpdateId: number = 0

  // 系统时间更新
  updateSystemTime() {
    this.currentTime = new Date().toLocaleTimeString()
  }

  // 倒计时开始
  startCountdown() {
    if (this.minutes <= 0) return

    this.isCounting = true
    this.countDownSeconds = this.minutes * 60

    this.timerId = setInterval(() => {
      if (this.countDownSeconds > 0) {
        this.countDownSeconds -= 1
      } else {
        this.stopCountdown()
        AlertDialog.show({ message: '倒计时结束！' })
      }
    }, 1000)
  }

  // 倒计时暂停/继续
  toggleCountdown() {
    if (this.isCounting) {
      clearInterval(this.timerId)
    } else {
      this.timerId = setInterval(() => {
        if (this.countDownSeconds > 0) {
          this.countDownSeconds -= 1
        }
      }, 1000)
    }
    this.isCounting = !this.isCounting
  }

  // 停止倒计时
  stopCountdown() {
    clearInterval(this.timerId)
    this.isCounting = false
    this.countDownSeconds = 0
    this.minutes = 0
  }

  // 时间格式转换
  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }

  aboutToAppear() {
    // 初始化系统时间更新
    this.updateSystemTime()
    this.timeUpdateId = setInterval((): void => this.updateSystemTime(), 1000)
  }

  aboutToDisappear() {
    // 清除定时器
    clearInterval(this.timerId)
    clearInterval(this.timeUpdateId)
  }

  build() {
    Column() {
      // 显示系统时间
      Text(this.currentTime)
        .fontSize(20)
        .margin(10)

      // 微调按钮
      Row() {
        Button('-')
          .onClick(() => {
            if (this.minutes > 0 && !this.isCounting) {
              this.minutes -= 1
            }
          })
          .enabled(!this.isCounting)

        Text(`${this.minutes} 分钟`)
          .fontSize(20)
          .margin(10)

        Button('+')
          .onClick(() => {
            if (!this.isCounting) {
              this.minutes += 1
            }
          })
          .enabled(!this.isCounting)
      }
      .margin(10)

      // 倒计时显示
      Text(this.formatTime(this.countDownSeconds))
        .fontSize(30)
        .margin(10)

      // 控制按钮
      Row() {
        if (!this.isCounting && this.countDownSeconds === 0) {
          Button('开始')
            .onClick(() => this.startCountdown())
            .enabled(this.minutes > 0)
        } else {
          Button(this.isCounting ? '暂停' : '继续')
            .onClick(() => this.toggleCountdown())
            .enabled(this.countDownSeconds > 0)

          Button('停止')
            .onClick(() => this.stopCountdown())
            .margin(10)
        }
      }
      .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}