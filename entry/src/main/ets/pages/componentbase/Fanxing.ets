// 泛型
// function 函数名<Type> (形参：Type) ： Type {
//   return 形参
// }

function fn<T> (param: T): T {
  return param
}

fn<number>(123)
fn<string>('123')
fn<string[]>(['123', '654', '987'])
fn<boolean>(true)

fn(123)
fn('123')
fn(true)

@Entry
@Component
struct FanXin {
  build() {
    Column() {

    }
  }
}
