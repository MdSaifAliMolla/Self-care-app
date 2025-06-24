
# 🌿 Self-Care app

An open-source, gamified health app to build better habits through intelligent reminders, achievements, virtual pets, and social challenges — all wrapped in a minimalist, cozy UI.  

> 💡 Built using Flutter, Firebase, and Hive — inspired by Duolingo, Finch, and WaterDo.

---

## ✨ Features

- **💧 Smart Reminders**
  - Hydration alerts based on temperature & physical activity.
  - Posture correction using accelerometer + gyroscope.
  - Step goals and nudges via health data integration.
  - Breathing & meditation reminders based on mood/stress.

- **🎮 Gamification & Social**
  - Earn coins, unlock achievement badges, and build streaks.
  - View leaderboards for global and friend stats.
  - Create and accept friend challenges.

- **🐾 Virtual Pet System**
  - Spend coins to feed, level up, and customize your pet.
  - Unlock micropets, and backgrounds.

- **⏰ Alarm Integration**
  - Wake-up alarms based on sleep quality.[TODO]
  - Shared alarms for group health goals.[TODO]

- **📱 Extras**
  - Purchase calm music for meditation.
  - Mood calendar + activity heatmap for habit tracking.
  - Home screen widget showing progress.
  - Smooth animations via Lottie and Rive.
  - Daily to-do tasks with optional alarms.

---
## Demo
<img src='https://github.com/user-attachments/assets/cc115bcd-b539-4b18-b24d-9d179497c782' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/ba8d001c-a910-4311-884d-ff7222097870' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/15fb651b-597a-4dc7-bb75-099361e07c3c' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/1bd26080-58fc-4b60-8d10-e320e7b909e6' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/5a7d95f5-776e-4b7c-8b3e-6ddd5ce1b1da' alt="Sample Image" height="500" />

<img src='https://github.com/user-attachments/assets/716b879c-3583-4ece-9097-bddc1e892434' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/dd456201-6f8f-4877-b507-8fd3bc12bd9d' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/b4a4799e-ec02-426b-9236-9f836ea673ed' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/bf11331e-c9b6-43e3-ae33-b5ac616fa506' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/d03ab494-92a8-44c5-a887-1f95291a12ce' alt="Sample Image" height="500" />

<img src='https://github.com/user-attachments/assets/d5edd54a-51c9-4dd1-9c1b-c93c128977b8' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/c4d0e623-c62d-42ac-a628-dd922f42c793' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/72a1f444-63f1-46dc-b7c4-68ef50c096a4' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/f4d7df78-6003-4c9b-8708-c089bce38c4b' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/d90504f9-d548-47e5-bdfc-59b2ff94e103' alt="Sample Image" height="500" />

<img src='https://github.com/user-attachments/assets/6fd1977b-c9ed-4d3b-bc7c-ca2c935a18de' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/911f1d68-ab0c-427e-911b-ddf8552976b8' alt="Sample Image" height="500" />
<img src='https://github.com/user-attachments/assets/a854c83c-2936-47be-85da-d782e063ec8d' alt="Sample Image" height="500" />

## 🛠️ Project Implementation

This project is built with:

- **Flutter**: for cross-platform development (Android, iOS, Web, Desktop).
- **Firebase Auth & Firestore**: used for login, user profiles, and friend system.
- **Hive**: for local data storage (coins, tasks, streaks, reminders).
- **Provider**: for managing state across modules.
- **Health & Sensor Integration**: using `sensors_plus`, `flutter_health_connect`, and Weather APIs.
- **Notifications & Background Services**: with `flutter_local_notifications`, `android_alarm_manager_plus`, and `flutter_background_service`.

<!-- **Key Directories:**
- `lib/screens/`: UI screens like Home, Challenge, MoodCalendar, and more.
- `lib/widgets/`: custom widgets like daily task card, streak badge, virtual pet view.
- `lib/providers/`: logic for water tracking, streaks, posture detection, task updates.
- `lib/game/`: early prototype for a tile-map based pet game (abandoned in favor of current cozy theme).
- `assets/`: includes Lottie animations, icons, and Rive files for enhanced UX. -->

---

## 🚀 Getting Started

To clone and run the app locally:

```bash
git clone https://github.com/MdSaifAliMolla/GSOC-2025.git
cd GSOC-2025
flutter pub get
flutter run
```
> This will also setup Firebase as I didn't care about security and uploaded all Firebase config file to GitHub 😤.
--- 

## 🔮 Future Plans

- Extend and improve half-finished core features.
- Refine UI with playful animations and cozy visual assets.
- Extend pet system with leveling, feeding, and XP progression.
- Purchase & integrate premium visual assets (badges, avatars, pets).
- Integrate Lottie/Rive feedback animations for rewards and achievements.
- Improve widget support.
- Optimize performance and add comprehensive tests and documentation.

---

## 📬 Contact  ¯\_( ͡° ͜ʖ ͡°)_/¯

**Md. Saif Ali Molla **  
📧 mdsaifalimolla74@gmail.com  
