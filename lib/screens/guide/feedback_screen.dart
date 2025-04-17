import 'package:base/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSending = false;

  Future<void> submitFeedback() async {
    setState(() => _isSending = true);
    final response = await http.post(
      Uri.parse('https://formsubmit.co/ajax/${Constants.APP_EMAIL}'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'message': _feedbackController.text,
        'subject': 'Góp ý từ ứng dụng',
        'name': 'Người dùng Flutter',
      },
    );

    setState(() => _isSending = false);
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gửi thành công!')),
      );
      _feedbackController.clear();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gửi góp ý')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Xin chào, \nTôi rất vui khi bạn đã sử dụng ứng dụng của chúng tôi. \n\nTôi rất mong nhận được những góp ý của bạn để ứng dụng ngày càng hoàn thiện hơn.',
                style: TextStyle(fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _feedbackController,
                style: const TextStyle(fontWeight: FontWeight.normal),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Bạn nghĩ gì về app?',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Nhập vài dòng nhé bạn ơi!' : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isSending
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            submitFeedback();
                          }
                        },
                  icon: const Icon(Icons.send),
                  label: Text(_isSending ? 'Đang gửi...' : 'Gửi góp ý'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
