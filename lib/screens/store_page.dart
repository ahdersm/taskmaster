import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/storeitem.dart';

final _formKey = GlobalKey<FormState>();

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  CommanMethods _cms = CommanMethods();
  StoreItemsProvider _sis = StoreItemsProvider();
  late Future<List<StoreItem>?> _allStoreItems;

  String? _newname;
  String? _newdescription;
  int? _newcost;

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
        onPressed: () {
          showDialog(
            context: context,
            builder: (context){
              return addItemDialog();
            }
          );
        }
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

  Dialog addItemDialog(){
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,
        child: StatefulBuilder(
          builder: (context, setStateForDialog) {
            return Column(
              children: [
                Text('Add Store Item'),
                storeItemName(),
                storeItemDescription(),
                storeItemCost(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    saveButton(),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close)
                    )
                  ],
                ),
              ],
            );
          }
        )
      ),
    );
  }
  
  TextFormField storeItemName() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Store Item Name",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a store item name';
        }
        return null;
      },
      onSaved: (value) {
        _newname = value!;
      },
    );
  }
  
  TextFormField storeItemDescription() {
    return TextFormField(
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Store Item Description",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a store item name';
        }
        return null;
      },
      onSaved: (value) {
        _newdescription = value!;
      },
    );
  }
  
  TextFormField storeItemCost() {
    return TextFormField(
      initialValue: "0",
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: "Task Point(s)",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a task name';
        }
        return null;
      },
      onSaved: (value) {
        _newcost = int.parse(value!);
      },
    );
  }
  
  TextButton saveButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge, 
      ),
      onPressed: (){
        setState(() {
          if (_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            
            StoreItem newstoreitem = StoreItem();
            newstoreitem.newstoreitem(
              name: _newname,
              description: _newdescription,
              cost: _newcost,
            );
            _sis.createItem(newstoreitem);
            _allStoreItems = _sis.getItems();
            Navigator.of(context).pop();
            _newname = '';
            _newdescription = '';
            _newcost = 0;
          }
        });
      },
      child: const Text('Create'),
    );
  }
}