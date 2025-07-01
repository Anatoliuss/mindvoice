# MindVoice

MindVoice is an MVP Flutter app that connects to an ESP32-C3 device via Bluetooth Low Energy (BLE), receives voice messages, and uses OpenAI to analyze and summarize them, providing mental health advice.

## Features
- **BLE Connection:** Scan for and connect to an ESP32-C3 device.
- **Voice Message Reception:** Receive and store audio messages sent from the ESP32-C3.
- **Audio Playback:** Play back received voAice messages in-app.
- **AI Transcription:** Transcribe audio messages using OpenAI Whisper.
- **AI Analysis:** Summarize messages and generate mental health advice using OpenAI GPT.
- **Message History:** View all received messages, their transcriptions, summaries, and advice.

## Requirements
- Flutter 3.16 or newer
- An ESP32-C3 device programmed to send audio data over BLE (with known service and characteristic UUIDs)
- An OpenAI API key (for Whisper and GPT)

## Setup Instructions

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Anatoliuss/mindvoice.git
   cd mindvoice/mindvoice
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Configure OpenAI API Key:**
   - Open `lib/core/openai_service.dart`.
   - Replace the placeholder `sk-REPLACE_ME` with your OpenAI API key.

4. **Set BLE UUIDs:**
   - Open `lib/core/ble_service.dart`.
   - Replace the placeholder `audioServiceUuid` and `audioCharacteristicUuid` with your ESP32's actual UUIDs.

5. **Run the app:**
   ```sh
   flutter run
   ```


## Usage Guide
1. **Connect to ESP32:** Tap "Connect to ESP32 Device" and select your device from the list.
2. **Receive Audio:** When the ESP32 sends audio, it will be saved and appear in the message history.
3. **Playback:** Tap the play button to listen to a message.
4. **Transcribe:** Tap the text icon to transcribe the audio using OpenAI Whisper.
5. **Summarize & Advise:** Tap the psychology icon to get a summary and mental health advice from OpenAI GPT.

