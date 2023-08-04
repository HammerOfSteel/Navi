import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';

// Define the token at the top of your file
const kToken = 'XX';

class VoiceCommandScreen extends StatefulWidget {
  const VoiceCommandScreen({Key? key}) : super(key: key);

  @override
  State<VoiceCommandScreen> createState() => _VoiceCommandScreenState();
}

class _VoiceCommandScreenState extends State<VoiceCommandScreen> {
  late OpenAI openAI;
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
 
  String _currentLocale = 'en_US';
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';

  @override
  void initState() {
    super.initState();

    // Replace kToken with your actual token
    openAI = OpenAI.instance.build(
        token: kToken,
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);

    // speech recognition init
    initSpeechState();
  }

  void initSpeechState() async {
    var speechAvailable = await _speech.initialize();
    if(speechAvailable) {
      setState(() => _speechRecognitionAvailable = speechAvailable);
    }

    var systemLocale = await _speech.systemLocale();
    setState(() => _currentLocale = systemLocale!.name!);
  }

  void _startListening() {
    _speech.listen(
      onResult: (val) => setState(() {
        _isListening = val.finalResult;
        transcription = val.recognizedWords;
        if(val.finalResult) _getChatGPTResponse(transcription);
      }),
      localeId: _currentLocale,
    );
  }

  void _stopListening() {
    _speech.stop().then((result) => setState(() => _isListening = false));
  }

  void _getChatGPTResponse(String inputText) async {
    var rng = new Random();
    var responses = ["Hello!", "Hey!", "Listen!", "Look!", "Watch out!"];

    if (inputText.toLowerCase() == "navi") {
        int randomNumber = Random().nextInt(5);  // generates a random number between 0 and 4
        switch(randomNumber) {
        case 0:
            _assetsAudioPlayer.open(Audio('assets/audio/hello.mp3'));
            break;
        case 1:
            _assetsAudioPlayer.open(Audio('assets/audio/listen.mp3'));
            break;
        case 2:
            _assetsAudioPlayer.open(Audio('assets/audio/look.mp3'));
            break;
        case 3:
            _assetsAudioPlayer.open(Audio('assets/audio/watch_out.mp3'));
            break;
        case 4:
            _assetsAudioPlayer.open(Audio('assets/audio/hey.mp3'));
            break;
        }
    } else if(inputText.toLowerCase() == "hey navi") {
        _speakText(responses[rng.nextInt(responses.length)]);
    } else if(inputText.toLowerCase() == "hello") {
        _assetsAudioPlayer.open(Audio('assets/audio/hello.mp3'));
    } else if(inputText.toLowerCase() == "how are you") {
        _speakText("I'm doing great, thank you! How can I assist you today?");
    } else {
      final request = ChatCompleteText(
          messages: [
            Messages(
                role: Role.user,
                content: inputText,
            ),
          ],
          maxToken: 200,
          model: GptTurboChatModel());  // replace "Gpt4ChatModel()" with "GptTurboChatModel()"

      try {
        ChatCTResponse? response = await openAI.onChatCompletion(request: request);
        debugPrint("$response");
        if(response != null && response.choices.isNotEmpty && response.choices[0].message != null) {
          _speakText(response.choices[0].message!.content);
        }
      } catch (e) {
        if(e is Exception && e.toString().contains('429')) {  // if exception message contains '429'
          // Here you could give a standard response when quota is exceeded.
          _speakText("Sorry, I have reached my maximum thinking capacity for today. Please try again later.");
        } else {
          // Generic exception handling.
          _speakText("Apologies, I encountered an issue. Please try again later.");
        }
      }
    }
  }

  void _speakText(String text) async {
    List<dynamic> voices = await _tts.getVoices;
    print(voices);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/images/navi.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                child: Text('Listening: $_isListening', style: TextStyle(color: Colors.white)),
              ),
              Container(
                child: Text('$_currentLocale', style: TextStyle(color: Colors.white)),
              ),
              Container(
                child: Text(transcription, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        onPressed: _speechRecognitionAvailable && !_isListening
            ? () => _startListening()
            : () => _stopListening(),
      ),
    );
  }
}
