import 'package:firebase_authentication/models/Item.dart';
import 'package:firebase_authentication/pages/itemDetailsPage.dart';
import 'package:firebase_authentication/pages/postAdPage.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:firebase_authentication/enum/categoryEnum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

void main() {
  runApp(const ExplorePage());
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Item> _items = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  final int _pageSize = 6;
  final int _loadMoreSize = 4;

  @override
  void initState() {
    super.initState();
    _loadInitialItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialItems() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance.collection('items').limit(_pageSize);
    final snapshot = await query.get();

    setState(() {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _items.addAll(snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
      }
      _isLoading = false;
    });
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || _lastDocument == null) return;

    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance.collection('items').startAfterDocument(_lastDocument!).limit(_loadMoreSize);
    final snapshot = await query.get();

    setState(() {
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _items.addAll(snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
      } else {
        _lastDocument = null;  // No more items to load
      }
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading) {
      _loadMoreItems();  // Load more items when reaching the end
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple.lk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search something..',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 39.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: Categoryenum.values.length,
                itemBuilder: (context, index) {
                  final category = Categoryenum.values[index];
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 206, 223, 253),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        category.displayTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: _items.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final item = _items[index];
                  return GestureDetector(
                    onTap: () async {
                      // Assuming 'item' contains the ID for the item you want to fetch.
                      String itemId = item.id!;

                      // Show a loading GIF
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      try {
                        // Fetch the item from Firebase using the itemId.
                        DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
                            .collection('items') // Replace 'items' with your Firestore collection name
                            .doc(itemId) // Use the item ID to fetch the document
                            .get();

                        // Check if the item exists
                        if (itemSnapshot.exists) {
                          // Retrieve the item data from the snapshot
                          Item fullItem = Item.fromDocumentSnapshot(itemSnapshot);

                          // Dismiss the loading GIF
                          Navigator.of(context, rootNavigator: true).pop();
                      

                          // Navigate to ProductDetailScreen, passing the full item data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(item: fullItem),
                            ),
                          );
                        } else {
                          // Dismiss the loading GIF
                          Navigator.of(context, rootNavigator: true).pop();
                              

                          // Handle the case where the item does not exist
                          print('Item not found');
                        }
                      } catch (e) {
                        // Dismiss the loading GIF
                        Navigator.of(context, rootNavigator: true).pop();
                        

                        // Handle any errors that occur during the fetch operation
                        print('Error fetching item: $e');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: CachedNetworkImage(imageUrl: item.itemImageURL!.isNotEmpty
                                    ? item.itemImageURL![0]
                                    : 'https://via.placeholder.com/150',
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${item.itemPrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16.0),
                                    const SizedBox(width: 4.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.views.toString(),
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            item.itemDescription!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const Postadpage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        label: const Text('Post ad'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

