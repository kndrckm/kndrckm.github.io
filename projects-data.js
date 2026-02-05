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

// DATA PREP: Duplicate data to fill the grid (Just for demo purposes - remove this line if you have enough real projects)
const projectData = [...rawProjectData, ...rawProjectData]; 

// RENDER ENGINE: BENTO GRID LAYOUT
(function() {
    const container = document.getElementById('project-carousel');
    if (!container) return;

    // 1. Change container class to Grid instead of Carousel
    container.className = 'bento-grid'; 
    container.innerHTML = '';

    // 2. Helper to create a card HTML
    const createCard = (project) => `
        <a href="${project.link}" class="bento-card group block w-full h-full shadow-ios-card relative overflow-hidden">
            <img src="${project.image}" 
                class="absolute h-full w-full object-cover ${project.focus || 'object-center'} transition-transform duration-1000 group-hover:scale-110" 
                alt="${project.title}">
            
            <div class="absolute inset-0 project-gradient opacity-80 transition-opacity duration-500"></div>
            
            <div class="absolute top-6 left-6 md:top-8 md:left-8">
                <span class="px-4 py-1.5 bg-white/90 backdrop-blur-md rounded-full text-[10px] font-black uppercase tracking-widest text-primary shadow-sm">
                    ${project.category || 'Architecture'}
                </span>
            </div>

            <div class="absolute bottom-0 left-0 p-6 md:p-10 w-full text-white translate-y-2 group-hover:translate-y-0 transition-transform duration-500">
                <span class="block text-[10px] font-bold tracking-[0.2em] text-white/70 uppercase mb-2">
                    ${project.location}
                </span>
                <div class="flex items-end justify-between">
                    <h3 class="text-3xl md:text-4xl lg:text-5xl font-black uppercase tracking-tighter leading-[0.9] max-w-[80%]">
                        ${project.title}
                    </h3>
                    
                    <div class="w-10 h-10 rounded-full bg-white text-black flex items-center justify-center opacity-0 scale-75 group-hover:opacity-100 group-hover:scale-100 transition-all duration-300 delay-100">
                        <i data-lucide="arrow-up-right" class="w-5 h-5"></i>
                    </div>
                </div>
            </div>
        </a>
    `;

    // 3. Logic: Chunk data into pairs (Columns of 2)
    let htmlContent = '';
    
    // We loop through data in steps of 2
    for (let i = 0; i < projectData.length; i += 2) {
        const itemTop = projectData[i];
        const itemBottom = projectData[i+1];

        // Create the Column Wrapper
        htmlContent += `<div class="bento-col">`;
        
        // Add Top Item
        if (itemTop) {
            htmlContent += createCard(itemTop);
        }

        // Add Bottom Item (if it exists)
        if (itemBottom) {
            htmlContent += createCard(itemBottom);
        }

        htmlContent += `</div>`; // Close Column
    }

    // 4. Inject HTML
    container.innerHTML = htmlContent;
    
    // 5. Refresh Icons
    if(typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
})();