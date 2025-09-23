````
# Dev BLoC CLI

A powerful and simple command-line interface (CLI) tool for generating and modifying BLoC architecture boilerplate in your Flutter or Dart projects.



## Why Use Dev BLoC CLI?

Automate the repetitive parts of setting up BLoCs and focus on your business logic.

* ⚡️ **Speed**: Quickly generate a complete, working BLoC with a single command.
* ⚖️ **Consistency**: Ensures all BLoC files follow a consistent folder structure and naming convention.
* ⚙️ **Efficiency**: Easily add new events, handlers, and state properties without manual file edits.
* 📝 **Less Boilerplate**: Reduces the amount of manual code you have to write, preventing errors.

***

## 🚀 Installation

Install and activate the package with one simple command.

```bash
dart pub global activate dev_bloc_cli
````

-----

## 📖 Interactive Usage Guide

Once activated, you can use the commands from any directory in your terminal.

### Generate a New BLoC

Creates a new BLoC with view, state, events, and bloc files.

**Command:**

```bash
dev_bloc_cli generate --name <BlocName>
```

### Add a New Handler

Adds a new event and a corresponding handler function to an existing BLoC.

**Command:**

```bash
dev_bloc_cli add-handler --name <BlocName> --handler <HandlerName>
```

### Add a New State Property

Adds a new property to the state class. **Note:** Enclose properties with special characters (like `List<Product>`) in single quotes in your terminal.

**Command:**

```bash
dev_bloc_cli add-state --name <BlocName> --property '<propertyName>:<DataType>'
```

```
```