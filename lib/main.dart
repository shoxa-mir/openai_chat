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
        primarySwatch: Colors.grey,
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

  @override
  void initState() {
    super.initState();
    openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
        isLog: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open AI Chatbot "),
      ),
      body: Center(
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
                        color: Colors.grey[100],
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

                    final request = CompleteText(
                        prompt: textEditingController.text,
                        model: Model.TextDavinci3,
                        maxTokens: 200);
                    // final request = CompleteText(
                    //     prompt: translateToJapanese(
                    //         word: textEditingController.text),
                    //     model: Model.TextDavinci3,
                    //     maxTokens: 200);
                    final response =
                        await openAI.onCompletion(request: request);
                    ChatMessage msg2 = ChatMessage(
                        user: openAiUser,
                        text: response!.choices.first.text,
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
                    textEditingController.clear();
                  },
                  child: Icon(Icons.send),
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
    );
  }
}
