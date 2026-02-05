// DATABASE: Add your projects here
const rawProjectData = [
    {
        title: "Student Apartment",
        location: "Semarang, Indonesia",
        category: "Residential",
        image: "assets/apartment_1.webp",
        focus: "object-[65%_center]",
        link: "#"
    },
    {
        title: "MRT CP201 Monas",
        location: "Jakarta, Indonesia",
        category: "Public Infrastructure",
        image: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600",
        focus: "object-[50%_center]",
        link: "#"
    },
    {
        title: "Private Villa",
        location: "Bali, Indonesia",
        category: "Hospitality",
        image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2600",
        focus: "object-[50%_center]",
        link: "#"
    },
    /* Add new projects here */
];

// DATA PREP: Massive duplication for truly seamless infinite loop
// 16x duplication ensures you never see a reset
const projectData = [
    ...rawProjectData, ...rawProjectData, ...rawProjectData, ...rawProjectData,
    ...rawProjectData, ...rawProjectData, ...rawProjectData, ...rawProjectData,
    ...rawProjectData, ...rawProjectData, ...rawProjectData, ...rawProjectData,
    ...rawProjectData, ...rawProjectData, ...rawProjectData, ...rawProjectData
];

// RENDER ENGINE: INFINITE DRAGGABLE CAROUSEL
(function () {
    const container = document.getElementById('project-carousel');
    const prevBtn = document.getElementById('prev-slide');
    const nextBtn = document.getElementById('next-slide');

    if (!container) return;

    // A. INJECT STYLE TO HIDE SCROLLBAR
    const style = document.createElement('style');
    style.innerHTML = `
        #project-carousel { -ms-overflow-style: none; scrollbar-width: none; cursor: grab; }
        #project-carousel::-webkit-scrollbar { display: none; }
        #project-carousel:active { cursor: grabbing; }
    `;
    document.head.appendChild(style);

    container.innerHTML = '';

    // Inject CSS for 2-row layout with 50:50 to 75:25 hover effect
    const carouselStyle = document.createElement('style');
    carouselStyle.innerHTML = `
        .project-row {
            height: 50%;
            transition: height 0.5s ease-out;
        }
        .project-carousel-wrapper:has(.project-card:hover) .project-row:has(.project-card:hover) {
            height: 75%;
        }
        .project-carousel-wrapper:has(.project-card:hover) .project-row:not(:has(.project-card:hover)) {
            height: 25%;
        }
        .project-card {
            transition: all 0.5s ease-out;
        }
        /* Hide all scrollbars */
        .project-row::-webkit-scrollbar { display: none; }
        .project-row { -ms-overflow-style: none; scrollbar-width: none; }
    `;
    document.head.appendChild(carouselStyle);

    // B. CARD TEMPLATE - flexible height
    const createCard = (project) => `
        <div class="project-card snap-center shrink-0 w-[280px] md:w-[350px] h-full select-none pointer-events-auto">
            <a href="${project.link}" draggable="false" class="group block w-full h-full relative overflow-hidden rounded-[1.5rem] cursor-pointer">
                <img src="${project.image}" draggable="false"
                    class="absolute h-full w-full object-cover ${project.focus || 'object-center'} transition-transform duration-1000 group-hover:scale-105" 
                    alt="${project.title}">
                
                <div class="absolute inset-0 project-gradient opacity-60 transition-opacity duration-500 hover:opacity-40"></div>
                
                <div class="absolute top-4 left-4 md:top-5 md:left-5">
                    <span class="px-3 py-1 bg-white/90 backdrop-blur-md rounded-full text-[8px] md:text-[10px] font-black uppercase tracking-widest text-primary shadow-sm">
                        ${project.category || 'Architecture'}
                    </span>
                </div>

                <div class="absolute bottom-0 left-0 p-4 md:p-6 w-full text-white">
                    <span class="block text-[8px] md:text-[10px] font-bold tracking-[0.2em] text-white/70 uppercase mb-1">
                        ${project.location}
                    </span>
                    <div class="flex items-end justify-between">
                        <h3 class="text-lg md:text-2xl font-black uppercase tracking-tighter leading-[0.9] max-w-[80%]">
                            ${project.title}
                        </h3>
                        
                        <div class="w-8 h-8 md:w-10 md:h-10 rounded-full bg-white text-black flex items-center justify-center opacity-0 scale-75 group-hover:opacity-100 group-hover:scale-100 transition-all duration-300 delay-100">
                            <i data-lucide="arrow-up-right" class="w-4 h-4 md:w-5 md:h-5"></i>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    `;

    // C. RENDER - 2 rows in a wrapper with fixed height
    // Split data for 2 rows
    const halfLength = Math.ceil(rawProjectData.length / 2);
    const row1Data = rawProjectData.slice(0, halfLength);
    const row2Data = rawProjectData.slice(halfLength);

    // Duplicate based on screen size (less on mobile for performance)
    const isMobile = window.innerWidth < 768;
    const duplicateCount = isMobile ? 3 : 8;

    const duplicateArray = (arr, times) => {
        let result = [];
        for (let i = 0; i < times; i++) result = result.concat(arr);
        return result;
    };

    const row1Projects = duplicateArray(row1Data, duplicateCount);
    const row2Projects = duplicateArray(row2Data, duplicateCount);

    let row1HTML = '<div class="project-row flex gap-4 overflow-x-auto scroll-smooth no-scrollbar">';
    row1Projects.forEach(project => {
        row1HTML += createCard(project);
    });
    row1HTML += '</div>';

    let row2HTML = '<div class="project-row flex gap-4 overflow-x-auto scroll-smooth no-scrollbar">';
    row2Projects.forEach(project => {
        row2HTML += createCard(project);
    });
    row2HTML += '</div>';

    container.innerHTML = `<div class="project-carousel-wrapper flex flex-col h-[400px] md:h-[550px] gap-4">${row1HTML}${row2HTML}</div>`;

    // D. SCROLL LOGIC FOR 2-ROW LAYOUT
    const carouselWrapper = container.querySelector('.project-carousel-wrapper');
    const row1Container = carouselWrapper.querySelector('.project-row:first-of-type');
    const row2Container = carouselWrapper.querySelector('.project-row:last-of-type');
    const rows = [row1Container, row2Container].filter(r => r);

    // 1. Initial Positioning (Middle of duplicated content)
    const cardWidth = 360; // approximate card + gap width
    const setInitialPos = () => {
        rows.forEach(row => {
            if (row) row.scrollLeft = row.scrollWidth / 3;
        });
    };
    setTimeout(setInitialPos, 150);

    // 2. Button Listeners - scroll both rows together
    if (prevBtn) prevBtn.addEventListener('click', () => {
        rows.forEach(row => {
            if (row) row.scrollBy({ left: -cardWidth, behavior: 'smooth' });
        });
    });

    if (nextBtn) nextBtn.addEventListener('click', () => {
        rows.forEach(row => {
            if (row) row.scrollBy({ left: cardWidth, behavior: 'smooth' });
        });
    });

    // 3. KEYBOARD NAVIGATION - Arrow keys to scroll carousel
    document.addEventListener('keydown', (e) => {
        // Check if carousel is in viewport
        const rect = container.getBoundingClientRect();
        const isInView = rect.top < window.innerHeight && rect.bottom > 0;

        if (isInView) {
            if (e.key === 'ArrowLeft') {
                e.preventDefault();
                rows.forEach(row => {
                    if (row) row.scrollBy({ left: -cardWidth, behavior: 'smooth' });
                });
            } else if (e.key === 'ArrowRight') {
                e.preventDefault();
                rows.forEach(row => {
                    if (row) row.scrollBy({ left: cardWidth, behavior: 'smooth' });
                });
            }
        }
    });

    // Note: Duplication is optimized based on screen size


    // E. EDGE-BASED CURSOR NAVIGATION
    let currentCursorZone = 'center'; // 'left', 'right', or 'center'

    // Inject custom cursor styles - apply to container AND all children (cards)
    const cursorStyle = document.createElement('style');
    cursorStyle.innerHTML = `
        #project-carousel.cursor-left,
        #project-carousel.cursor-left * {
            cursor: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><circle cx="24" cy="24" r="22" fill="black"/><path d="M 28 16 L 20 24 L 28 32" stroke="white" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>') 24 24, pointer !important;
        }
        #project-carousel.cursor-right,
        #project-carousel.cursor-right * {
            cursor: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><circle cx="24" cy="24" r="22" fill="black"/><path d="M 20 16 L 28 24 L 20 32" stroke="white" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>') 24 24, pointer !important;
        }
        #project-carousel.cursor-center {
            cursor: default;
        }
    `;
    document.head.appendChild(cursorStyle);

    // Track cursor position
    container.addEventListener('mousemove', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const containerWidth = rect.width;

        // 15% of page width for each side
        const edgeThreshold = window.innerWidth * 0.15;

        let newZone = 'center';

        if (x < edgeThreshold) {
            newZone = 'left';
        } else if (x > containerWidth - edgeThreshold) {
            newZone = 'right';
        }

        // Update cursor styling
        if (newZone !== currentCursorZone) {
            container.classList.remove('cursor-left', 'cursor-right', 'cursor-center');
            container.classList.add(`cursor-${newZone}`);
            currentCursorZone = newZone;
        }
    });

    // Reset cursor when leaving carousel
    container.addEventListener('mouseleave', () => {
        container.classList.remove('cursor-left', 'cursor-right', 'cursor-center');
        currentCursorZone = 'center';
    });

    // Click to scroll - blocks link navigation in edge zones
    container.addEventListener('click', (e) => {
        if (currentCursorZone === 'left') {
            e.preventDefault();
            e.stopPropagation();
            rows.forEach(row => {
                if (row) row.scrollBy({ left: -cardWidth, behavior: 'smooth' });
            });
        } else if (currentCursorZone === 'right') {
            e.preventDefault();
            e.stopPropagation();
            rows.forEach(row => {
                if (row) row.scrollBy({ left: cardWidth, behavior: 'smooth' });
            });
        }
        // If center zone, do nothing (let links work)
    }, true); // Use capture phase to intercept before links

    // F. REFRESH ICONS
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
})();