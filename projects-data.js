// DATABASE: Add your projects here
const projectData = [
    {
        title: "Student Apartment",
        location: "Semarang, Indonesia",
        image: "assets/apartment_1.webp",
		focus: "object-[65%_center]",
        link: "#" // Link to specific project page
    },
    {
        title: "MRT CP201 Monas",
        location: "Jakarta, Indonesia",
        image: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600",
		focus: "object-[50%_center]",
        link: "#"
    },
    {
        title: "Private Villa",
        location: "Bali, Indonesia",
        image: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2600",
		focus: "object-[50%_center]",
        link: "#"
    },
    // Example of adding a new one easily:
    /* {
        title: "New Office Tower",
        location: "Surabaya, Indonesia",
        image: "assets/office_render.jpg",
		focus: "object-[50%_center]",
        link: "project-office.html"
    },
    */
];

// RENDER ENGINE (Do not touch unless changing layout)
(function() {
    const container = document.getElementById('project-carousel');
    if (!container) return;

    // Clear any existing content
    container.innerHTML = '';

    // Generate HTML for each project
    const htmlContent = projectData.map(project => `
        <div class="min-w-[85vw] md:min-w-[600px] snap-center">
            <a href="${project.link}" class="project-card-link group block relative h-[500px] md:h-[650px] w-full overflow-hidden rounded-[2.5rem] shadow-ios-card transition-all duration-500 hover:shadow-[0_12px_12px_rgba(0,0,0,0.3)] hover:-translate-y-2">
					 
				<img src="${project.image}" 
					class="absolute h-full w-full object-cover ${project.focus || 'object-center'} transition-transform duration-700 group-hover:scale-105" 
					alt="${project.title}">
                
                <div class="hover-reveal absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 md:group-hover:opacity-100 transition-opacity duration-500"></div>
                
                <div class="hover-reveal absolute bottom-0 left-0 p-8 md:p-12 w-full text-white opacity-0 md:group-hover:opacity-100 transition-opacity duration-500">
                    <span class="block text-[10px] md:text-xs font-bold tracking-[0.2em] text-white/70 uppercase mb-3">
                        ${project.location}
                    </span>
                    <h3 class="text-4xl md:text-6xl font-black uppercase tracking-tighter leading-[0.9]">
                        ${project.title}
                    </h3>
                </div>
            </a>
        </div>
    `).join('');

    // Inject the HTML
    container.innerHTML = htmlContent;
})();