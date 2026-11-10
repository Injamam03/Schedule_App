/// Every user-facing string lives here.
class AppConstString {
  AppConstString._();

  // General
  static const String appName = 'Schedulr';
  static const String appTagline = 'Plan your day. Never miss a task.';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';

  // Units / durations
  static const String unitDay = 'd';
  static const String unitHour = 'h';
  static const String unitMinute = 'm';
  static String ago(String d) => '$d ago';
  static String startsIn(String d) => 'Starts in $d';
  static String inProgressSince(String d) => 'In progress for $d';
  static String startedAt(String time, String d) => 'Started at $time · $d ago';
  static String completedOn(String d) => 'Completed on $d';
  static String cancelledOn(String d) => 'Cancelled on $d';
  static String missedOn(String d) => 'Missed — scheduled for $d';

  // Navigation
  static const String navHome = 'Home';
  static const String navSchedule = 'Schedule';
  static const String navProfile = 'Profile';

  // Sign in
  static const String welcomeBackTitle = 'Welcome back';
  static const String signInSubtitle = 'Sign in to continue to your schedule';
  static const String email = 'Email';
  static const String emailHint = 'you@example.com';
  static const String password = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String signIn = 'Sign In';
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String signInFailed = 'Could not sign in. Please try again.';
  static const String demoLoginNote =
      'Firebase Authentication will be connected later. For now any valid email and a password of 6+ characters signs you in on this device.';

  // Home
  static const String welcomeBack = 'Welcome back,';
  static const String setupTitle = 'Set Up Your Schedule';
  static const String setupDescription =
      'Organise your tasks, get timely reminders and stay on top of your day.';
  static const String setupButton = 'Create Schedule';
  static const String currentlyWorking = 'Currently Working';
  static const String nextSchedule = 'Next Schedule';
  static const String recentlyCompleted = 'Recently Completed';
  static const String noActiveSchedule = "You don't have any active schedule right now.";
  static const String noNextSchedule = 'No upcoming schedule. Create one to get started.';
  static const String noCompleted = "You haven't completed any schedule yet.";
  static const String markAsComplete = 'Mark as Complete';
  static const String markedComplete = 'Great job! Schedule marked as complete.';

  // Schedule tab
  static const String mySchedule = 'My Schedule';
  static const String filterAll = 'All';
  static const String filterUpcoming = 'Upcoming';
  static const String filterComplete = 'Complete';
  static const String filterMissing = 'Missing';
  static const String filterCancel = 'Cancel';
  static const String emptyAll = 'You have no schedules yet. Tap + to create your first one.';
  static const String emptyUpcoming = 'No upcoming schedules.';
  static const String emptyComplete = 'No completed schedules yet.';
  static const String emptyMissing = 'Nothing missed. Keep it up!';
  static const String emptyCancel = 'No cancelled schedules.';

  // Statuses
  static const String statusUpcoming = 'Upcoming';
  static const String statusCompleted = 'Completed';
  static const String statusMissed = 'Missed';
  static const String statusCancelled = 'Cancelled';
  static const String statusLabel = 'Status';

  // Create / edit schedule
  static const String createScheduleTitle = 'Create Schedule';
  static const String editScheduleTitle = 'Edit Schedule';
  static const String createScheduleSubtitle =
      "Add the details of your task. We'll remind you before it starts and again at the exact time.";
  static const String scheduleTitleLabel = 'Task name';
  static const String scheduleTitleHint = 'e.g. Team meeting';
  static const String dateLabel = 'Date';
  static const String dateHint = 'Select a date';
  static const String timeLabel = 'Time';
  static const String timeHint = 'Select a time';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'What do you need to do?';
  static const String titleRequired = 'Please enter a task name';
  static const String dateRequired = 'Please select a date';
  static const String timeRequired = 'Please select a time';
  static const String descriptionRequired = 'Please add a short description';
  static const String pastDateError = 'Please choose a date and time in the future.';
  static const String schedule = 'Schedule';
  static const String saveChanges = 'Save Changes';
  static const String scheduleCreated = 'Schedule created. You will be reminded in time.';
  static const String scheduleCreatedNoNotifications =
      'Schedule created, but notifications are turned off. Enable them in system settings to get reminders.';
  static const String scheduleUpdated = 'Schedule updated.';
  static const String editNotAllowed = 'This schedule can no longer be edited.';

  // Schedule details
  static const String scheduleDetailsTitle = 'Schedule Details';
  static const String scheduleNotFound = 'Schedule not found';
  static const String scheduleNotFoundMessage =
      'It may have been removed after the 30-day history period.';
  static const String noDescription = 'No description added.';
  static const String completedThisSchedule = 'I Have Completed This Schedule';
  static const String completedMissedTask = 'I Completed This Task';
  static const String missedHint =
      'Did you actually do this task but forgot to update the app? You can still mark it as complete.';
  static const String cancelSchedule = 'Cancel Schedule';
  static const String keepSchedule = 'Keep It';
  static const String cancelScheduleTitle = 'Cancel this schedule?';
  static const String cancelScheduleMessage =
      'Its reminders will be removed. You can only cancel before the scheduled time.';
  static const String scheduleCancelled = 'Schedule cancelled.';
  static const String cancelNotAllowed =
      'This schedule can only be cancelled before its scheduled time.';

  // Notifications
  static const String notificationsTitle = 'Notifications';
  static const String noNotifications = 'No notifications yet';
  static const String noNotificationsMessage =
      'Reminders and missed-task alerts will appear here.';
  static const String notifChannelName = 'Schedule reminders';
  static const String notifChannelDescription =
      'Reminders before and at the time of your scheduled tasks';
  static const String notifReminderTitle = 'Upcoming task';
  static String notifReminderBody(String task, int minutes) =>
      '"$task" starts in $minutes minutes. Get ready!';
  static const String notifStartTitle = 'Time to start';
  static String notifStartBody(String task) =>
      '"$task" is scheduled for now. Time to get started!';
  static const String notifMissedTitle = 'Task missed';
  static String notifMissedBody(String task) =>
      'You missed "$task". If you did it, mark it as complete.';

  // Profile
  static const String statistics = 'Statistics';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String statTotal = 'Total Schedules';
  static const String statCompleted = 'Completed';
  static const String statMissed = 'Missed';
  static const String createNote = 'Create Note';
  static const String createNoteSubtitle = 'Write and keep personal notes';
  static const String savePhoto = 'Save Photo';
  static const String savePhotoSubtitle = 'Your private photo gallery';
  static const String changeTheme = 'Change Theme';
  static const String themeSubtitle = 'Choose how the app looks';
  static const String themeLight = 'Light Theme';
  static const String themeDark = 'Dark Theme';
  static const String themeSystem = 'System Default';
  static const String logout = 'Logout';
  static const String logoutTitle = 'Log out?';
  static const String logoutMessage = 'You will need to sign in again to use the app.';

  // Notes
  static const String notesTitle = 'My Notes';
  static const String createNoteTitle = 'Create Note';
  static const String editNoteTitle = 'Edit Note';
  static const String noteTitleLabel = 'Title (optional)';
  static const String noteTitleHint = 'Note title';
  static const String noteContentLabel = 'Note';
  static const String noteContentHint = 'Write your note here...';
  static const String noteContentRequired = 'Please write something first';
  static const String saveNote = 'Save Note';
  static const String noteSaved = 'Note saved.';
  static const String noteDeleted = 'Note deleted.';
  static const String noNotes = 'No notes yet';
  static const String noNotesMessage = 'Tap Create Note to write your first one.';
  static const String untitledNote = 'Untitled note';
  static const String deleteNoteTitle = 'Delete note?';
  static const String deleteNoteMessage = 'This note will be permanently deleted.';

  // Photos
  static const String savedPhotosTitle = 'Saved Photos';
  static const String noPhotos = 'No saved photos';
  static const String noPhotosMessage = 'Pick photos from your device to keep them here.';
  static const String addPhotos = 'Add Photos';
  static const String photoDeleted = 'Photo deleted.';
  static const String deletePhotoTitle = 'Delete photo?';
  static const String deletePhotoMessage = 'This photo will be removed from the app.';
  static String photoCount(int n) => n == 1 ? '1 photo' : '$n photos';
  static String photosSaved(int n) => n == 1 ? 'Photo saved.' : '$n photos saved.';
  static String photoPosition(int i, int total) => '$i / $total';
}
