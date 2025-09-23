# Flutter Demo App

这是一个Flutter演示应用，展示了Flutter的各种核心功能。

## 功能特性

- 🎨 **Material Design 3** - 现代化的UI设计
- 🔢 **计数器功能** - 展示状态管理
- 🎨 **主题颜色切换** - 支持多种颜色主题
- 🌙 **深色/浅色模式** - 动态主题切换
- 📱 **响应式布局** - 适配不同屏幕尺寸
- ✨ **动画效果** - 流畅的用户交互

## 运行应用

### 在Android设备上运行

1. 确保Android设备已连接或模拟器已启动
2. 在项目目录中运行：
   ```bash
   flutter run
   ```

### 在Web浏览器中运行

```bash
flutter run -d chrome
```

### 在macOS上运行

```bash
flutter run -d macos
```

## 项目结构

```
lib/
├── main.dart          # 主应用文件
└── ...

android/               # Android平台特定代码
ios/                   # iOS平台特定代码
web/                   # Web平台特定代码
macos/                 # macOS平台特定代码
```

## 开发环境要求

- Flutter SDK 3.35.4+
- Dart 3.9.2+
- Android SDK (用于Android开发)
- Chrome浏览器 (用于Web开发)

## 主要组件

- `MyApp` - 应用根组件
- `DemoHomePage` - 主页面组件
- `_DemoHomePageState` - 页面状态管理

## 学习要点

这个demo应用展示了以下Flutter概念：

1. **Widget树结构** - 如何组织UI组件
2. **状态管理** - 使用StatefulWidget和setState
3. **主题系统** - 动态切换应用主题
4. **布局组件** - Column, Row, Card, Wrap等
5. **交互组件** - Button, IconButton, FilterChip等
6. **样式系统** - TextStyle, ColorScheme等

## 下一步

尝试修改代码来学习更多Flutter功能：

- 添加新的页面和导航
- 实现更复杂的动画
- 集成网络请求
- 添加本地数据存储
- 实现用户认证

## 参考资源

- [Flutter官方文档](https://docs.flutter.dev/)
- [Dart语言文档](https://dart.dev/)
- [Material Design指南](https://m3.material.io/)