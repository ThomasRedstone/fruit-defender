.PHONY: run run-linux test test-e2e clean sprites format lint build-web help

# Default target
help:
	@echo "Fruit Defender Makefile"
	@echo "======================="
	@echo "Available commands:"
	@echo "  make run         - Run the game in Chrome"
	@echo "  make run-linux   - Run the game as a Linux desktop app"
	@echo "  make test        - Run all unit and widget tests"
	@echo "  make test-e2e    - Run end-to-end integration tests"
	@echo "  make sprites     - Generate and process game assets (sprites)"
	@echo "  make clean       - Clean the build artifacts"
	@echo "  make format      - Format the Dart code"
	@echo "  make lint        - Analyze the Dart code for issues"
	@echo "  make build-web   - Build the game for deployment to the web"

run:
	flutter run -d chrome

run-linux:
	flutter run -d linux

test:
	flutter test test/wave_test.dart test/tower_logic_test.dart test/economy_test.dart test/placement_test.dart test/start_screen_test.dart

test-e2e:
	flutter test integration_test/app_test.dart

sprites:
	dart tool/generate_sprites.dart
	dart tool/process_assets.dart
	@echo "Sprites generated and processed."

clean:
	flutter clean

format:
	dart format .

lint:
	flutter analyze

build-web:
	flutter build web --release
