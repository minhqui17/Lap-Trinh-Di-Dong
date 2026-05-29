import 'package:flutter/material.dart';
import 'package:travel_booking/features/chat/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Xin chào! Tôi là HUIT Assistant. Tôi có thể giúp gì cho chuyến du lịch của bạn hôm nay?",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final List<String> _quickReplies = [
    "Gợi ý địa điểm",
    "Khách sạn Đà Lạt",
    "Ưu đãi hôm nay",
    "Cách đặt phòng",
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage({String? text}) {
    String userText = text ?? _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: userText,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _controller.clear();
    _focusNode.requestFocus();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    String responseText = _generateResponse(userText);

    // Giả lập thời gian suy nghĩ của AI
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text: responseText,
              isMe: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });
  }

  String _generateResponse(String input) {
    input = input.toLowerCase();
    if (input.contains("chào") || input.contains("hi") || input.contains("hello")) {
      return "Chào bạn! Chúc bạn một ngày tốt lành. Bạn đang dự định đi du lịch ở đâu thế?";
    } 
    if (input.contains("địa điểm") || input.contains("gợi ý") || input.contains("đi đâu")) {
      return "Hiện tại tôi gợi ý bạn 3 điểm đến tuyệt nhất: \n1. Đà Lạt (Mát mẻ, lãng mạn) \n2. Phú Quốc (Nắng vàng, biển xanh) \n3. Sa Pa (Hùng vĩ, mây mù). \nBạn thích núi hay biển hơn?";
    }
    if (input.contains("núi")) {
      return "Tuyệt vời! Nếu thích núi, bạn không thể bỏ qua Sa Pa hoặc Hà Giang. Bạn có muốn xem danh sách khách sạn có view thung lũng không?";
    }
    if (input.contains("biển")) {
      return "Biển Việt Nam rất đẹp! Nha Trang, Phú Quốc và Đà Nẵng đang có nhiều resort giảm giá sâu. Bạn muốn tôi gửi danh sách không?";
    }
    if (input.contains("đà lạt")) {
      return "Đà Lạt là lựa chọn số 1 cho sự nghỉ dưỡng. \nGợi ý cho bạn: \n- Terracotta Hotel & Resort (Gần hồ Tuyền Lâm) \n- Ana Mandara Villas (Phong cách Pháp cổ) \n- Colline Hotel (Ngay trung tâm, hiện đại).";
    }
    if (input.contains("giá") || input.contains("bao nhiêu") || input.contains("đắt")) {
      return "Giá phòng dao động tùy hạng sao: \n- 3 sao: 500k - 800k \n- 4 sao: 1tr - 2tr \n- 5 sao: Từ 3tr trở lên. \nBạn muốn tìm trong tầm giá nào?";
    }
    if (input.contains("ưu đãi") || input.contains("khuyến mãi") || input.contains("giảm giá")) {
      return "🔥 Tin cực HOT: \n- Nhập mã 'HUIT2024' giảm ngay 100k cho đơn đầu tiên. \n- Đặt phòng tại Vũng Tàu hôm nay giảm thêm 15%. \nBạn có muốn đặt ngay không?";
    }
    if (input.contains("đặt") || input.contains("cách")) {
      return "Bạn chỉ cần chọn khách sạn trên màn hình chính, nhấn 'Đặt phòng', điền thông tin và chọn phương thức thanh toán. Rất nhanh chóng!";
    }
    if (input.contains("cảm ơn") || input.contains("thank")) {
      return "Không có gì ạ! Rất vui được hỗ trợ bạn. Chúc bạn có một chuyến đi đáng nhớ!";
    }

    return "Tôi hiểu rồi. Đó là một ý tưởng hay! Ngoài ra, bạn có muốn biết thêm về các dịch vụ đưa đón sân bay hay các tour tham quan tại đó không?";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("HUIT Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_isTyping)
              const Text("Đang trả lời...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: const Color(0xFF003580),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageItem(message);
                },
              ),
            ),
            if (_isTyping) _buildTypingIndicator(),
            _buildQuickReplies(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: const SizedBox(
            width: 30,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: Colors.grey,
              minHeight: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _quickReplies.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(_quickReplies[index]),
              onPressed: () => _sendMessage(text: _quickReplies[index]),
              backgroundColor: Colors.white,
              labelStyle: const TextStyle(color: Color(0xFF003580), fontSize: 13, fontWeight: FontWeight.w500),
              side: const BorderSide(color: Color(0xFF003580)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isMe ? const Color(0xFF003580) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isMe ? 16 : 0),
            bottomRight: Radius.circular(message.isMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMe ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        top: 10,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: "Nhập tin nhắn...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF003580),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
