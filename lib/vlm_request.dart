import 'dart:convert';
import 'package:http/http.dart' as http;

void sendRequest() async {
  // API URL
  var url = Uri.parse(
      'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation');

  // Request headers
  var headers = {
    'Authorization': 'sk-4bf6015a2b2946ab991f209f0eec2ad8',
    'Content-Type': 'application/json',
  };

  // Request body
  var body = jsonEncode({
    "model": "qwen-vl-plus",
    "input": {
      "messages": [
        {
          "role": "system",
          "content": [
            {"text": "You are a helpful assistant."}
          ]
        },
        {
          "role": "user",
          "content": [
            {"image": "https://llava-vl.github.io/static/images/view.jpg"},
            {"text": "what is in the image?"}
          ]
        }
      ]
    },
    "parameters": {}
  });

  // Send POST request
  var response = await http.post(url, headers: headers, body: body);

  // Handle the response
  if (response.statusCode == 200) {
    print('Response: ${response.body}');
  } else {
    print('Request failed with status: ${response.body}');
  }
}

void main() {
  sendRequest();
}
