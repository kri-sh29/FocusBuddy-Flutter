# 📚 FocusBuddy — Plan. Focus. Progress.

**A student-focused study companion that helps you decide what to study next.**

FocusBuddy is a Flutter-based study companion designed to help students organize their study tasks, prioritize what matters, and build consistent focus habits.

Unlike a basic to-do list, FocusBuddy focuses on helping students take the **next actionable step** instead of feeling overwhelmed by a long list of pending tasks.

## 🌟 What Makes FocusBuddy Different?

### 🎯 Next Best Action

Students often know what they need to study but struggle to decide what to start with.

FocusBuddy's **Next Best Action** feature helps identify a suitable task to work on next based on factors such as deadline urgency and task priority.

The goal is to reduce decision fatigue and make study planning easier, especially for students who need guidance on where to begin.

**Plan → Prioritize → Focus → Reflect → Improve**

## ✨ Features

- **📋 Study Task Management** — Organize tasks by subject, topic, and study goal.
- **⚡ Next Best Action** — Identify a suitable next task from pending work.
- **🚦 Task Prioritization** — Use deadline urgency and priority to help order tasks.
- **⏱️ Focus Sessions** — Work through structured study sessions.
- **📝 Post-Session Reflection** — Record whether a task was completed, partially completed, or not completed.
- **📊 Focus Score** — Measure focused time relative to planned session duration.
- **📈 Progress Tracking** — Review study-session progress.
- **💾 Local Data Storage** — Store app data locally using Hive, if used in this version.

## 🧠 How It Works

1. **Plan:** Add study tasks and define what you want to achieve.
2. **Prioritize:** Organize pending tasks by urgency and priority.
3. **Choose:** Use Next Best Action to identify what to work on next.
4. **Focus:** Start a study session.
5. **Reflect:** Record the outcome after the session.
6. **Improve:** Review your focus and study progress.

## 🎯 Focus Score

FocusBuddy's Focus Score is intended to help students understand how much focused time they achieved compared with their planned session duration.

**Formula:**

`Focus Score = (Actual Focused Time / Planned Duration) × 100`

**Example:** If the planned duration is 25 minutes and the actual focused time is 20 minutes:

`Focus Score = (20 / 25) × 100 = 80/100`

The exact calculation, pause handling, and score limits should match the implementation in the app.

### Task Attempt History

A potential extension is to track how many times a student has attempted a particular task and compare focus scores across attempts. This will help users understand their progress on individual topics.

*Include this as a current feature only if the app already saves and displays this history.*

## 🛠️ Tech Stack

- **Flutter** — Cross-platform mobile app development
- **Dart** — Application programming language
- **Hive** — Local storage, if used in this version

## 📱 Screenshots
- Home dashboard:
- Next Best Action
- Add/Edit Task
- Focus Session
- Post-Session Reflection
- Focus Score and Progress

## 📥 Download FocusBuddy

https://github.com/kri-sh29/FocusBuddy-Flutter/releases/download/v1.0.0/app-release.apk

### Installation Instructions

1. Open the download link on an Android phone.
2. Download the APK file.
3. Open the downloaded file.
4. If prompted, allow installation from that source in Android settings.
5. Tap **Install** and launch FocusBuddy.

Only install APKs from a source you trust.

## 🚀 Run Locally

### Prerequisites

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/kri-sh29/FocusBuddy-Flutter.git
   ```

2. Navigate to the project directory:

   ```bash
   cd FocusBuddy-Flutter
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## 🔮 Future Enhancements

Planned improvements to make FocusBuddy a more intelligent and personalized study companion:

- **☁️ Backend Integration** — Cloud storage and synchronization across devices.
- **🤖 AI-Powered Study Recommendations** — Personalized suggestions based on tasks, deadlines, and learning progress.
- **🔄 Cross-Device Sync** — Access study plans and progress from multiple devices.
- **📊 Advanced Analytics** — Explore long-term focus patterns and study trends.
- **🗓️ Personalized Study Planning** — Adapt study schedules to individual goals and available time.

These are future plans and are not presented as existing features.

## 🎯 Project Goal

FocusBuddy aims to make study planning less overwhelming by helping students move from deciding what to do to actually doing it.

The long-term vision is to evolve it into a personalized study companion that supports planning, focus, reflection, and continuous improvement.

## 👩‍💻 About

FocusBuddy is a personal project developed to explore Flutter app development and build a practical solution to a common student problem: **knowing what to study next and staying consistent.**
