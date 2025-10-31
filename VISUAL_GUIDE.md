# Visual Layout Guide

## Application Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│  Resource Browser                                    [Refresh Button]│
├───────────────────┬─────────────────────────────────────────────────┤
│                   │                                                 │
│   SIDEBAR         │           CONTENT AREA                          │
│   (300px)         │                                                 │
│                   │                                                 │
│  ┌──────────┐    │    When nothing selected:                       │
│  │ Resources│ 4  │    ┌──────────────────────────────┐            │
│  └──────────┘    │    │                              │            │
│                   │    │         [Touch Icon]         │            │
│  ┌──────────┐    │    │                              │            │
│  │  [Icon]  │    │    │   Select a resource to view  │            │
│  │          │    │    │                              │            │
│  │ video.mp4│    │    │   Choose from the left       │            │
│  │  VIDEO   │    │    │                              │            │
│  └──────────┘    │    └──────────────────────────────┘            │
│                   │                                                 │
│  ┌──────────┐    │    When resource selected:                      │
│  │  [Icon]  │    │    ┌──────────────────────────────┐            │
│  │          │    │    │ [Back] filename.ext          │            │
│  │ guide.pdf│    │    │ path/to/file                 │            │
│  │   PDF    │    │    ├──────────────────────────────┤            │
│  └──────────┘    │    │                              │            │
│                   │    │                              │            │
│  ┌──────────┐    │    │     FILE CONTENT HERE        │            │
│  │  [Icon]  │    │    │                              │            │
│  │          │    │    │                              │            │
│  │ notes.md │    │    │                              │            │
│  │ MARKDOWN │    │    │                              │            │
│  └──────────┘    │    └──────────────────────────────┘            │
│                   │                                                 │
│  ┌──────────┐    │                                                 │
│  │  [Icon]  │    │                                                 │
│  │          │    │                                                 │
│  │ page.mht │    │                                                 │
│  │  MHTML   │    │                                                 │
│  └──────────┘    │                                                 │
│                   │                                                 │
└───────────────────┴─────────────────────────────────────────────────┘
```

## Component Breakdown

### Header (App Bar)
```
┌──────────────────────────────────────────────────┐
│  Resource Browser              [Refresh Icon]    │
└──────────────────────────────────────────────────┘
```
- **Title**: "Resource Browser"
- **Refresh Button**: Rescans for new files
- **Color**: Blue background, white text

### Sidebar (Left Panel - 300px)

#### Sidebar Header
```
┌──────────────────┐
│ [Folder] Resources│ 4
└──────────────────┘
```
- **Icon**: Folder icon (blue)
- **Title**: "Resources"
- **Badge**: Count of resources (blue pill)

#### Resource Cards (Grid, 2 columns)
```
┌──────────┐  ┌──────────┐
│  [Icon]  │  │  [Icon]  │
│          │  │          │
│video.mp4 │  │guide.pdf │
│  VIDEO   │  │   PDF    │
└──────────┘  └──────────┘

┌──────────┐  ┌──────────┐
│  [Icon]  │  │  [Icon]  │
│          │  │          │
│notes.md  │  │page.mhtml│
│ MARKDOWN │  │  MHTML   │
└──────────┘  └──────────┘
```

Each card shows:
- **Icon**: Type-specific (video, PDF, doc, web)
- **Icon Color**: Type-specific (red, orange, blue, green)
- **File Name**: Truncated if too long
- **Type Badge**: Colored pill with file type
- **Hover Effect**: Elevation increases

### Content Area (Right Panel - Flexible)

#### Empty State
```
┌────────────────────────────────┐
│                                │
│         [Touch Icon]           │
│                                │
│   Select a resource to view    │
│                                │
│   Choose from the list         │
│                                │
└────────────────────────────────┘
```

#### With Resource Selected

##### Content Header
```
┌────────────────────────────────┐
│ [←] filename.ext               │
│     path/to/filename.ext       │
└────────────────────────────────┘
```
- **Back Button**: Returns to empty state
- **File Name**: Bold, larger text
- **File Path**: Smaller, gray text

##### Video Viewer
```
┌────────────────────────────────┐
│                                │
│         VIDEO FRAME            │
│                                │
├────────────────────────────────┤
│ [▶] ──────●───────────── 2:45  │
└────────────────────────────────┘
```
- Video player with aspect ratio
- Play/pause button
- Progress bar (scrubbing enabled)
- Black control bar

##### PDF Viewer
```
┌────────────────────────────────┐
│  PDF PAGE 1                    │
│                                │
│  Content scrolls...            │
│                                │
│  [Zoom controls at bottom]     │
└────────────────────────────────┘
```
- Full Syncfusion PDF viewer
- Zoom, pan, scroll
- Page navigation

##### Markdown Viewer
```
┌────────────────────────────────┐
│  # Heading 1                   │
│                                │
│  This is **bold** text         │
│                                │
│  ## Heading 2                  │
│                                │
│  - List item 1                 │
│  - List item 2                 │
└────────────────────────────────┘
```
- Rendered markdown with formatting
- Selectable text
- Styled headings, lists, etc.

##### MHTML Viewer
```
┌────────────────────────────────┐
│  Raw MHTML content             │
│  (monospace font)              │
│                                │
│  Scrollable text...            │
└────────────────────────────────┘
```
- Scrollable text view
- Monospace font
- Future: Will render as HTML

## Color Scheme

### File Type Colors
- **Video**: 🔴 Red (`Colors.red`)
- **PDF**: 🟠 Orange (`Colors.orange`)
- **Markdown**: 🔵 Blue (`Colors.blue`)
- **MHTML**: 🟢 Green (`Colors.green`)

### UI Colors
- **Primary**: Blue (`Colors.blue`)
- **Background**: Gray (`Colors.grey[100]`)
- **Cards**: White (`Colors.white`)
- **Borders**: Light Gray (`Colors.grey[300]`)
- **Text**: Dark Gray / Black

## Responsive Behavior

### Current (Desktop-First)
```
Desktop/Tablet:
┌────────┬─────────────┐
│ 300px  │  Flexible   │
│ Fixed  │   Grows     │
└────────┴─────────────┘

Mobile (Future):
┌──────────────────────┐
│     Full Width       │
│   (Tabs/Drawer)      │
└──────────────────────┘
```

## Interaction Flow

```
1. App Loads
   ↓
2. Scan manifest file
   ↓
3. Display resources in sidebar
   ↓
4. User clicks resource card
   ↓
5. Display file in content area
   ↓
6. User clicks back button
   ↓
7. Return to empty state
```

## States

### Loading State
```
┌────────────────────────────────┐
│                                │
│      [Circular Progress]       │
│                                │
└────────────────────────────────┘
```

### Empty State (No Resources)
```
┌────────────────────────────────┐
│       [Folder Icon]            │
│                                │
│    No resources found          │
│                                │
│  Make sure manifest exists     │
└────────────────────────────────┘
```

### Error State
```
┌────────────────────────────────┐
│       [Error Icon]             │
│                                │
│   Failed to load resource      │
│                                │
└────────────────────────────────┘
```

## Icons Used

- `Icons.folder` - Folder/directory
- `Icons.video_library` - Video files
- `Icons.picture_as_pdf` - PDF files
- `Icons.description` - Markdown files
- `Icons.web` - MHTML files
- `Icons.refresh` - Refresh button
- `Icons.arrow_back` - Back button
- `Icons.touch_app` - Empty state hint
- `Icons.error_outline` - Error state
- `Icons.folder_open` - No resources

## Typography

### Fonts
- **Primary**: Roboto (default Material font)
- **Monospace**: For MHTML viewer

### Sizes
- **App Title**: 20px
- **Section Headers**: 18px, bold
- **File Names**: 14px, bold
- **File Types**: 10px, bold, uppercase
- **Paths**: 12px, gray
- **Body Text**: 16px

## Spacing

- **Grid Spacing**: 16px between cards
- **Padding**: 16px around content
- **Card Padding**: 16px inside cards
- **Header Padding**: 16px all around

## Animations

### Current
- **Hover**: Card elevation change (smooth)
- **Loading**: Circular progress spinner

### Future Ideas
- Page transitions
- Card flip on selection
- Fade-in when loading
- Slide-in sidebar (mobile)

---

This visual guide shows exactly how the UI is structured and styled.
Refer to this when customizing the appearance!
