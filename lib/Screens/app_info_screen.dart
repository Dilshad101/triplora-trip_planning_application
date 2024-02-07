import 'package:flutter/material.dart';

class ScreenAppInfo extends StatelessWidget {
  const ScreenAppInfo({super.key});

  final String description =
      'Triplora is your ultimate travel companion that lets you plan and organize your trips with ease. Whether you\'re a solo adventurer or traveling with friends and family, Triplora helps you create memorable journeys and keeps your travel budget on track.';
  final String privacy =
      'Your privacy is our priority. Refer to our privacy policy to understand how we safeguard your personal information.';
  final String features1 =
      'Trip Planning Made Easy: Seamlessly plan your trips by adding destinations, start and end dates, and purposes for each adventure.';
  final String features2 =
      'Budget Management: Set your trip budget and track expenses effortlessly. Triplora ensures you stay within your budget while making the most of your experiences.';
  final String features3 =
      'Expense Tracker: Log all your expenses during the trip, including food, transportation, accommodation, and more. Keep a detailed record of your spending.';
  final String features4 =
      'Companions Management: Invite travel companions to your trips and manage their information for better coordination.';
  final String features5 =
      'Interactive Maps: Visualize your trip routes and destinations on interactive maps for a better understanding of your journey.';
  final String features6 =
      'Customizable Itinerary: Create a personalized itinerary for each day of your trip, including activities, places to visit, and dining options.';
  final String features7 =
      'Travel Memories: Capture and store precious moments with photo and note entries for each destination you explore.';
  final String features8 =
      'Dark Mode Support: Enjoy a pleasant browsing experience during nighttime or in low-light conditions.';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'App Info',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        children: [
          customColumn(
              title: 'App Name', subtitle: ' Triplora', context: context),
          customColumn(
              title: 'Description', subtitle: description, context: context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key features',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              features(features: features2),
              const SizedBox(height: 10),
              features(features: features3),
              const SizedBox(height: 10),
              features(features: features4),
              const SizedBox(height: 10),
              features(features: features5),
              const SizedBox(height: 10),
              features(features: features6),
              const SizedBox(height: 10),
              features(features: features7),
              const SizedBox(height: 10),
              features(features: features8)
            ],
          ),
          const SizedBox(height: 20),
          customColumn(
              title: 'Privacy Policy', subtitle: privacy, context: context),
        ],
      ),
    );
  }

  Row features({required String features}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 13,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 5),
        Expanded(
            child: Text(
          features,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.clip),
          textAlign: TextAlign.left,
        ))
      ],
    );
  }

  Column customColumn(
      {required String title,
      required String subtitle,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.clip),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
