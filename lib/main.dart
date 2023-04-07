import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //     primary: Color.fromARGB(255, 114, 169, 163),
        //     secondary: Colors.amber),
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurpleAccent,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var results = "results...";
  late OpenAI openAI;
  TextEditingController textEditingController = TextEditingController();
  List<ChatMessage> messages = [];
  ChatUser user = ChatUser(id: "1", firstName: "Shoxa", lastName: "Mir");
  ChatUser openAiUser =
      ChatUser(id: "2", firstName: "CHATGPT", lastName: "OpenAi");

  void _chatGpt3Example(String textInput) async {
    final request = ChatCompleteText(messages: [
      Map.of({"role": "user", "content": "${textInput}"})
    ], maxToken: 200, model: ChatModel.ChatGptTurbo0301Model);

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message.content}");
    }
    setState(() {
      results = response.choices.first.message.content;
    });
  }

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
        token: "openai-api-key",
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 15)),
        isLog: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open AI Chatbot "),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: DashChat(
                  currentUser: user,
                  onSend: (ChatMessage m) {
                    setState(() {
                      messages.insert(0, m);
                    });
                  },
                  messages: messages,
                  readOnly: true,
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type your message here..."),
                            ),
                          ))),
                  ElevatedButton(
                    onPressed: () async {
                      ChatMessage msg = ChatMessage(
                          text: textEditingController.text,
                          user: user,
                          createdAt: DateTime.now());
                      setState(() {
                        messages.insert(0, msg);
                      });

                      // final request = ChatCompleteText(messages: [
                      //   Map.of({"role": "user", "content": 'Hello!'})
                      // ], maxToken: 200, model: ChatModel.ChatGptTurbo0301Model);

                      // final response =
                      //     await openAI.onChatCompletion(request: request);
                      // for (var element in response!.choices) {
                      //   print("data -> ${element.message.content}");
                      // }
                      // final request = CompleteText(
                      //     prompt: textEditingController.text,
                      //     model: Model.values.first,
                      //     maxTokens: 50);
                      // final models = await openAI.listEngine();
                      // print(models.data);
                      _chatGpt3Example(textEditingController.text);
                      textEditingController.clear();
                      // final request = CompleteText(
                      //     prompt: translateToJapanese(
                      //         word: textEditingController.text),
                      //     model: Model.TextDavinci3,
                      //     maxTokens: 200);
                      // final response =
                      //     await openAI.onCompletion(request: request);
                      ChatMessage msg2 = ChatMessage(
                          replyTo: msg,
                          user: openAiUser,
                          text: results,
                          quickReplies: [],
                          createdAt: DateTime.now());
                      // results = response!.choices.first.text;
                      setState(() {
                        messages.insert(0, msg2);
                        // results;
                      });
                      // final request = GenerateImage(
                      //     textEditingController.text, 1,
                      //     size: ImageSize.size512, responseFormat: Format.url);
                      // ;

                      // final res = openAI.generateImage(request);
                      // res.then((value) =>
                      //     print("img url :${value!.data!.first!.url}"));
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.deepPurple,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                        backgroundColor: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
