/**
 * layout.js - Modular Navigation and Footer Component
 * Handles rendering and logic for shared site elements.
 */

const renderNav = (isIndexPage = false) => {
    // If not on index page, anchor links must point to index.html
    const linkPrefix = isIndexPage ? '' : 'index.html';

    return `
    <nav class="nav-fixed">
        <div class="nav-glass p-1.5 rounded-full flex items-center shadow-sm">

            <div class="pl-5 pr-2">
                <a href="${linkPrefix}#hero"
                    class="font-black tracking-tighter text-primary text-base hover:text-accent uppercase leading-none cursor-pointer">KEND.</a>
            </div>

            <div class="hidden md:flex items-center gap-1 mx-1">
                <a href="${linkPrefix}#scope"
                    class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">Scope</a>
                <a href="${linkPrefix}#portfolio"
                    class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">Projects</a>
                <a href="${linkPrefix}#cv"
                    class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">About</a>
            </div>

            <!-- Mobile Hamburger Button -->
            <button id="mobile-menu-btn"
                class="md:hidden p-2 ml-2 mr-1 rounded-full hover:bg-black/5 transition-colors">
                <i data-lucide="menu" class="w-5 h-5 text-primary" id="menu-icon"></i>
                <i data-lucide="x" class="w-5 h-5 text-primary hidden" id="close-icon"></i>
            </button>

            <a href="https://wa.me/6281390200075" target="_blank"
                class="group bg-primary hover:bg-[#25D366] text-white pl-4 pr-3 md:pl-6 md:pr-5 py-2 md:py-2.5 rounded-full text-xs md:text-sm font-bold flex items-center gap-1.5 md:gap-2 transition-all duration-500 hover:shadow-[0_0_25px_rgba(37,211,102,0.4)] active:scale-95 ml-2">
                <svg class="w-3.5 h-3.5 md:w-4 md:h-4 transition-colors duration-500 fill-current group-hover:text-white"
                    viewBox="0 0 24 24">
                    <path
                        d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.72.94 3.659 1.437 5.63 1.438h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
                </svg>Contact</a>
        </div>
    </nav>
    
    <!-- Mobile Menu Dropdown -->
    <div id="mobile-menu" class="fixed top-20 left-1/2 -translate-x-1/2 z-[999] w-[90%] max-w-sm hidden md:hidden">
        <div class="nav-glass rounded-3xl p-4 shadow-ios-deep">
            <div class="flex flex-col gap-2">
                <a href="${linkPrefix}#scope"
                    class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">Scope
                    of Work</a>
                <a href="${linkPrefix}#portfolio"
                    class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">Projects</a>
                <a href="${linkPrefix}#cv"
                    class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">About</a>
            </div>
        </div>
    </div>`;
};

const renderFooter = () => `
    <section class="pt-12 md:pt-24 pb-0 w-full">
        <div id="footer-spotlight-container"
            class="vision-mesh-animated relative w-full overflow-hidden pt-16 pb-8 md:pt-24 md:pb-12 px-6 text-center shadow-[inset_0_20px_60px_-10px_rgba(0,0,0,0.6)] group">

            <canvas id="footer-spotlight-canvas"
                class="absolute inset-0 w-full h-full z-0 pointer-events-none mix-blend-overlay"></canvas>

            <div class="relative z-10 flex flex-col items-center">
                <h2 class="reveal-text text-4xl md:text-6xl font-medium text-white tracking-tighter mb-6 flex flex-col md:grid md:grid-cols-[1fr_auto_1fr] items-center gap-x-[0.25em] gap-y-1 w-full justify-center">
                    <span class="md:text-right">Have a</span>
                    <div id="rotator-mask"
                        class="h-[1.2em] overflow-hidden relative grid place-items-center text-accent transition-all duration-500 ease-in-out md:mx-auto">
                        <div id="text-rotator" class="text-center w-max transform translate-y-0">
                            <span class="block h-[1.2em] leading-[1.2em] px-1">vision</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">idea</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">project</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">question</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">dream</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">concept</span>
                            <span class="block h-[1.2em] leading-[1.2em] px-1">vision</span>
                        </div>
                    </div>
                    <span class="md:text-left">in mind?</span>
                </h2>

                <p class="reveal-text text-white/60 text-base md:text-xl font-light mb-10 italic">Let's create something timeless together.</p>

                <a href="https://wa.me/6281390200075" target="_blank"
                    class="inline-flex items-center gap-5 bg-white text-primary pl-10 pr-3 py-3.5 rounded-full font-black text-xl transition-all duration-500 hover:scale-110 shadow-2xl group/btn mb-12">
                    Start a Project
                    <div class="bg-black rounded-full p-3 text-white transition-all duration-500 group-hover/btn:bg-accent group-hover/btn:rotate-45">
                        <i data-lucide="arrow-up-right" class="w-6 h-6"></i>
                    </div>
                </a>

                <div class="pt-0 flex flex-col items-center justify-center gap-6 max-w-6xl mx-auto reveal-text">
                    <div class="flex gap-6">
                        <a href="https://linkedin.com/in/kendrick-marzuki" target="_blank"
                            class="flex items-center gap-3 text-white/70 hover:text-white transition-all font-black text-sm hover:scale-105">
                            <div class="p-2 rounded-xl bg-white/10 hover:bg-[#0077B5] transition-colors"><i
                                    data-lucide="linkedin" class="w-4 h-4"></i></div> LinkedIn
                        </a>
                    </div>
                    <p class="text-white/30 text-[10px] font-bold uppercase tracking-[0.2em]">© <span id="footer-year"></span> KENDRICK MARZUKI</p>
                </div>
            </div>
        </div>
    </section>
`;

// Helper: Init Logic (Mobile Menu, Footer Spotlight, Rotator)
const initLayoutLogic = () => {
    // 1. Mobile Menu
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');
    const mobileMenu = document.getElementById('mobile-menu');
    const menuIcon = document.getElementById('menu-icon');
    const closeIcon = document.getElementById('close-icon');

    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', () => {
            const isHidden = mobileMenu.classList.contains('hidden');
            if (isHidden) {
                mobileMenu.classList.remove('hidden');
                mobileMenu.classList.add('flex');
                menuIcon.classList.add('hidden');
                closeIcon.classList.remove('hidden');
            } else {
                mobileMenu.classList.add('hidden');
                mobileMenu.classList.remove('flex');
                menuIcon.classList.remove('hidden');
                closeIcon.classList.add('hidden');
            }
        });
        document.querySelectorAll('.mobile-nav-link').forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.add('hidden');
                menuIcon.classList.remove('hidden');
                closeIcon.classList.add('hidden');
            });
        });
    }

    // 2. Footer Year
    const yearSpan = document.getElementById('footer-year');
    if (yearSpan) yearSpan.textContent = new Date().getFullYear();

    // 3. Icons
    if (window.lucide) window.lucide.createIcons();

    // 4. Footer Spotlight
    (function () {
        const canvas = document.getElementById('footer-spotlight-canvas');
        const container = document.getElementById('footer-spotlight-container');
        if (!canvas || !container) return;
        const ctx = canvas.getContext('2d');
        let mouseX = -1000, mouseY = -1000;
        let isVisible = false;

        const resize = () => {
            const rect = container.getBoundingClientRect();
            canvas.width = rect.width; canvas.height = rect.height;
        };
        window.addEventListener('resize', resize);
        resize();

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => isVisible = entry.isIntersecting);
        }, { threshold: 0 });
        observer.observe(container);

        container.addEventListener('mousemove', e => {
            const rect = container.getBoundingClientRect();
            mouseX = e.clientX - rect.left; mouseY = e.clientY - rect.top;
        });

        const draw = () => {
            if (isVisible) {
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                if (mouseX !== -1000) {
                    const g = ctx.createRadialGradient(mouseX, mouseY, 0, mouseX, mouseY, 400);
                    g.addColorStop(0, 'rgba(255,255,255,0.4)');
                    g.addColorStop(1, 'rgba(255,255,255,0)');
                    ctx.fillStyle = g;
                    ctx.fillRect(0, 0, canvas.width, canvas.height);
                }
            }
            requestAnimationFrame(draw);
        };
        draw();
    })();

    // 5. Rotator
    const textRotator = document.getElementById('text-rotator');
    const rotatorMask = document.getElementById('rotator-mask');
    if (textRotator && rotatorMask) {
        const rotChildren = textRotator.children;
        const rotTotal = rotChildren.length - 1;
        let rotIndex = 0;

        const setWidth = (idx) => {
            if (rotChildren[idx]) rotatorMask.style.width = rotChildren[idx].offsetWidth + 'px';
        };

        const updateWidth = () => setWidth(rotIndex);
        updateWidth();
        document.fonts.ready.then(updateWidth);
        new ResizeObserver(updateWidth).observe(textRotator);

        setInterval(() => {
            rotIndex++;
            setWidth(rotIndex);
            textRotator.style.transition = 'transform 0.5s cubic-bezier(0.25, 1, 0.5, 1)';
            textRotator.style.transform = `translateY(calc(-${rotIndex} * 1.2em))`;

            if (rotIndex === rotTotal) {
                setTimeout(() => {
                    textRotator.style.transition = 'none';
                    rotIndex = 0;
                    textRotator.style.transform = `translateY(0)`;
                    setWidth(0);
                }, 500);
            }
        }, 3000);
    }
};

// GLOBAL CURSOR LOGIC (Smart Project Preview)
const initGlobalCursor = () => {
    // 1. Inject CSS for cursor hiding state and card offsets
    const style = document.createElement('style');
    style.innerHTML = `
        body.no-cursor, body.no-cursor * { cursor: none !important; }
        #custom-cursor { pointer-events: none; z-index: 999999; position: fixed; top: 0; left: 0; opacity: 0; transition: opacity 0.2s ease, transform 0.05s linear; }
        /* Animation classes for Smooth Re-positioning */
        .cursor-card-offset-right { transform: translate(40px, -50%); }
        .cursor-card-offset-left { transform: translate(calc(-100% - 40px), -50%); }
    `;
    document.head.appendChild(style);

    // 2. Create Cursor Element (Arrow + Card)
    const cursor = document.createElement('div');
    cursor.id = 'custom-cursor';
    // Centered pivot
    cursor.style.transform = 'translate(-50%, -50%)';
    cursor.innerHTML = `
        <div class="relative flex items-center justify-center">
            <!-- 1. Directional Arrow (Responsive Color) -->
            <div id="cursor-arrow" class="text-white mix-blend-difference drop-shadow-md">
                <i data-lucide="chevron-right" class="w-10 h-10"></i>
            </div>

            <!-- 2. Preview Card (Frosted Glass - No Blend) -->
            <div id="cursor-card" class="absolute top-1/2 left-0 w-max nav-glass p-2 pl-2 pr-4 rounded-2xl flex items-center gap-3 transition-transform duration-300">
                <img id="cursor-img" src="assets/projects/kavling12_1.webp" class="w-12 h-12 object-cover rounded-xl shadow-sm bg-gray-200">
                <div class="flex flex-col text-left">
                    <span id="cursor-label" class="text-[9px] uppercase tracking-widest font-bold text-secondary mb-0.5">Next Project</span>
                    <span id="cursor-name" class="text-sm font-black text-primary whitespace-nowrap">Kavling 12</span>
                </div>
            </div>
        </div>
    `;

    // Append to body robustly
    if (document.body) {
        document.body.appendChild(cursor);
    } else {
        window.addEventListener('load', () => document.body.appendChild(cursor));
    }

    const cursorArrow = document.getElementById('cursor-arrow');
    const cursorCard = document.getElementById('cursor-card');
    const cursorLabel = document.getElementById('cursor-label');
    const cursorName = document.getElementById('cursor-name');
    let isCursorVisible = false;

    // 3. Mouse Move Logic
    document.addEventListener('mousemove', (e) => {
        const x = e.clientX;
        const w = window.innerWidth;

        // Dynamic Padding Calculation (Matching CSS Site Container)
        // Mobile (<810px): 88% width -> 6% padding (approx)
        // Tablet (>=810px): 90% width -> 5% padding
        // Large (>=1600px): 85% width -> 7.5% padding
        let paddingPct = 0.06;
        if (w >= 1600) paddingPct = 0.075;
        else if (w >= 810) paddingPct = 0.05;

        // Activation Thresholds
        const leftThreshold = w * paddingPct;
        const rightThreshold = w * (1 - paddingPct);

        let activeZone = null;
        if (x < leftThreshold) { activeZone = 'prev'; }
        else if (x > rightThreshold) { activeZone = 'next'; }

        if (activeZone) {
            if (!isCursorVisible) {
                document.body.classList.add('no-cursor');
                cursor.style.opacity = '1';
                isCursorVisible = true;
            }
            // Update Position
            cursor.style.left = `${e.clientX}px`;
            cursor.style.top = `${e.clientY}px`;

            // Update Content
            if (activeZone === 'prev') {
                cursorArrow.innerHTML = '<i data-lucide="chevron-left" class="w-12 h-12"></i>';
                cursorCard.className = 'absolute top-1/2 left-0 w-max nav-glass p-2 pl-2 pr-4 rounded-2xl flex items-center gap-3 transition-transform duration-300 cursor-card-offset-right';
                cursorLabel.textContent = "Previous Project";
            } else {
                cursorArrow.innerHTML = '<i data-lucide="chevron-right" class="w-12 h-12"></i>';
                cursorCard.className = 'absolute top-1/2 left-0 w-max nav-glass p-2 pl-2 pr-4 rounded-2xl flex items-center gap-3 transition-transform duration-300 cursor-card-offset-left';
                cursorLabel.textContent = "Next Project";
            }
            // Re-init icons
            if (window.lucide) window.lucide.createIcons();

        } else {
            if (isCursorVisible) {
                document.body.classList.remove('no-cursor');
                cursor.style.opacity = '0';
                isCursorVisible = false;
            }
        }
    });
};

// Main Init
const initLayout = (isIndexPage = false) => {
    const navPlaceholder = document.getElementById('layout-nav');
    const footerPlaceholder = document.getElementById('layout-footer');

    // Clean URL Logic (Adaptive)
    const isLocal = window.location.protocol === 'file:';
    const rootPath = isLocal ? 'index.html' : '/';

    const linkPrefix = isIndexPage ? '' : rootPath;
    const logoLink = isIndexPage ? '#hero' : rootPath;

    // RENDER NAV
    if (navPlaceholder) {
        navPlaceholder.innerHTML = `
        <nav class="nav-fixed">
            <div class="nav-glass p-1.5 rounded-full flex items-center shadow-sm">
                <div class="pl-5 pr-2">
                    <a href="${logoLink}" class="font-black tracking-tighter text-primary text-base hover:text-accent uppercase leading-none cursor-pointer">KEND.</a>
                </div>
                <div class="hidden md:flex items-center gap-1 mx-1">
                    <a href="${linkPrefix}#scope" class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">Scope</a>
                    <a href="${linkPrefix}#portfolio" class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">Projects</a>
                    <a href="${linkPrefix}#cv" class="px-4 py-1.5 text-sm font-semibold text-secondary hover:text-accent transition-all duration-300 transform">About</a>
                </div>
                <button id="mobile-menu-btn" class="md:hidden p-2 ml-2 mr-1 rounded-full hover:bg-black/5 transition-colors">
                    <i data-lucide="menu" class="w-5 h-5 text-primary" id="menu-icon"></i>
                    <i data-lucide="x" class="w-5 h-5 text-primary hidden" id="close-icon"></i>
                </button>
                <a href="https://wa.me/6281390200075" target="_blank" class="group bg-primary hover:bg-[#25D366] text-white pl-4 pr-3 md:pl-6 md:pr-5 py-2 md:py-2.5 rounded-full text-xs md:text-sm font-bold flex items-center gap-1.5 md:gap-2 transition-all duration-500 hover:shadow-[0_0_25px_rgba(37,211,102,0.4)] active:scale-95 ml-2">
                    <svg class="w-3.5 h-3.5 md:w-4 md:h-4 transition-colors duration-500 fill-current group-hover:text-white" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.72.94 3.659 1.437 5.63 1.438h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" /></svg>Contact
                </a>
            </div>
        </nav>
        <div id="mobile-menu" class="fixed top-20 left-1/2 -translate-x-1/2 z-[999] w-[90%] max-w-sm hidden md:hidden">
            <div class="nav-glass rounded-3xl p-4 shadow-ios-deep">
                <div class="flex flex-col gap-2">
                    <a href="${linkPrefix}#scope" class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">Scope of Work</a>
                    <a href="${linkPrefix}#portfolio" class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">Projects</a>
                    <a href="${linkPrefix}#cv" class="mobile-nav-link px-4 py-3 text-base font-bold text-primary hover:bg-black/5 rounded-xl transition-all">About</a>
                </div>
            </div>
        </div>`;
    }

    if (footerPlaceholder) footerPlaceholder.innerHTML = renderFooter();

    initLayoutLogic();
    // Initialize Global Cursor ONLY on Project Pages
    if (!isIndexPage) {
        initGlobalCursor();
    }
};
