import { HomeFragment } from './fragment/HomeFragment';
import { FoodListFragment } from './fragment/FoodListFragment';
import CartFragment from './fragment/CartFragment';
import DbUtil from '../util/DbUtil';
import Food from '../modle/Food';
import { shijian } from './shijian';
import { OrderPage } from './OrderPage';
import { geren } from './geren';

export const Path_Main = 'pages/WelcomePage'

@Entry
@Component
struct MainPage {
  @State message: string = 'Hello World';
  @State selectedIndex: number = 0
  @State pruducts: Food[] = [];

  @Builder
  myBuilder(itemIndex: number, title: string, icon1: ResourceStr, icon2: ResourceStr) {
    Column() {
      Image(itemIndex == this.selectedIndex ? icon2 : icon1)
        .width(25)
      Text(title)
        .fontColor(itemIndex == this.selectedIndex ? Color.Red : Color.Black)
        .margin({top:8})
    }
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.End
      }) {
        TabContent() {
          Column() {
            HomeFragment()
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(0, '首页', $r('app.media.home_black'), $r('app.media.home_red')));

        TabContent() {
          Column() {
            FoodListFragment()
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(1, '点餐', $r('app.media.diancan_black'), $r("app.media.diancan_red")))

        TabContent() {
          Column() {
            CartFragment()
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(2, '购物车', $r('app.media.cai00'), $r('app.media.cai11')))

        TabContent() {
          Column() {
            OrderPage()
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(3, '订单', $r('app.media.dan000'), $r('app.media.dan111')))

        TabContent() {
          Column() {
            geren()
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(4, '我的', $r('app.media.mine_black'), $r('app.media.mine_red')))

      }
      .barPosition(BarPosition.End)
      .scrollable(false)
      .padding({bottom:30})
      .onChange(async (index) => {
        this.selectedIndex = index
      })

    }
    .height('100%')
    .width('100%')
  }
}