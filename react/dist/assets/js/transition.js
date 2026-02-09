/**
 * transition.js - Handles smooth page transitions
 */
document.addEventListener('DOMContentLoaded', () => {
    // 1. INJECT STYLES
    const style = document.createElement('style');
    style.innerHTML = `
        .pt-curtain {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: #EDEFF2; /* Matches site background */
            z-index: 9999;
            pointer-events: none;
            opacity: 1;
            transition: opacity 0.8s cubic-bezier(0.25, 1, 0.5, 1);
            transform-origin: top;
        }
        /* Exit state: Start transparent, become opaque */
        .pt-curtain.exit {
            opacity: 0;
        }
        .pt-curtain.exit-active {
            opacity: 1;
        }
    `;
    document.head.appendChild(style);

    // 2. CREATE ENTRANCE CURTAIN (Starts Opaque -> Fades Out)
    const curtain = document.createElement('div');
    curtain.className = 'pt-curtain';
    document.body.appendChild(curtain);

    // Trigger Fade Out (Reveal Page)
    requestAnimationFrame(() => {
        // Simple double RAF to ensure style is applied before transition
        requestAnimationFrame(() => {
            curtain.style.opacity = '0';
            // Remove after transition to prevent blocking clicks
            setTimeout(() => {
                if (curtain.parentNode) curtain.parentNode.removeChild(curtain);
            }, 800);
        });
    });

    // 3. INTERCEPT LINKS FOR EXIT ANIMATION
    document.addEventListener('click', (e) => {
        const link = e.target.closest('a');
        // Logic: Must be a link, valid HREF, not an anchor (#), not external target
        if (link && link.href && link.target !== '_blank') {
            const url = new URL(link.href, window.location.href);

            // Allow anchor links on safe page to pass through
            if (url.pathname === window.location.pathname && url.hash) return;
            // Ignore external links
            if (url.origin !== window.location.origin) return;

            e.preventDefault();

            // Create New Curtain for Exit
            const exitCurtain = document.createElement('div');
            exitCurtain.className = 'pt-curtain exit';
            document.body.appendChild(exitCurtain);

            // Force reflow
            void exitCurtain.offsetWidth;

            // Trigger Fade In (Cover Page)
            exitCurtain.classList.add('exit-active');

            // Navigate after delay
            setTimeout(() => {
                window.location.href = link.href;
            }, 600); // Wait slightly less than CSS transition for snap feel
        }
    });

    // 4. SPECIAL CASE: BACK BUTTON CACHE (bfcache)
    // If user presses browser back button, we need to remove curtain immediately
    window.addEventListener('pageshow', (event) => {
        if (event.persisted) {
            const curtains = document.querySelectorAll('.pt-curtain');
            curtains.forEach(c => c.remove());
        }
    });
});
