import 'package:flutter/material.dart';

class ScreenPrivacyPolicy extends StatelessWidget {
  const ScreenPrivacyPolicy({super.key});

  final String policy =
      '''  We created The app 'Traveler' as a Free app. This SERVICE is provided at no cost and is intended for use as is This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. 
    If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. we will not use or share your information with anyone except as described in this Privacy Policy.
    The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Traveler unless otherwise defined in this Privacy Policy. ''';
  final String information =
      ''' For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information that we request will be retained on your device and is not collected by us in any way.''';
  final String security =
      'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and We cannot guarantee its absolute security.';
  final String changes =
      '''We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.''';
  final String contacts =
      'Our mobile application requires access to your contacts to provide you with the ability to easily access and communicate with your contacts. We will only access and use the contact information for the intended purpose and functionality of the application. We do not collect or store your contact information on our servers.';
  final String camara =
      'Our mobile application may require access to your device\'s camera to provide certain features or functionality. We will only access and use the camera for the intended purposes, such as capturing photos or videos within the application. We do not collect or store any media captured through the camera on our servers without your explicit consent.';
  final String storage =
      'Our mobile application requires access to your device\'s storage to store and retrieve data necessary for the application\'s functionality. We may collect and store data files, such as user preferences or locally cached content, on your device\'s storage. We do not access, read, or transfer any personal or sensitive information stored on your device without your consent.';
  final String accountdelete =
      'All your datas are stored in your device itself, so by clicking the \'Reset\' button in the \'Settings\' screen or by Uninstalling the App you can delete all your datas from the app and storage.';
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SizedBox(
        height: deviceHeight,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          children: [
            customText(
              headline: 'Privacy Policy',
              content: policy,
              context: context,
            ),
            customText(
                headline: 'Information Collection and Use',
                content: information,
                context: context),
            customText(
              headline: 'User Contacts',
              content: contacts,
              context: context,
            ),
            customText(
              headline: 'Camara',
              content: camara,
              context: context,
            ),
            customText(
              headline: 'Read/Write Storage',
              content: storage,
              context: context,
            ),
            customText(
                headline: 'Account Deletion',
                content: accountdelete,
                context: context),
            customText(
              headline: 'Security',
              content: security,
              context: context,
            ),
            customText(
                headline: 'Changes to This Privacy Policy ',
                content: changes,
                context: context),
            const Divider(
              thickness: 1,
              height: 40,
            ),
            Text(
              'This policy is effective as of 2023-07-16',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                wordSpacing: 2,
              ),
            ),
            const Divider(
              thickness: 1,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Column customText(
      {required String headline,
      required String content,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: headStyle(context),
        ),
        const SizedBox(height: 15),
        Text(
          content,
          textAlign: TextAlign.justify,
          style: contentStyle(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  TextStyle contentStyle() {
    return TextStyle(
      fontSize: 14,
      color: Colors.grey.shade600,
      wordSpacing: 2,
    );
  }

  TextStyle headStyle(context) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}
