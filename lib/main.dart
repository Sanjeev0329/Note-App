import 'package:flutter/material.dart';
import 'package:note_apk/data/local/db_helper.dart';
import 'package:note_apk/new_notes.dart';
/*import 'package:note_apk/new_notes.dart';*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override

  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
/*  var errorMsg ="";*/
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  List<Map<String,dynamic>> allNotes =[];
  DBHelper? dbRef;

  @override
  void initState(){
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }
  void getNotes() async{
    allNotes = await dbRef!.getAllNotes();
    setState(() {

    });

  }
 //var time = DateTime.now();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 100,
        title: Text("Notes",style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500,fontSize: 30),),
        //leading: Text("Edit",style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500,fontSize: 30)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextButton(
              onPressed: (){
                print("Text Button clicked!");
              },
                child:Text("Edit",style: TextStyle(color: Colors.white,fontWeight:FontWeight.w400,fontSize: 25)),)
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(onPressed: (){

            },
                icon:Icon(Icons.search,size: 50,color: Colors.white,) ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(onPressed: (){},
                icon:Icon(Icons.more_horiz,size: 50,color: Colors.white,)),
          )
        ],
      ),
      body:
        ListView.builder(
            itemCount: allNotes.length,
            itemBuilder: (_,index){
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 100,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade700,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          title.text = allNotes[index][DBHelper.COLUMN_NOTE_TITLE]; // ✅ Set title
                          desc.text = allNotes[index][DBHelper.COLUMN_NOTE_DESC];   // ✅ Set description
                          /*Navigator.push(context, MaterialPageRoute(builder: (context)=>NewNotes(
                            nTitle : allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                            nDescription: allNotes[index][DBHelper.COLUMN_NOTE_DESC],
                            sNo: allNotes[index][DBHelper.COLUMN_NOTE_SNO]
                          )));*/

                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              title.text  = allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                              desc.text   = allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                              return getbottonsheetWidget(isUpdated: true , sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                            },
                          );

                      },
                      onLongPress: (){
                        showModalBottomSheet(context: context, builder: (context){
                          return Container(
                            color: Colors.grey.shade900,
                            width: double.infinity,
                            height: 100,
                            child: IconButton(
                                onPressed:() async{
                                bool check = await dbRef!.deleteNote(sno: allNotes[index][DBHelper.COLUMN_NOTE_SNO]);
                                if(check){
                                  getNotes();
                                }
                                  
                                },
                                icon:Icon(Icons.delete,color: Colors.red,size: 50,)),
                          );
                        });

                      },
                      child: ListTile(
                        //leading:Text('${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}',style: TextStyle(fontSize: 18.5,color: Colors.white)) ,
                        title:Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE],style: TextStyle(fontSize: 18.5,color: Colors.white,fontWeight: FontWeight.w500),),
                        subtitle:Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC],style: TextStyle(fontSize: 16,color: Colors.white) ,

                      ),
                      ),
                    ),
                ),
                                )
              );
            }
        ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(context: context, builder:(context){
          title.clear();
          desc.clear();
          return getbottonsheetWidget(isUpdated: false );
        });
      },
      child: Icon(Icons.add,size: 40,),),
    );
  }
  Widget getbottonsheetWidget({bool isUpdated = false , int sno =0}){
   /* title.clear();
    desc.clear();*/
    return Container(
      color: Colors.grey.shade800,
      height: 450,
      child: Column(
        children: [
          Text(isUpdated ? "Update Note" :"Add Notes",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.grey),),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: title,
              style:TextStyle(color: Colors.white,fontSize: 30),
              decoration: InputDecoration(
                  label: Text("Title",style: TextStyle(color: Colors.grey,fontSize:20),),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(11)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                  ),
                  hintText: "   Input title",
                  hintStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color:Colors.grey)

              ),


            ),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              maxLines: 4,
              controller: desc,
              style:TextStyle(color: Colors.white,fontSize: 24),
              decoration: InputDecoration(
                label: Text("Desc",style: TextStyle(color: Colors.grey,fontSize: 20)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: BorderSide(width: 2),


                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11)
                ),
                hintText: "Enter your notes here...",
                hintStyle: TextStyle(color: Colors.grey),

              ),

            ),
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Expanded(child: OutlinedButton(
                  onPressed: ()async{
                    var Stitle = title.text;
                    var SDec = desc.text;
                    if(Stitle.isNotEmpty && SDec.isNotEmpty){
                      bool check = isUpdated? await dbRef!.updateNote(mTitle: Stitle, mDesc: SDec, sno: sno) : await dbRef!.addNote(mTitle: Stitle, mDesc: SDec);
                      if(check){
                        getNotes();
                      }

                      title.clear();
                      desc.clear();
                      Navigator.pop(context);
                      setState(() {

                      });

                    }
                  },
                  child:Text(isUpdated ? "Update" :"Add"))),
              SizedBox(width: 15,),
              Expanded(child: OutlinedButton(onPressed: (){
                Navigator.pop(context);
              },
                  child: Text("Cancel")))
            ],
          )
        ],
      ),
    );
  }
}
