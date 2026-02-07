// PROJECT NAVIGATION COMPONENT
// Generates the "Continue Exploring" section dynamically based on current page

const projectNavigationData = [
    {
        slug: 'project-kavling12',
        title: 'Kavling 12',
        image: 'assets/projects/kavling12_1.webp'
    },
    {
        slug: 'project-ahome',
        title: 'A Home',
        image: 'assets/projects/ahome_1.webp'
    },
    {
        slug: 'project-boardinghouse',
        title: 'Boarding House',
        image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600'
    },
    {
        slug: 'project-kampusjati',
        title: 'Kampus Jati',
        image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200'
    }
];

function renderProjectNavigation(containerId = 'project-navigation') {
    const container = document.getElementById(containerId);
    if (!container) return;

    // Get current page slug from URL
    const currentPath = window.location.pathname;
    const currentSlug = currentPath.split('/').pop().replace('.html', '');

    // Find current index
    const currentIndex = projectNavigationData.findIndex(p => p.slug === currentSlug);
    if (currentIndex === -1) return;

    // Get prev/next (circular)
    const prevIndex = (currentIndex - 1 + projectNavigationData.length) % projectNavigationData.length;
    const nextIndex = (currentIndex + 1) % projectNavigationData.length;

    const prev = projectNavigationData[prevIndex];
    const next = projectNavigationData[nextIndex];

    container.innerHTML = `
        <section class="site-container mb-24 reveal-text">
            <!-- Divider -->
            <div class="flex items-center gap-4 mb-10">
                <div class="flex-1 h-px bg-gradient-to-r from-transparent via-black/10 to-black/10"></div>
                <span class="text-[10px] md:text-xs font-bold tracking-[0.2em] text-secondary uppercase">Continue Exploring</span>
                <div class="flex-1 h-px bg-gradient-to-l from-transparent via-black/10 to-black/10"></div>
            </div>
            
            <div class="grid grid-cols-2 gap-3 md:gap-6">
                <!-- Previous Project -->
                <a href="${prev.slug}.html" class="group relative h-[120px] md:h-[280px] rounded-[1.5rem] md:rounded-[2rem] overflow-hidden shadow-ios-card md:hover:shadow-ios-deep transition-all duration-500">
                    <img src="${prev.image}" class="absolute inset-0 w-full h-full object-cover md:transition-transform md:duration-700 md:group-hover:scale-105">
                    <div class="absolute inset-0 bg-gradient-to-r from-black/70 via-black/40 to-transparent"></div>
                    <div class="absolute inset-0 flex items-center p-4 md:p-10">
                        <div class="flex items-center gap-2 md:gap-4">
                            <div class="w-10 h-10 md:w-12 md:h-12 rounded-full bg-white flex items-center justify-center text-primary shadow-lg shrink-0">
                                <i data-lucide="arrow-left" class="w-4 h-4 md:w-5 md:h-5"></i>
                            </div>
                            <div class="min-w-0">
                                <span class="block text-[9px] md:text-[10px] font-bold tracking-[0.15em] text-white/60 uppercase mb-0.5 md:mb-1">Previous</span>
                                <h3 class="text-sm md:text-2xl font-black text-white uppercase tracking-tight truncate">${prev.title}</h3>
                            </div>
                        </div>
                    </div>
                </a>

                <!-- Next Project -->
                <a href="${next.slug}.html" class="group relative h-[120px] md:h-[280px] rounded-[1.5rem] md:rounded-[2rem] overflow-hidden shadow-ios-card md:hover:shadow-ios-deep transition-all duration-500">
                    <img src="${next.image}" class="absolute inset-0 w-full h-full object-cover md:transition-transform md:duration-700 md:group-hover:scale-105">
                    <div class="absolute inset-0 bg-gradient-to-l from-black/70 via-black/40 to-transparent"></div>
                    <div class="absolute inset-0 flex items-center justify-end p-4 md:p-10">
                        <div class="flex items-center gap-2 md:gap-4 flex-row-reverse">
                            <div class="w-10 h-10 md:w-12 md:h-12 rounded-full bg-white flex items-center justify-center text-primary shadow-lg shrink-0">
                                <i data-lucide="arrow-right" class="w-4 h-4 md:w-5 md:h-5"></i>
                            </div>
                            <div class="text-right min-w-0">
                                <span class="block text-[9px] md:text-[10px] font-bold tracking-[0.15em] text-white/60 uppercase mb-0.5 md:mb-1">Next</span>
                                <h3 class="text-sm md:text-2xl font-black text-white uppercase tracking-tight truncate">${next.title}</h3>
                            </div>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Back to All Projects -->
            <div class="flex justify-center mt-6 md:mt-8">
                <a href="index.html#portfolio" class="group inline-flex items-center gap-3 border border-black/10 md:hover:border-black md:hover:bg-black md:hover:text-white text-primary px-5 py-2.5 md:px-6 md:py-3 rounded-full text-xs md:text-sm font-bold transition-all duration-300">
                    <i data-lucide="grid-2x2" class="w-4 h-4"></i>
                    View All Projects
                </a>
            </div>
        </section>
    `;

    // Refresh Lucide icons for the new content
    if (typeof lucide !== 'undefined') {
        lucide.createIcons();
    }
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    renderProjectNavigation();
});
