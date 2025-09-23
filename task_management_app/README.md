## Task Management Two‑Screen UI (Pixel Replica)

This Flutter project implements ONLY the first two provided design screens (Home / Dashboard & Task Detail) focusing on pixel‑level look & feel rather than functionality.

### Scope
Included:
- Home screen with greeting, statistics cards, horizontal date strip (static), task list with gradient cards.
- Task detail screen with tags, description, team avatars, progress summary, subtasks list & scrolling layout.
- Light theme enforced; typography with Poppins (closest open‑source match to supplied design font).
- Custom decorative background (vector recreation) instead of raster copy to stay resolution‑independent.
- Avatar asset fallbacks (icon placeholder shown if image missing / invalid).

Excluded (by assignment spec):
- Real networking / persistence / state management.
- Editing, adding tasks, dynamic date selection.
- Authentication / navigation beyond the two screens.

### Project Structure
```
lib/
  main.dart                # Entry point
  theme/app_theme.dart     # Colors & text styles
  models/task_models.dart  # Simple immutable demo data models
  widgets/ui_components.dart # Reusable UI (cards, avatars, progress, background)
  screens/home_page.dart   # Home screen
  screens/task_detail_page.dart # Task detail screen (sliver based)
assets/avatars/            # Avatar image placeholders (replace with real images)
```

### Fonts
Using Google Fonts: Poppins. Adjust weights/sizes in `AppTextStyles` if you have exact spec measurements.

### Running (Android)
1. Ensure you have a writable Android SDK. If your current SDK is system‑wide & read‑only, consider setting:
	```bash
	export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
	export PATH="$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
	```
	Then reinstall required components with `sdkmanager`.
2. Connect device & verify:
	```bash
	flutter devices
	```
3. Run the app:
	```bash
	flutter run -d <device_id>
	```

### Replacing Avatars
Drop valid PNG/JPG files into `assets/avatars/` keeping the same filenames (`user1.png`, etc.). Hot restart to see changes.

### Stability Notes
Current build avoids nested unbounded scroll issues by using a `CustomScrollView` with slivers on the detail screen. Avatar decoding failures are handled with a fallback icon.

### Pixel Fidelity Adjustments
Key tune points (centralized for quick iteration):
- Corner radii: Task cards `28`, stat cards `18`, subtasks `16`.
- Spacing: Primary horizontal padding `24`, inter‑section vertical gaps (16 / 22 / 26 / 32) chosen to approximate supplied layout.
- Gradients & color constants: `AppColors` in `app_theme.dart`.

### Next Potential Enhancements (Not Required)
- Add golden tests (screenshot comparison) for regression control.
- Extract spacing constants into a design tokens file.
- Provide localization scaffolding.

### License
Intended for evaluation purposes per assignment; replace or remove before production use.
