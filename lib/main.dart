import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Block {
  final String name;
  final String id;

  Block({required this.name, required this.id});
}

class BlockTracker {
  Map<String, int> blockCounts = {};
  List<int> previousBlockCounts = [];
  List<Block> availableBlocks = [
   //Code to select Block
  ];

  void addBlock(Block block) {
    final blockId = block.id;
    blockCounts[blockId] = (blockCounts[blockId] ?? 0) + 1;
  }

  void saveBlockCounts() {
    previousBlockCounts.add(blockCounts.values.reduce((a, b) => a + b));
  }
}

class MyApp extends StatelessWidget {
  final BlockTracker blockTracker = BlockTracker();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Minecraft Block Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<Block>(
                value: null,
                items: blockTracker.availableBlocks.map((Block block) {
                  return DropdownMenuItem<Block>(
                    value: block,
                    child: Text(block.name),
                  );
                }).toList(),
                onChanged: (Block? selectedBlock) {
                  if (selectedBlock != null) {
                    blockTracker.addBlock(selectedBlock);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${selectedBlock.name} added!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Current Block Counts:',
                style: TextStyle(fontSize: 18),
              ),
              for (var entry in blockTracker.blockCounts.entries)
                Text('${entry.key}: ${entry.value}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  blockTracker.saveBlockCounts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Block counts saved!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text('Save Block Counts'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Previous Block Counts'),
                        content: Column(
                          children: [
                            for (var count in blockTracker.previousBlockCounts)
                              Text('Count: $count'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Show Previous Counts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
