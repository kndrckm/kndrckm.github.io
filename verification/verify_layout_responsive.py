from playwright.sync_api import sync_playwright
import time

def verify_layout(page, width, height, name):
    print(f"Verifying layout for {name} ({width}x{height})")
    page.set_viewport_size({"width": width, "height": height})
    page.goto("http://localhost:8080/index.html")
    page.wait_for_load_state("networkidle")

    # Scroll to Scope section to see the container width clearly
    page.evaluate("document.getElementById('scope').scrollIntoView()")
    time.sleep(1)

    screenshot_path = f"verification/layout_{name}.png"
    page.screenshot(path=screenshot_path)
    print(f"Screenshot saved to {screenshot_path}")

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        try:
            # 1. Laptop (Standard 15-16 inch scaled or native)
            # Typically 1440px to 1600px width.
            verify_layout(page, 1512, 982, "laptop_15inch")

            # 2. Large Desktop (24 inch+)
            # 1920px width (Full HD) - should trigger max-width: 1700px
            verify_layout(page, 1920, 1080, "desktop_large_1080p")

            # 3. Ultra Wide / very large
            verify_layout(page, 2560, 1440, "desktop_ultrawide")

        finally:
            browser.close()
