from playwright.sync_api import sync_playwright
import time

def verify(page):
    page.goto("http://localhost:8080/index.html")
    page.set_viewport_size({"width": 1440, "height": 900})

    # Wait for things to load
    page.wait_for_load_state("networkidle")
    time.sleep(2) # Extra wait for video/animations if needed

    # 1. Top of page
    page.screenshot(path="verification/1_hero_top.png")

    # 2. Scroll down 50% of viewport (Fade starts)
    page.evaluate("window.scrollTo(0, 450)")
    time.sleep(1)
    page.screenshot(path="verification/2_fade_start.png")

    # 3. Scroll down to near end of hero (Fade complete, solid color)
    # Hero is 100vh = 900px.
    # Overlay opacity logic: scrollY / (windowHeight * 0.8).
    # At 900 * 0.8 = 720px, opacity is 1.0.
    page.evaluate("window.scrollTo(0, 750)")
    time.sleep(1)
    page.screenshot(path="verification/3_fade_complete.png")

    # 4. Scroll so Scope section (next section) slides over.
    # Scope starts at 100vh (after spacer).
    # If we scroll to 1000px, we should see Scope content moving up over the solid background.
    page.evaluate("window.scrollTo(0, 1100)")
    time.sleep(1)
    page.screenshot(path="verification/4_scope_overlap.png")

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        try:
            verify(page)
        finally:
            browser.close()
