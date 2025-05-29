# Invoice to PO Converter (Flutter)

A Flutter app that uses OpenAI's GPT-4o Vision model to extract structured purchase order details from invoice images.

## Features

- 🖼 Upload invoice image (JPG, PNG)
- 🤖 Extract and structure data using OpenAI Vision
- 📋 Edit extracted fields and items in a dynamic table
- 💾 Save to Supabase database
- 🔁 Convert invoice ↔ PO (toggle mode)

## Tech Stack

- Flutter
- Supabase
- OpenAI GPT-4o Vision
- Dotenv for secret management

## Setup

```bash
flutter pub get
flutter run
