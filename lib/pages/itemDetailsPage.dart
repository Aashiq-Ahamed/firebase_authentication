import 'package:firebase_authentication/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/components/expandableReviews.dart';
import 'package:firebase_authentication/components/detailChip.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images Section
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.itemImageURL!.length, // Assume there are 5 images
                itemBuilder: (context, index) {
                  final imageUrl = item.itemImageURL![index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(
                            imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 5.0),

            Center(
              child: Text(
                '${item.itemImageURL!.length} ${item.itemImageURL!.length > 1 ? 'images' : 'image'} found',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            const SizedBox(height: 5.0),

            // Details Section
            Wrap(
              spacing: 25.0,
              runSpacing: 8.0,
              children: [
                DetailChip(label: '', value: item.itemPrice.toString(), icon: 
                const Icon(
                  Icons.monetization_on, // Use any icon you like
                  size: 18.0,
                  color: Colors.grey,
                ), fontSize: 30.0,),

                const SizedBox(width: 50,),

                Row(
                  mainAxisSize: MainAxisSize.min, // Ensures the Row only takes as much space as needed
                  children: [
                    const Icon(
                      Icons.calendar_today, // Choose an icon (e.g., thumbs up or heart)
                      color: Colors.grey, // Customize icon color
                      size: 16.0, // Customize icon size
                    ),
                    const SizedBox(width: 4.0), // Add some spacing between icon and text
                    Text(
                      '${item.dateTime}',
                      style: const TextStyle(
                        color: Colors.black, // Customize text color
                        fontSize: 12.0, // Customize text size
                      ),
                    ),
                  ],
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min, // Ensures the Row only takes as much space as needed
                  children: [
                    const Icon(
                      Icons.location_on, // Choose an icon (e.g., thumbs up or heart)
                      color: Colors.grey, // Customize icon color
                      size: 16.0, // Customize icon size
                    ),
                    const SizedBox(width: 4.0), // Add some spacing between icon and text
                    Text(
                      item.itemLocation!,
                      style: const TextStyle(
                        color: Colors.black, // Customize text color
                        fontSize: 12.0, // Customize text size
                      ),
                    ),
                  ],
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min, // Ensures the Row only takes as much space as needed
                  children: [
                    const Icon(
                      Icons.thumb_up, // Choose an icon (e.g., thumbs up or heart)
                      color: Colors.grey, // Customize icon color
                      size: 16.0, // Customize icon size
                    ),
                    const SizedBox(width: 4.0), // Add some spacing between icon and text
                    Text(
                      '${item.likes} Likes',
                      style: const TextStyle(
                        color: Colors.black, // Customize text color
                        fontSize: 12.0, // Customize text size
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min, // Ensures the Row only takes as much space as needed
                  children: [
                    const Icon(
                      Icons.visibility, // Choose an icon (e.g., thumbs up or heart)
                      color: Colors.grey, // Customize icon color
                      size: 16.0, // Customize icon size
                    ),
                    const SizedBox(width: 4.0), // Add some spacing between icon and text
                    Text(
                      '${item.views} Views',
                      style: const TextStyle(
                        color: Colors.black, // Customize text color
                        fontSize: 12.0, // Customize text size
                      ),
                    ),
                  ],
                )

              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              item.itemName!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
              // style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                const Icon(
                  Icons.verified_user
                ),
                Text(
                  item.user!.name,
                  // style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              item.itemDescription!,
              // style: Theme.of(context).textTheme.bodyText2,
            ),

            const Divider(height: 32.0),

            // Reviews Section
            ExpandableReviews(reviews: item.reviews!,),

            const Divider(height: 32.0),

            // Related Items Section
            const Text(
              'Related Items',
              // style: TextStyle(color: Color.black54,
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 200, // Height for related items list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Assume there are 5 related items
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image for related item
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://example.com/related_image_$index.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Item Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Description of the item goes here...',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              // const SizedBox(height: 4.0),
                              const Text(
                                '\$100',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
          ],
        ),
      ),
    );
  }
}
