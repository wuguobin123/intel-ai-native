import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class AIChatService {
  static const String _baseUrl = 'http://47.94.76.216/api/ai/chat';
  static const String _streamUrl = 'http://47.94.76.216/api/ai/stream';
  
  Future<String> sendMessage({
    required String message,
    String model = 'deepseek-ai/DeepSeek-V3.1',
    double temperature = 0.8,
    int maxTokens = 500,
  }) async {
    try {
      print('🚀 [AI Chat Service] 开始发送消息...');
      print('📝 [AI Chat Service] 用户消息: $message');
      print('🤖 [AI Chat Service] 模型: $model');
      print('🌡️ [AI Chat Service] 温度: $temperature');
      print('📏 [AI Chat Service] 最大Token: $maxTokens');
      
      final requestBody = {
        'message': message,
        'model': model,
        'temperature': temperature,
        'maxTokens': maxTokens,
      };
      
      print('📤 [AI Chat Service] 请求体: ${jsonEncode(requestBody)}');
      print('🌐 [AI Chat Service] 请求URL: $_baseUrl');
      
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('📊 [AI Chat Service] HTTP状态码: ${response.statusCode}');
      print('📄 [AI Chat Service] 响应头: ${response.headers}');
      print('📋 [AI Chat Service] 响应体: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ [AI Chat Service] JSON解析成功');
        print('🔍 [AI Chat Service] 解析后的数据: $data');
        
        // 检查API返回的code字段
        if (data['code'] == 200) {
          print('✅ [AI Chat Service] API业务状态码正常');
          // 从data.data.content中获取AI回复内容
          final rawContent = data['data']?['content'];
          // 兼容非字符串内容，并去除首尾空行/空白
          final content = (rawContent is String
                  ? rawContent
                  : (rawContent != null ? jsonEncode(rawContent) : ''))
              .replaceAll('\r\n', '\n')
              .trim();
          print('📝 [AI Chat Service] 提取的内容(已规范化): $content');
          
          if (content.isNotEmpty) {
            print('✅ [AI Chat Service] 成功获取AI回复内容');
            return content;
          } else {
            print('⚠️ [AI Chat Service] AI没有返回有效内容');
            return '抱歉，AI没有返回有效内容。';
          }
        } else {
          print('❌ [AI Chat Service] API业务状态码异常: ${data['code']}');
          print('❌ [AI Chat Service] 错误信息: ${data['message']}');
          // 如果code不是200，返回错误信息
          return 'API错误: ${data['message'] ?? '未知错误'}';
        }
      } else {
        print('❌ [AI Chat Service] HTTP请求失败: ${response.statusCode}');
        print('❌ [AI Chat Service] 错误响应: ${response.body}');
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 [AI Chat Service] 发生异常: $e');
      print('📚 [AI Chat Service] 异常类型: ${e.runtimeType}');
      throw Exception('网络错误: $e');
    }
  }

  /// SSE 流式输出，返回逐步生成的 token 流
  Stream<String> streamMessage({
    required String message,
    String model = 'deepseek-ai/DeepSeek-V3.1',
    double temperature = 0.8,
    int maxTokens = 500,
  }) async* {
    final client = http.Client();
    try {
      final uri = Uri.parse(_streamUrl).replace(
        queryParameters: {
          'message': message,
          'model': model,
          'temperature': temperature.toString(),
          'maxTokens': maxTokens.toString(),
        },
      );

      print('🌊 [AI Chat Service] 建立SSE连接: $uri');

      final request = http.Request('GET', uri);
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';
      request.headers['Connection'] = 'keep-alive';

      final response = await client.send(request);
      print('📊 [AI Chat Service] SSE状态码: ${response.statusCode}');
      if (response.statusCode != 200) {
        final body = await response.stream.bytesToString();
        print('❌ [AI Chat Service] SSE连接失败: ${response.statusCode} -> $body');
        throw Exception('SSE连接失败: ${response.statusCode}');
      }

      // 解析 Server-Sent Events 协议
      String? pendingEventType; // 例如: token
      final stream = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        // 空行表示一个事件结束
        if (line.isEmpty) {
          pendingEventType = null;
          continue;
        }
        if (line.startsWith('event:')) {
          pendingEventType = line.substring(6).trim();
          continue;
        }
        if (line.startsWith('data:')) {
          final data = line.substring(5).trim();
          // 若服务端使用 event: token，我们仅在该事件下发送；否则统一发送
          if (pendingEventType == null || pendingEventType == 'token') {
            if (data.isNotEmpty) {
              yield data;
            }
          }
          continue;
        }
        // 兼容没有 event 前缀的纯文本行（某些实现直接输出token）
        if (!line.contains(':')) {
          yield line;
        }
      }
      print('✅ [AI Chat Service] SSE完成');
    } catch (e) {
      print('💥 [AI Chat Service] SSE异常: $e');
      throw Exception('SSE错误: $e');
    } finally {
      client.close();
    }
  }
}
