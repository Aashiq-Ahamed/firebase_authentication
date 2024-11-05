
import 'package:flutter/material.dart';

class ExpandableReviews extends StatefulWidget {
  const ExpandableReviews({super.key, required this.reviews});

  final List<String> reviews;

  @override
  ExpandableReviewsState createState() {
    return ExpandableReviewsState();
  }
}

class ExpandableReviewsState extends State<ExpandableReviews> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                // style: Theme.of(context).textTheme.headline6,
              ),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.reviews.asMap().entries.map((entry) {
                int index = entry.key;
                String review = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Review ${index + 1}: $review',
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
            )
          ),
      ],
    );
  }
}