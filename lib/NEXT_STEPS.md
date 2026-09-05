# NoteNest — UI shell

Three reusable components plus a runnable demo. No external packages needed.

## Run it

```bash
flutter create notenest            # if you don't have a project yet
cd notenest
# copy lib/ and pubspec.yaml from this folder over the generated ones
flutter run
```

The demo opens on the setup flow (`NestStepper`), then pushes the home shell
where the drawer and the navigation bar live.

## Design language — "Ballpoint & Highlighter"

Every colour comes from something a student writes with, so the interface
speaks the same language as the notebook it replaces.

| Token | Value | Used for |
|---|---|---|
| `pen` | `#243E8C` | primary actions, inked progress, active icons |
| `highlight` | `#FFE45E` | the highlighter swipe behind whatever is current |
| `redPen` | `#D62839` | important notes, revision warnings, destructive actions |
| `mint` | `#1F8A6B` | synced / mastered |
| `paper` `#EDEFF3`, `card` `#FFFFFF`, `rule` `#DCE1E9` | | page surfaces and ruled lines |
| `tabs[]` | six pastels | one index-tab colour per subject |

Type has three roles: a display face for headings, a body face for reading, and
a **mono utility face** for counts, dates and small uppercase labels
(`STEP 02 / 03`, `SUBJECTS`, `24`). That printed-index voice is what keeps the
screens from looking like a generic list app.

To use the intended typefaces, uncomment `google_fonts` in `pubspec.yaml` and
set `NestFont.display = 'Fraunces'`, `NestFont.body = 'Manrope'`,
`NestFont.mono = 'IBM Plex Mono'` (or add them as bundled font assets).

## The three components

### `NestStepper` — `lib/widgets/nest_stepper.dart`

A horizontal stepper drawn as a page of notes. Steps not yet reached are a
dotted pencil guide; the path behind the student is inked in as a slightly
wobbly pen stroke. Finished steps get a tick, the current step gets the
highlighter swipe. Completed steps are tappable, upcoming ones are not, so you
can go back but not skip ahead.

```dart
NestStepper(
  steps: const [
    NestStep(title: 'Who is writing', icon: Icons.person_rounded,
             hint: 'Your name goes on every note you share.'),
    NestStep(title: 'Semester and subjects', icon: Icons.folder_rounded),
    NestStep(title: 'Study routine', icon: Icons.alarm_rounded),
  ],
  currentIndex: step,
  onStepTapped: (i) => setState(() => step = i),
)
```

Reuse it for note capture (Capture → Tag → Review) and exam setup
(Exam → Subjects → Priority) as well.

### `NestDrawer` — `lib/widgets/nest_drawer.dart`

A spiral-bound notebook. Real wire rings run down the left edge; subjects are
index tabs that run off the right edge of the sheet in their own colour, with a
note count in the printed-index style. Rows flip open in a stagger when the
drawer slides in. The header carries the semester chip and overall mastery; the
footer carries sync state.

```dart
NestDrawer(
  userName: 'Rafiul Karim',
  semester: 'Semester 5 · 2026',
  subjects: subjects,       // NestSubject(name, code, color, notes, mastery)
  links: links,             // NestDrawerLink(id, label, icon, badge)
  selectedId: selected,
  onSelectSubject: (s) { ... },
  onSelectLink: (l) { ... },
)
```

### `NestNavBar` — `lib/widgets/nest_nav_bar.dart`

Four destinations drawn as index tabs on the edge of the page. The selected tab
physically lifts out of the sheet and shows its coloured edge. The capture
button in the middle is a blue block printed slightly off-register against a
highlighter block — the same mark that appears behind active text elsewhere.

```dart
NestNavBar(
  items: items,             // exactly four NestNavItem
  currentIndex: tab,
  onTap: (i) => setState(() => tab = i),
  onCapture: openCaptureSheet,
)
```

Use `Scaffold(extendBody: true, ...)` and leave ~120px of bottom padding in
scrolling pages so content clears the bar.

## Build order from here

Each phase leaves the app usable on its own, which is what the proposal's
iterative methodology promises.

**Phase 1 — Notes that survive a restart (offline core).**
Data model and local database (Isar or Drift), create/edit a text note, assign
semester → subject → topic, list and search. Ends with an app you can actually
take to class.

**Phase 2 — Capture.**
Camera for handwritten pages with crop and straighten, PDF pick and view, local
file storage and thumbnails. Wire these into the capture sheet that already
exists.

**Phase 3 — Study status and Exam Mode.**
New / Read / Review / Mastered, important flag, exam entry with countdown, and
the priority list that orders revision. This is the feature the proposal is
built around, and it needs Phases 1–2 in place first.

Later: authentication and cloud sync with Trash recovery, then sharing, study
groups, note requests and the shared inbox, then lecture recording with
speech-to-text.
