
# BLoC CLI

A powerful and simple command-line interface (CLI) tool for generating and modifying BLoC architecture boilerplate in your Flutter or Dart projects.

-----

## Why Use BLoC CLI?

Automate the repetitive parts of setting up BLoCs and focus on your business logic.

  * ⚡️ **Speed**: Quickly generate a complete, working BLoC with a single command.
  * ⚖️ **Consistency**: Ensures all BLoC files follow a consistent folder structure and naming convention.
  * ⚙️ **Efficiency**: Easily add new events, handlers, and state properties without manual file edits.
  * 📝 **Less Boilerplate**: Reduces the amount of manual code you have to write, preventing errors.

-----

## 🚀 Installation

Get up and running in three simple steps.

1.  **Add Dependencies**
    Ensure your `pubspec.yaml` file has the required dependencies.all latest versions

    ```yaml
    dependencies:
      args: 
      path: 
      flutter_bloc: 
      bloc:
      equatable:
    ```

2.  **Add CLI to `bin` Directory**
    Place the `main.dart` file in your project's `bin/` folder. Ensure the package name in your `pubspec.yaml` matches what you use in commands (e.g., `bloc_cli`).

3.  **Get Dependencies**
    Run the following command in your terminal to download the packages.

    ```bash
    dart pub get
    ```

-----

## 📖 Interactive Usage Guide

### **Generate a New BLoC**

Creates a new BLoC with `view`, `state`, `events`, and `bloc` files.

**Command:**
`dart run bloc_cli generate --name <BlocName>`

### **Add a New Handler**

Adds a new event and a corresponding handler function to an existing BLoC.

**Command:**
`dart run bloc_cli add-handler --name <BlocName> --handler <HandlerName>`

### **Add a New State Property**

Adds a new property to the state class. **Note:** Enclose properties with special characters (like `List<Product>`) in single quotes in your terminal.

**Command:**
`dart run bloc_cli add-state --name <BlocName> --property '<propertyName>:<DataType>'`