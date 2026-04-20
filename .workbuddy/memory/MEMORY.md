# MEMORY.md - 项目长期记忆

## 项目：shopapp (HarmonyOS ArkTS 点餐系统)

### 技术栈
- HarmonyOS ArkTS + ArkUI 声明式UI
- 单Ability + 多页面路由模式
- SQLite (RdbTest.db + UserDB.db) 本地持久化
- DevEco Studio 开发环境

### 项目结构（已完整分析，2026-04-15）
- 26个.ets文件，5 Tab主页结构
- 入口：SplashPage → LoginPage → WelcomePage → MainPage
- 核心文件：HomeFragment / FoodListFragment / CartFragment / OrderPage / geren.ets
- 数据层：MyData.ets(静态) + DbUtil.ets(SQLite) + PreferencesUtil.ets(未使用)
- 主色调：#EB5E1A 橙红色（已统一）

### 已完成改造（2026-04-15）
1. ✅ UI风格统一：所有页面颜色统一为#EB5E1A
2. ✅ 首页升级：卡片式布局，阴影效果，圆角设计
3. ✅ 个人中心重构：List组件，菜单列表
4. ✅ 购物车优化：数量合并，加减控件，改进结算栏
5. ✅ Bug修复：meituan.ets正确链接，geren退出登录用replaceUrl
6. ✅ 项目痕迹清理：移除所有调试日志、原始标识符、文件名注释
7. ✅ Git已提交

### 地图页面 (map.ets + map.html)
- 方案：WebView + 本地 HTML + 高德 JS API v2.0
- **关键**：必须先定义 `window._AMapSecurityConfig = { securityJsCode: '...' }` 再加载地图 JS
- JS_KEY: `3a5628188e4853dcff3425f59058a32b`（用于加载地图）
- WEB_KEY: `5c4aff1e82b1c39bd6733d6146fa9caa`（用于 REST API）
- securityJsCode: `24b4877388301846de3978ea560d6c25`（v2.0必须，注意不是之前的24b5开头的）
- 加载策略：动态创建script标签，先试v2.0+securityJsCode，onerror自动降级v1.4.15
- v2.0 插件需用 `AMap.plugin()` 动态加载，不能仅靠 URL 参数
- 默认起点：北京天安门 [116.397428, 39.90923]

### 已知Bug（待修复）
1. PreferencesUtil已初始化但未使用（登录状态未持久化）
2. 首页余额/积分/用户名全部硬编码
3. shijian.ets无导航入口（孤立页面）

### 用户偏好
- 中文交流，直接行动导向
- 只修改UI/功能，不引发其他模块错误
- 完成后需git commit并push
- 遇到问题会提供截图反馈
- 期望改造后：功能丰富、UI协调美观
