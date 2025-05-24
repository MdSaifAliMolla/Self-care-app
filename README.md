
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
