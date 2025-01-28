import 'package:flutter/material.dart';

class AnimatedListTest extends StatelessWidget {
  AnimatedListTest({super.key});

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: AnimatedList(
          initialItemCount: 5,
          key: _listKey,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: AnimatedListItem(
                 
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({super.key, required this.index});

  final int index;
  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(widget.index.toString()),
          SizedBox(width: 60, child: TextField(controller: controller)),
          IconButton(
            onPressed: () {
              AnimatedList.of(context).removeItem(widget.index,
                  (context, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: AnimatedListItem(
                    index: widget.index,
                  ),
                );
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
