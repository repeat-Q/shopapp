import { preferences } from '@kit.ArkData'

class PreferenceUtil {
  sp_name: string = 'ShopApp';
  private pref: preferences.Preferences | null = null

  /*
    * 初始化preferences实例
    * @context  应用上下文
   */
  async init(context: Context) {
    try {
      this.pref = await preferences.getPreferences(context, this.sp_name)
    } catch (err) {
    }
  }

  /*
    * 销毁preferences实例 - 缓存、持久化文件一并销毁
    * @context  应用上下文
   */
  async delPreference(context: Context) {
    try {
      await preferences.deletePreferences(context, this.sp_name)
    } catch (err) {
    }
  }

  /*
    * 从preferences实例中获取键对应的值
    * @key            健
    * @defaultValue   获取失败时，返回的值
   */
  async getPreferenceValue(key: string, defaultValue: preferences.ValueType): Promise<preferences.ValueType> {

    let value: preferences.ValueType = defaultValue

    // 获取对应的值之前，先判断preferences是否初始化完成
    if (!this.pref) {
      return value
    }

    try {
      value = await this.pref.get(key, defaultValue);
    } catch (err) {
    }

    return value;
  }

  /*
  * 从Preferences实例中写入数据
  * @key        健
  * @value      值
*/
  async putPreferenceValue(key: string, value: preferences.ValueType): Promise<void> {

    // 写入数据之前，先判断preferences是否初始化完成
    if (!this.pref) {
      return
    }

    try {
      await this.pref.put(key, value);
      // 持久化
      await this.pref.flush();
    } catch (err) {
    }

  }
}

const preferenceUtil = new PreferenceUtil()

export default preferenceUtil as PreferenceUtil
