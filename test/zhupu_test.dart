import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> sendRequest() async {
  await dotenv.load();
  String? apiKey = dotenv.env['API_KEY'];
  String model = "glm-4-plus"; // 请替换成您想要调用的模型名称
  const String url = "https://open.bigmodel.cn/api/paas/v4/chat/completions";

  // 请求体
  final Map<String, dynamic> requestBody = {
    'model': model,
    'messages': [
      {"role": "user", "content": "作为一名营销专家，请为我的产品创作一个吸引人的口号"},
      {"role": "assistant", "content": "当然，要创作一个吸引人的口号，请告诉我一些关于您产品的信息"},
      {"role": "user", "content": "智谱AI开放平台"},
      {"role": "assistant", "content": "点燃未来，智谱AI绘制无限，让创新触手可及！"},
      {"role": "user", "content": "创作一个更精准且吸引人的口号"}
    ],
    'do_sample': true,
    'temperature': 0.95,
    'max_tokens': 1024,
  };

  // 设置请求头
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey', // 根据 API 文档的要求，可能需要传递 API 密钥
  };

  try {
    // 发送 POST 请求
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(requestBody),
    );

    // 检查响应状态码
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // 打印响应内容
      return 'Response: ${responseData['choices'][0]['message']['content']}';
    } else {
      return 'Request failed with status: ${response.statusCode}';
    }
  } catch (e) {
    return ('Error: $e');
  }
}

void main() {
  
  test("test zhipu api", () async {
    print(await sendRequest());
  }

  );
}
