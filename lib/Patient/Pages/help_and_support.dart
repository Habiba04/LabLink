import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'LabLink@gmail.com',
      queryParameters: {'subject': 'LabLink App Support Request'},
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      // Open Gmail directly
      const gmailUrl =
          'https://mail.google.com/mail/?view=cm&fs=1&to=LabLink@gmail.com&su=LabLink%20App%20Support%20Request';
      if (await canLaunchUrl(Uri.parse(gmailUrl))) {
        await launchUrl(
          Uri.parse(gmailUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('No email app available.');
      }
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+201234567890');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('error opening phone app');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,

        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B8DB), Color(0xFF00BBA7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: width * 0.15,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We’re here to assist you anytime.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '📘 Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ExpansionTile(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              leading: const Icon(
                Icons.question_answer_outlined,
                color: Color(0xFF00B8DB),
              ),
              title: const Text('How do I book a lab appointment?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Go to the Labs section, select your preferred lab, choose a time slot, and confirm your booking.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              leading: const Icon(
                Icons.question_answer_outlined,
                color: Color(0xFF00B8DB),
              ),
              title: const Text('Can I edit my personal information?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Yes, you can edit your name, phone, and address from the Profile > Edit Personal Information section.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              collapsedShape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
              ),
              leading: const Icon(
                Icons.question_answer_outlined,
                color: Color(0xFF00B8DB),
              ),
              title: const Text('How do I contact the lab for inquiries?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You can contact the lab directly from the lab details page where contact info is displayed.',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            const Text(
              '📞 Contact Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(
                Icons.email_outlined,
                color: Color(0xFF00B8DB),
              ),
              title: const Text('Email us'),
              subtitle: const Text('support@lablink.com'),
              onTap: _launchEmail,
            ),
            ListTile(
              leading: const Icon(
                Icons.phone_outlined,
                color: Color(0xFF00B8DB),
              ),
              title: const Text('Call us'),
              subtitle: const Text('+20 123 456 7890'),
              onTap: _launchPhone,
            ),
          ],
        ),
      ),
    );
  }
}
