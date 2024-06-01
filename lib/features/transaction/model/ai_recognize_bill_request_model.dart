class OpenAiRequest {
  final String model;
  final List<Message> messages;
  final int maxTokens;

  OpenAiRequest({
    required this.model,
    required this.messages,
    this.maxTokens = 300,
  });

  Map<String, dynamic> toJson() => {
    'model': model,
    'messages': messages.map((message) => message.toJson()).toList(),
    'max_tokens': maxTokens,
  };
}

class Message {
  final String role;
  final List<Content> content;

  Message({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content.map((content) => content.toJson()).toList(),
  };
}

class Content {
  final String type;
  final String? text;
  final ImageUrl? imageUrl;

  Content({
    required this.type,
    this.text,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'text': text,
    'image_url': imageUrl?.toJson(),
  };
}

class ImageUrl {
  final String url;

  ImageUrl({
    required this.url,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
  };
}
