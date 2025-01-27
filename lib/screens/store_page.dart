import 'package:flutter/material.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/storeitem.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  CommanMethods _cms = CommanMethods();
  StoreItemService _sis = StoreItemService();
  late Future<List<StoreItem>?> _allStoreItems;

  @override
  void initState(){
    super.initState();
    _allStoreItems = _sis.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommanMethods.backgroundcolor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(CommanMethods.appbarheight),
        child: appBarPoints(),
      ),
      drawer: CommanMethods.mainDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}
      ),
      body: storeItems(),
    );
  }

  FutureBuilder appBarPoints(){
    return FutureBuilder<int>(
      future: _cms.getPoints(), 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          default:
            if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            else if(snapshot.hasData){
              return CommanMethods.mainAppBar('Store - Points: ${snapshot.data}');
            }
            else{
              return Center(child: Text("Something went wrong"));
            }
        }
      }
    );
  }
  
  storeItems() {
    return FutureBuilder(
      future: _allStoreItems, 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          default:
            if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            else if(snapshot.hasData){
              return storeItemsList(snapshot);
            }
            else{
              return Center(child: Text("No Store Items, Add one!"));
            }
        }
      }
    );
  }
  
  storeItemsList(AsyncSnapshot<List<StoreItem>?> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
          child: Card(
            child: ListTile(
              title: Text(snapshot.data![index].name!),
              subtitle: Text('Cost: ${snapshot.data![index].cost!}'),
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  '/task',
                  arguments: snapshot.data![index]
                );
                setState((){
                  _allStoreItems = _sis.getItems();
                });
              },
              trailing: TextButton(
                onPressed: () {
                  setState(() {
                    uncompleted[index].taskcomplete();
                    _tProvider.updateTask(uncompleted[index]);
                    _cms.addPoints(uncompleted[index].points);
                  });
                },
                child: Text("BUY"),
              )
            ),
          ),
        );

      }
    );
  }
}