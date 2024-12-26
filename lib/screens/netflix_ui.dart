import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetflixLikeUI extends StatefulWidget {
  const NetflixLikeUI({super.key});

  @override
  State<NetflixLikeUI> createState() => _NetflixLikeUIState();
}

class _NetflixLikeUIState extends State<NetflixLikeUI> {
  final FocusNode keyboardFocusNode = FocusNode();
  List<List<FocusNode>> focusNodes = [];
  late List<ScrollController> scrollControllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(
      3,
      (sectionIndex) => List.generate(
        dummyImages.length,
        (_) => FocusNode(),
      ),
    );

    scrollControllers = List.generate(3, (_) => ScrollController());
  }

  @override
  void dispose() {
    for (var section in focusNodes) {
      for (var node in section) {
        node.dispose();
      }
    }

    for (var controller in scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  final List<String> dummyImages = List.generate(
    10,
    (index) => "https://via.placeholder.com/150?text=Image+${index + 1}",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Netflix-like UI"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          _buildCategorySection(
            title: "Movies",
            sectionIndex: 0,
            imageUrls: dummyImages,
          ),
          _buildCategorySection(
            title: "Series",
            sectionIndex: 1,
            imageUrls: dummyImages,
          ),
          _buildCategorySection(
            title: "Subscription Plans",
            sectionIndex: 2,
            imageUrls: dummyImages,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required int sectionIndex,
    required List<String> imageUrls,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              controller: scrollControllers[sectionIndex],
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return _buildCard(
                  sectionIndex: sectionIndex,
                  itemIndex: index,
                  imageUrl: imageUrls[index],
                  isLastItem: index == imageUrls.length - 1,
                  isLastSection: sectionIndex == focusNodes.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required int sectionIndex,
    required int itemIndex,
    required String imageUrl,
    required bool isLastItem,
    required bool isLastSection,
  }) {
    final focusNode = focusNodes[sectionIndex][itemIndex];
    final scrollController = scrollControllers[sectionIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Focus(
        autofocus: true,
        focusNode: focusNode,
        onFocusChange: (isFocused) {
          _scrollToCenter(scrollController, itemIndex);
          setState(() {});
        },
        onKey: (node, event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              if (isLastItem && !isLastSection) {
                // commented as per requirement not to toggle to the next section when last item is focused
                // FocusScope.of(context)
                //     .requestFocus(focusNodes[sectionIndex + 1][0]);
                _scrollToCenter(scrollController, itemIndex + 1);
                return KeyEventResult.handled;
              }
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (itemIndex == 0 && sectionIndex > 0) {
                // commented as per requirement not to toggle to the next section when last item is focused

                // FocusScope.of(context)
                //     .requestFocus(focusNodes[sectionIndex - 1].last);
                _scrollToCenter(scrollController, itemIndex - 1);
                return KeyEventResult.handled;
              }
            }
          }
          return KeyEventResult.ignored;
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: focusNode.hasFocus ? Colors.red : Colors.transparent,
                width: 3,
              ),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  width: 100,
                  height: 150,
                  child: Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToCenter(ScrollController controller, int index) {
    const double cardWidth = 116;
    final double targetOffset = (index * cardWidth) -
        (MediaQuery.of(context).size.width / 2 - cardWidth / 2);

    controller.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
