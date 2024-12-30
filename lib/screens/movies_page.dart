import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoviesPage extends StatefulWidget {
  final Function onBackPress;

  const MoviesPage({super.key, required this.onBackPress});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final List<String> genres = ["Drama", "Action", "Comedy"];
  final Map<String, List<String>> movies = {
    "Drama": List.generate(10, (index) => "Drama Movie ${index + 1}"),
    "Action": List.generate(10, (index) => "Action Movie ${index + 1}"),
    "Comedy": List.generate(10, (index) => "Comedy Movie ${index + 1}"),
  };

  late List<List<FocusNode>> focusNodes;
  late List<ScrollController> scrollControllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(
      genres.length,
      (sectionIndex) => List.generate(
          movies[genres[sectionIndex]]!.length, (_) => FocusNode()),
    );
    scrollControllers = List.generate(genres.length, (_) => ScrollController());
  }

  @override
  void dispose() {
    for (var nodes in focusNodes) {
      for (var node in nodes) {
        node.dispose();
      }
    }
    for (var controller in scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: genres.length,
        itemBuilder: (context, sectionIndex) {
          return _buildGenreSection(
            genres[sectionIndex],
            sectionIndex,
            movies[genres[sectionIndex]]!,
          );
        },
      ),
    );
  }

  Widget _buildGenreSection(
    String genre,
    int sectionIndex,
    List<String> movieList,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              genre,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              controller: scrollControllers[sectionIndex],
              scrollDirection: Axis.horizontal,
              itemCount: movieList.length,
              itemBuilder: (context, itemIndex) {
                return _buildMovieCard(
                  movieList[itemIndex],
                  sectionIndex,
                  itemIndex,
                  itemIndex == movieList.length - 1,
                  sectionIndex == genres.length - 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(
    String title,
    int sectionIndex,
    int itemIndex,
    bool isLastItem,
    bool isLastSection,
  ) {
    final focusNode = focusNodes[sectionIndex][itemIndex];
    final scrollController = scrollControllers[sectionIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (isFocused) {
          if (isFocused) {
            _scrollToCenter(scrollController, itemIndex);
            setState(() {});
          }
        },
        onKey: (node, event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              if (!isLastItem && !isLastSection) {}
              FocusScope.of(context)
                  .requestFocus(focusNodes[sectionIndex][itemIndex + 1]);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              if (itemIndex > 0) {}
              FocusScope.of(context)
                  .requestFocus(focusNodes[sectionIndex][itemIndex - 1]);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                !isLastSection) {
              FocusScope.of(context)
                  .requestFocus(focusNodes[sectionIndex + 1][itemIndex]);
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                sectionIndex > 0) {
              FocusScope.of(context)
                  .requestFocus(focusNodes[sectionIndex - 1][itemIndex]);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: focusNode.hasFocus ? Colors.red : Colors.transparent,
              width: 3,
            ),
            color: Colors.grey[800],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
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
      targetOffset.clamp(0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}
