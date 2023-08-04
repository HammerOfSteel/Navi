#Navi - Your Personal Smart Assistant
Navi is a smart assistant app, inspired by Navi the fairy from "The Legend of Zelda: Ocarina of Time". It provides users with local information, object recognition, text recognition and AI-based insights to assist in their daily life.

#Features
- Local Information Retrieval: Uses geolocation data to display information about nearby points of interest including detailed information like reviews, current crowdedness, and operating hours.

- Computer Vision: Recognizes objects and text in the user's surroundings using the phone's camera, providing more contextual information and helping users interact with their environment.

- Voice Recognition and Response: Accepts voice commands and responds with voice responses for hands-free interaction.

- AI Integration (ChatGPT): Leverages AI to generate insights from gathered data and provides more detailed responses to user queries.

- Background Functionality: Runs in the background, still providing updates and alerts based on changes in surroundings.

#Proposed Architecture
- User Interface (UI): The user interaction hub.

- Application Layer: Contains the Command Processor and Response Generator.

- Services Layer: Contains the Local Information Service, Computer Vision Service, and Voice Recognition Service.

- Data Layer: Manages communication with external APIs and internal data storage.

#Built With
- Flutter
- Google Maps API
- Google Cloud Vision API
- Google Speech-to-Text API
- OpenAI GPT-3

#Contributing
- Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.
