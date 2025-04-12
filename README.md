# virtual_switch

A new Flutter project.

## Getting Started
This project is built using the Provider package for state management, following the MVC (Model-View-Controller) architecture. It utilizes the http package for handling network requests and the intl library for date formatting and localization.


✅ Provider for state management

✅ MVC (Model-View-Controller) architecture for separation of concerns

✅ http for API requests

✅ intl for date formatting

✅ A well-organized modular structure under src/ for scalability and maintainability

src/
├── core/
│   ├── app_colors.dart          # Centralized color definitions
│   └── helper.dart              # Shared UI helpers like spacing, padding, custom widgets, etc.
│
└── features/
    └── home/
        ├── model/
        │   └── post_model.dart  # PostModel class with JSON parsing and date formatting (intl)
        │
        ├── view/
        │   ├── components/
        │   │   ├── empty_data_widget.dart     # Shown when no data matches filter/search
        │   │   ├── error_widget.dart          # Shown when API call fails
        │   │   └── filter_bottom_sheet.dart   # UI component for selecting filters
        │   │
        │   ├── home_view.dart                 # Main screen: search bar, list view, filter button
        │   └── item_details_screen.dart       # Shows details of a selected post
        │
        └── controller/
            └── home_controller.dart           # Contains business logic, fetches data, manages state
# virtual_switch
