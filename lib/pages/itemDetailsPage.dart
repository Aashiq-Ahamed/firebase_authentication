import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_authentication/models/Item.dart';
import 'package:firebase_authentication/pages/fullScreenImageViewer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/components/expandableReviews.dart';
import 'package:firebase_authentication/components/detailChip.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.item});

  final Item item;

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false; // Track whether the item is marked as favorite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border, // Filled or unfilled star
              color: isFavorite ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 0, 0, 0), // Highlight color when selected
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite; // Toggle favorite status
              });
              if (isFavorite) {
                // Add logic to mark as favorite (e.g., save to database)
              } else {
                // Add logic to unmark as favorite
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images Section
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.item.itemImageURL!.length,
                itemBuilder: (context, index) {
                  final imageUrl = widget.item.itemImageURL![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullscreenImageViewer(
                            imageUrls: widget.item.itemImageURL!,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: widget.item.itemImageURL!.length == 1
                          ? 400
                          : widget.item.itemImageURL!.length == 2
                              ? 200
                              : 200,
                      margin: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: SpinKitRing(
                                color: Colors.grey[500]!,
                                lineWidth: 4.0,
                                size: 30.0,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5.0),

            Center(
              child: Text(
                '${widget.item.itemImageURL!.length} ${widget.item.itemImageURL!.length > 1 ? 'images' : 'image'} found',
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
                DetailChip(
                  label: '',
                  value: widget.item.itemPrice.toString(),
                  icon: const Icon(
                    Icons.monetization_on, // Use any icon you like
                    size: 18.0,
                    color: Colors.grey,
                  ),
                  fontSize: 30.0,
                ),

                const SizedBox(width: 50,),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.item.dateTime}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                    if (widget.item.isNegotiable!) ...[
                      const SizedBox(width: 8.0),
                      const Text(
                        'Negotiable',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      widget.item.itemLocation!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite ,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.item.likes} Likes',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.item.views} Views',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )

              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.item.itemName!,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                const Icon(
                  Icons.verified_user
                ),
                Text(
                  widget.item.user!.name,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.item.itemDescription!,
            ),

            const Divider(height: 32.0),

            // Reviews Section
            ExpandableReviews(reviews: widget.item.reviews!),

            const Divider(height: 32.0),

            // Related Items Section
            const Text(
              'Related Items',
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
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
