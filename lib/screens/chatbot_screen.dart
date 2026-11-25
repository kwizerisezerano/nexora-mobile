import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/site.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  static const _systemPrompt =
      'You are a helpful AI assistant for Nexora Technologies, a Rwanda-based '
      'software development company. Nexora currently focuses exclusively on '
      'SOFTWARE DEVELOPMENT services including: web applications, mobile apps, '
      'backend APIs, SaaS products, databases, enterprise systems, payment '
      'integrations, and custom software solutions. Do NOT mention IoT, '
      'networking, IT infrastructure, or hardware services as these are planned '
      'for future expansion but not currently offered. Keep responses focused on '
      'software development capabilities. Be professional, friendly, and helpful.';

  final List<Map<String, String>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(Site.openRouterUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Site.openRouterApiKey}',
          'HTTP-Referer': 'https://nexoratechnologies.com',
          'X-Title': 'Nexora Technologies',
        },
        body: jsonEncode({
          'model': Site.openRouterModel,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            ..._messages,
          ],
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final assistantMessage =
            data['choices']?[0]?['message']?['content'] ?? 'No response from AI';
        setState(() {
          _messages.add({'role': 'assistant', 'content': assistantMessage});
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content':
                'Error: ${data['error']?['message'] ?? data['message'] ?? 'Failed to get response'}'
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'content': 'Error: Failed to connect to AI service. Please check your connection.'
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexora AI Assistant'),
        backgroundColor: const Color(0xFF19A657),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            size: 40,
                            color: Color(0xFF19A657),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nexora AI Assistant',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ask me about our software development services',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFFE8F5E9),
                                  child: Icon(
                                    Icons.smart_toy,
                                    color: Color(0xFF19A657),
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF19A657),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message['role'] == 'user';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isUser
                                  ? const Color(0xFF19A657)
                                  : const Color(0xFFE8F5E9),
                              child: Icon(
                                isUser ? Icons.person : Icons.smart_toy,
                                color: isUser ? Colors.white : const Color(0xFF19A657),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isUser ? 'You' : 'Nexora AI',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? const Color(0xFF19A657)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isUser
                                          ? null
                                          : Border.all(color: const Color(0xFFCBD5E1)),
                                    ),
                                    child: Text(
                                      message['content'] ?? '',
                                      style: TextStyle(
                                        color: isUser ? Colors.white : const Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF19A657),
                            ),
                          ),
                        )
                      : const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF19A657),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
