# AI 聊天助手

这是一个类似ChatGPT的Flutter聊天应用，集成了DeepSeek AI模型。

## 功能特性

- 🤖 与AI助手实时对话
- 💬 类似ChatGPT的聊天界面
- 📱 响应式设计，支持移动端
- 🎨 Material Design 3 风格
- 🔄 实时消息状态显示
- 🗑️ 清空聊天记录功能

## 技术栈

- **Flutter**: 跨平台UI框架
- **Provider**: 状态管理
- **HTTP**: 网络请求
- **Material Design 3**: UI设计语言

## API接口

应用调用以下API进行AI对话：

```bash
curl -X POST http://47.94.76.216/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "今天北京天气如何",
    "model": "deepseek-ai/DeepSeek-V3.1",
    "temperature": 0.8,
    "maxTokens": 500
  }'
```

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/
│   └── chat_message.dart     # 聊天消息数据模型
├── providers/
│   └── chat_provider.dart    # 聊天状态管理
├── services/
│   └── ai_chat_service.dart  # AI聊天服务
└── screens/
    └── chat_screen.dart      # 聊天界面
```

## 使用方法

1. 运行应用：`flutter run`
2. 点击底部导航栏的"AI聊天"标签
3. 在输入框中输入您的问题
4. 点击发送按钮或按回车键发送消息
5. AI将自动回复您的消息

## 主要组件

### ChatMessage
聊天消息的数据模型，包含内容、发送者、时间戳和加载状态。

### AIChatService
处理与AI API的通信，发送用户消息并接收AI回复。

### ChatProvider
使用Provider模式管理聊天状态，包括消息列表的增删改查。

### ChatScreen
聊天界面的主要UI组件，包含消息列表和输入框。

## 自定义配置

您可以在 `ai_chat_service.dart` 中修改以下参数：

- `model`: AI模型名称
- `temperature`: 回复的随机性 (0.0-1.0)
- `maxTokens`: 最大回复长度

## 注意事项

- 确保设备有网络连接
- API服务需要可访问性
- 建议在真机上测试以获得最佳体验
