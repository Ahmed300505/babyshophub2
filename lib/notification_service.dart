import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';
  static const String _userId = 'QN8ws9xhffWR1BdfJ'; // Replace with your EmailJS user ID
  static const String _templateId = 'template_ntejbq9'; // Replace with your EmailJS template ID
  static const String _serviceId = 'service_8db8d1c'; // Replace with your EmailJS service ID

  static Future<void> sendOrderStatusEmail({
    required String toEmail,
    required String subject,
    required Map<String, dynamic> templateData,
  }) async {
    final response = await http.post(
      Uri.parse(_emailJsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$_userId:'))
      },
      body: jsonEncode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _userId,
        'template_params': {
          'to_email': toEmail,
          'subject': subject,
          ...templateData,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
