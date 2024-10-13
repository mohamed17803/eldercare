import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'AC1fb95f9dd2631754f626ab7c6eddf041'; // Replace with your Twilio account SID
  final String authToken = '635d0b7d836dc19b801d60024631eee3'; // Replace with your Twilio auth token
  final String twilioNumber = '+19093513045'; // Your Twilio phone number

  Future<void> sendEmergencySMS(String toNumber, String message) async {
    final url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final credentials = '$accountSid:$authToken';
    final basicAuth = 'Basic ${base64Encode(utf8.encode(credentials))}';

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': basicAuth},
        body: {
          'From': twilioNumber,
          'To': toNumber,
          'Body': message,
        },
      );

      if (response.statusCode == 201) {
        print('SMS sent successfully');
      } else {
        print('Failed to send SMS: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending SMS: $e');
    }
  }

  Future<void> makeEmergencyCall(String toNumber) async {
    final url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Calls.json');
    final credentials = '$accountSid:$authToken';
    final basicAuth = 'Basic ${base64Encode(utf8.encode(credentials))}';

    try {
      final response = await http.post(
        url,
        headers: {'Authorization': basicAuth},
        body: {
          'From': twilioNumber,
          'To': toNumber,
          'Url': 'http://demo.twilio.com/docs/voice.xml', // Twilio-hosted URL for the call
        },
      );

      if (response.statusCode == 201) {
        print('Call placed successfully');
      } else {
        print('Failed to place call: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error making call: $e');
    }
  }
}
