import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Function to send request to the API and get response
  Future<void> _sendMessage() async {
    String message = _controller.text;
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": message});
      _isLoading = true;
    });

    _controller.clear();
    await dotenv.load();
    String model = "glm-4-plus";
    // Send the message to your API (you can adjust the URL and parameters)
    String? apiKey = dotenv.env['API_KEY'];  // 从环境变量获取API密钥
    String url = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',  // 使用Bearer Token授权
      },
      body: jsonEncode({
        'model': model,
        'messages': _messages,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String reply = data['choices'][0]['message']['content'];

      setState(() {
        _messages.add({"role": "assistant", "content": reply});
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error occurred. Please try again."});
        _isLoading = false;
      });
    }
  }

  // Widget to display messages in bubble style
  Widget _buildMessage(String role, String content) {
    bool isUser = role == 'user';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: 250),
          child: Text(
            content,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("文物小助手")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message['role']!, message['content']!);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '...',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}