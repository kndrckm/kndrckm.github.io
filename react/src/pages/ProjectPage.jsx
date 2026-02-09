import { useEffect, useRef } from 'react';

// Project data
const projectsData = {
    'kavling-12': {
        title: 'Kavling 12',
        titleHighlight: '12',
        location: 'Batam, Indonesia',
        category: 'Residential',
        year: '2025',
        area: '180 sq m',
        style: 'Modern Tropical',
        heroDay: '/assets/projects/kavling12_1.webp',
        heroNight: '/assets/projects/kavling12_2.webp',
        hasDayNightToggle: true,
        hasDoorCursor: true,
        philosophy: {
            title: 'Design Philosophy',
            description: 'Kavling 12 is envisioned as a blank canvas—a structural framework that allows users the freedom to express themselves through material and color.',
            quote: '"A home designed to breathe and evolve with you."',
            details: [
                'Beyond its flexible aesthetic, the core strength of Kavling 12 lies in its performance. The massing is strategically carved to capture prevailing winds and filter natural sunlight deep into the living spaces.',
                'This approach ensures that while the facade remains an adaptable canvas for the owner\'s taste, the comfort and energy efficiency of the home remain absolute and timeless.'
            ],
            feature: { icon: 'wind', title: 'Passive Design', subtitle: 'Optimized Air & Light' }
        },
        gallery: [
            { src: '/assets/projects/kavling12_5.webp', cols: 8, rows: 1 },
            { src: '/assets/projects/kavling12_3.webp', cols: 4, rows: 1, position: 'top' },
            { src: '/assets/projects/kavling12_4.webp', srcNight: '/assets/projects/kavling12_4b.webp', cols: 4, rows: 1, hasDayNightToggle: true },
            { src: '/assets/projects/kavling12_6.webp', cols: 4, rows: 1, newRow: true },
            { src: '/assets/projects/kavling12_7.webp', cols: 4, rows: 1 },
            { src: '/assets/projects/kavling12_8.webp', cols: 4, rows: 1 },
        ]
    },
    'a-home': {
        title: 'A Home',
        titleHighlight: 'Home',
        location: 'Bogor, Indonesia',
        category: 'Residential',
        year: '2024',
        area: '130 sqm',
        style: 'Modern Tropical',
        heroDay: '/assets/projects/ahome_2.webp',
        hasDayNightToggle: false,
        hasPanorama: true,
        panoramaImage: '/assets/projects/ahome_pano.webp',
        philosophy: {
            description: 'Designed to accommodate the project owner\'s elderly mother, this home prioritizes accessibility on the first floor while maintaining a seamless flow.',
            details: [
                'The architecture invites natural windflow and sunlight to fill the interiors, anchored by a koi pond at the intersection of spaces and lush pot greeneries—creating a sanctuary for the wellbeing of the owner and their mother.'
            ],
            feature: { icon: 'heart', title: 'Wellbeing', subtitle: 'Generational Harmony' }
        },
        gallery: [
            { src: '/assets/projects/ahome_3.webp', cols: 3, rows: 1 },
            { src: '/assets/projects/ahome_4.webp', cols: 7, rows: 1 },
            { src: '/assets/projects/ahome_5.webp', cols: 7, rows: 1, newRow: true },
            { src: '/assets/projects/ahome_6.webp', cols: 3, rows: 1 },
        ]
    },
    'boarding-house': {
        title: 'Boarding House',
        titleHighlight: 'House',
        location: 'Yogyakarta, Indonesia',
        category: 'Commercial',
        year: '2024',
        area: '250 sqm',
        style: 'Contemporary',
        heroDay: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=2600',
        hasDayNightToggle: false,
        philosophy: {
            description: 'A modern boarding house designed for young professionals and students.',
            details: ['Maximizing space efficiency while maintaining comfort and privacy.']
        },
        gallery: []
    }
};

export default function ProjectPage({ slug, onHomeClick, skipHeroAnimation }) {
    const panoramaRef = useRef(null);
    const project = projectsData[slug];

    useEffect(() => {
        if (!project) return;

        // Init Lucide icons
        if (window.lucide) window.lucide.createIcons();

        // Scroll to top
        window.scrollTo(0, 0);

        // Reveal animation
        const observer = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('revealed');
                    obs.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('.reveal-text').forEach(el => observer.observe(el));

        // Init Pannellum for A Home
        if (project.hasPanorama && window.pannellum && panoramaRef.current) {
            window.viewer = window.pannellum.viewer(panoramaRef.current, {
                type: 'equirectangular',
                panorama: project.panoramaImage,
                autoLoad: true,
                compass: false,
                hfov: 100,
                showControls: false
            });
        }

        return () => {
            observer.disconnect();
            if (window.viewer && window.viewer.destroy) {
                window.viewer.destroy();
            }
        };
    }, [project, slug]);

    // Hero day/night toggle
    const toggleHero = (mode) => {
        const dayImg = document.getElementById('hero-day');
        const nightImg = document.getElementById('hero-night');
        const knob = document.getElementById('hero-knob');
        const iconDay = document.getElementById('hero-icon-day');
        const iconNight = document.getElementById('hero-icon-night');

        if (mode === 'night') {
            if (nightImg) nightImg.style.opacity = '1';
            if (knob) knob.style.transform = 'translateY(4rem)';
            iconDay?.classList.remove('text-primary');
            iconDay?.classList.add('text-white/50');
            iconNight?.classList.remove('text-white/50');
            iconNight?.classList.add('text-primary');
        } else {
            if (nightImg) nightImg.style.opacity = '0';
            if (knob) knob.style.transform = 'translateY(0)';
            iconDay?.classList.remove('text-white/50');
            iconDay?.classList.add('text-primary');
            iconNight?.classList.remove('text-primary');
            iconNight?.classList.add('text-white/50');
        }
    };

    // Gallery day/night toggle
    const toggleGalleryLights = () => {
        const knob = document.getElementById('gal-knob');
        const iconDay = document.getElementById('gal-icon-day');
        const iconNight = document.getElementById('gal-icon-night');
        const dayImg = document.getElementById('gallery-day-img');
        const nightImg = document.getElementById('gallery-night-img');

        const isNight = knob?.style.transform === 'translateX(4rem)';

        if (!isNight) {
            if (knob) knob.style.transform = 'translateX(4rem)';
            iconDay?.classList.remove('text-primary');
            iconDay?.classList.add('text-white/50');
            iconNight?.classList.remove('text-primary/30');
            iconNight?.classList.add('text-primary');
            if (dayImg) dayImg.style.opacity = '0';
            if (nightImg) nightImg.style.opacity = '1';
        } else {
            if (knob) knob.style.transform = 'translateX(0)';
            iconDay?.classList.remove('text-white/50');
            iconDay?.classList.add('text-primary');
            iconNight?.classList.remove('text-primary');
            iconNight?.classList.add('text-primary/30');
            if (dayImg) dayImg.style.opacity = '1';
            if (nightImg) nightImg.style.opacity = '0';
        }
    };

    if (!project) {
        return (
            <div className="min-h-screen flex items-center justify-center">
                <div className="text-center">
                    <h1 className="text-4xl font-black text-primary mb-4">Project Not Found</h1>
                    <button onClick={onHomeClick} className="text-accent hover:underline">Go Home</button>
                </div>
            </div>
        );
    }

    const titleParts = project.title.split(project.titleHighlight);

    return (
        <>
            {/* HERO SECTION */}
            <div className={`${skipHeroAnimation ? '' : 'animate-pop'} relative w-full h-[100vh] overflow-hidden shadow-floating group bg-black`}>

                {/* Day/Night Toggle (Kavling 12 only) */}
                {project.hasDayNightToggle && (
                    <div id="hero-switch-container"
                        className="hero-switcher absolute top-1/2 right-[6%] md:right-[5%] 2xl:right-[7.5%] -translate-y-1/2 z-30 pointer-events-auto flex items-center gap-4 transition-transform duration-300">

                        <div className="hidden md:flex nav-glass items-center gap-2 px-4 py-2 rounded-xl animate-pulse absolute right-full mr-6 top-1/2 -translate-y-1/2 whitespace-nowrap shadow-xl">
                            <span className="text-xs font-black uppercase tracking-widest text-primary">Try Me</span>
                            <i data-lucide="arrow-right" className="w-4 h-4 text-accent"></i>
                        </div>

                        <div className="relative bg-black/20 backdrop-blur-md border border-white/30 p-1 rounded-full flex flex-col justify-between shadow-2xl w-[3.5rem] h-[7.5rem] box-border">
                            <div id="hero-knob" className="absolute left-1 w-[2.9rem] h-[2.9rem] bg-white rounded-full shadow-[0_0_10px_rgba(0,0,0,0.2)] transition-transform duration-500 z-0 pointer-events-none"></div>
                            <button onClick={() => toggleHero('day')} className="relative z-10 w-full flex-1 flex items-center justify-center -translate-y-1.5 focus:outline-none">
                                <i id="hero-icon-day" data-lucide="sun" className="w-6 h-6 transition-all duration-300 text-primary"></i>
                            </button>
                            <button onClick={() => toggleHero('night')} className="relative z-10 w-full flex-1 flex items-center justify-center translate-y-1.5 focus:outline-none">
                                <i id="hero-icon-night" data-lucide="moon" className="w-6 h-6 transition-all duration-300 text-white/50"></i>
                            </button>
                        </div>
                    </div>
                )}

                {/* Hero Images */}
                <img id="hero-day" src={project.heroDay}
                    className="absolute inset-0 w-full h-full object-cover transition-opacity duration-1000 ease-in-out z-10 select-none" alt={project.title} />
                {project.heroNight && (
                    <img id="hero-night" src={project.heroNight}
                        className="absolute inset-0 w-full h-full object-cover opacity-0 transition-opacity duration-1000 ease-in-out z-10 select-none" alt={`${project.title} Night`} />
                )}

                <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent z-20 pointer-events-none"></div>

                {/* Door Hotspot (Kavling 12 only) */}
                {project.hasDoorCursor && (
                    <a href="#gallery" id="door-hotspot" className="absolute top-[54%] left-[53%] w-[6%] h-[20%] z-30 cursor-none"></a>
                )}

                {/* Title Overlay */}
                <div className="absolute bottom-32 md:bottom-40 w-full z-30 pointer-events-none">
                    <div className="w-[91.66%] md:w-[93.75%] 2xl:w-[88.54%] max-w-[1800px] mx-auto">
                        <h1 className="text-[10vw] md:text-[6.5vw] font-black text-white tracking-tighter leading-none reveal-text">
                            {titleParts[0]}<span className="text-white/80">{project.titleHighlight}</span>{titleParts[1] || ''}
                        </h1>
                    </div>
                </div>
            </div>

            {/* INFO CARD */}
            <section className={`relative z-40 -mt-24 mb-32 ${skipHeroAnimation ? 'animate-pop' : 'reveal-text'}`} style={skipHeroAnimation ? { animationDelay: '0.3s', animationFillMode: 'both' } : {}}>
                <div className="site-container nav-glass rounded-[2.5rem] p-8 md:p-14">

                    {/* Metadata Grid */}
                    <div className="grid grid-cols-3 gap-8 pb-12 border-b border-black/5">
                        <div>
                            <span className="block text-[10px] font-bold text-accent uppercase tracking-widest mb-2">Area Size</span>
                            <h4 className="text-lg font-bold text-primary">{project.area}</h4>
                        </div>
                        <div>
                            <span className="block text-[10px] font-bold text-accent uppercase tracking-widest mb-2">Year</span>
                            <h4 className="text-lg font-bold text-primary">{project.year}</h4>
                        </div>
                        <div>
                            <span className="block text-[10px] font-bold text-accent uppercase tracking-widest mb-2">Style</span>
                            <h4 className="text-lg font-bold text-primary">{project.style}</h4>
                        </div>
                    </div>

                    {/* Philosophy Section */}
                    <div className="grid grid-cols-1 md:grid-cols-12 gap-12 pt-12">
                        <div className="md:col-span-4">
                            {project.philosophy.title && (
                                <h3 className="text-2xl font-black text-primary mb-4 tracking-tight">{project.philosophy.title}</h3>
                            )}
                            {project.philosophy.description && (
                                <p className="text-secondary text-sm leading-relaxed mb-8">{project.philosophy.description}</p>
                            )}
                            {project.philosophy.feature && (
                                <div className="bg-white/50 border border-white/50 rounded-2xl p-4 flex items-center gap-4">
                                    <div className="bg-white p-2.5 rounded-xl text-accent shadow-sm">
                                        <i data-lucide={project.philosophy.feature.icon} className="w-5 h-5"></i>
                                    </div>
                                    <div>
                                        <span className="block text-xs font-bold text-primary">{project.philosophy.feature.title}</span>
                                        <span className="text-[11px] text-secondary">{project.philosophy.feature.subtitle}</span>
                                    </div>
                                </div>
                            )}
                        </div>
                        <div className="md:col-span-8">
                            {project.philosophy.quote && (
                                <h2 className="text-2xl md:text-4xl font-bold text-accent mb-6 leading-tight">
                                    {project.philosophy.quote}
                                </h2>
                            )}
                            {project.philosophy.details?.map((detail, idx) => (
                                <p key={idx} className="text-secondary leading-relaxed mb-6">{detail}</p>
                            ))}
                        </div>
                    </div>
                </div>
            </section>

            {/* 360 PANORAMA (A Home only) */}
            {project.hasPanorama && (
                <section id="gallery" className="site-container mb-6 reveal-text">
                    <div className="relative w-full h-[500px] md:h-[700px] rounded-[2.5rem] overflow-hidden shadow-2xl group">
                        <div ref={panoramaRef} id="panorama" className="w-full h-full"></div>

                        <div className="absolute top-6 left-6 z-10 pointer-events-none">
                            <span className="px-3 py-1 bg-white/90 backdrop-blur-md rounded-full text-xs font-black uppercase tracking-widest text-primary shadow-sm">
                                360° Virtual Tour
                            </span>
                        </div>

                        <div className="absolute bottom-6 left-1/2 -translate-x-1/2 flex gap-3 p-2 bg-white/10 backdrop-blur-md rounded-2xl border border-white/20 shadow-lg z-10 hover:bg-white/20 transition-colors">
                            <button onMouseDown={() => window.viewer?.setHfov(window.viewer.getHfov() - 10)} className="p-2 text-white hover:text-accent transition-colors" title="Zoom In">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <circle cx="11" cy="11" r="8" /><line x1="21" x2="16.65" y1="21" y2="16.65" /><line x1="11" x2="11" y1="8" y2="14" /><line x1="8" x2="14" y1="11" y2="11" />
                                </svg>
                            </button>
                            <button onMouseDown={() => window.viewer?.setHfov(window.viewer.getHfov() + 10)} className="p-2 text-white hover:text-accent transition-colors" title="Zoom Out">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <circle cx="11" cy="11" r="8" /><line x1="21" x2="16.65" y1="21" y2="16.65" /><line x1="8" x2="14" y1="11" y2="11" />
                                </svg>
                            </button>
                            <div className="w-px bg-white/20 mx-1"></div>
                            <button onClick={() => window.viewer?.toggleFullscreen()} className="p-2 text-white hover:text-accent transition-colors" title="Fullscreen">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </section>
            )}

            {/* GALLERY GRID */}
            {project.gallery.length > 0 && (
                <section id={project.hasPanorama ? '' : 'gallery'} className="site-container mb-40 reveal-text">
                    {slug === 'kavling-12' ? (
                        // Kavling 12 specific gallery layout
                        <>
                            <div className="grid grid-cols-1 md:grid-cols-12 gap-6 h-auto md:h-[800px]">
                                <div className="md:col-span-8 h-[300px] md:h-full relative rounded-3xl overflow-hidden group">
                                    <img src="/assets/projects/kavling12_5.webp" className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
                                </div>
                                <div className="md:col-span-4 flex flex-col gap-6 h-full">
                                    <div className="relative flex-1 h-[300px] md:h-auto rounded-3xl overflow-hidden group">
                                        <img src="/assets/projects/kavling12_3.webp" className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
                                    </div>
                                    <div className="relative flex-1 h-[300px] md:h-auto rounded-3xl overflow-hidden group">
                                        <img id="gallery-day-img" src="/assets/projects/kavling12_4.webp" className="absolute inset-0 w-full h-full object-cover transition-all duration-700 z-10 group-hover:scale-105" alt="Gallery Day" />
                                        <img id="gallery-night-img" src="/assets/projects/kavling12_4b.webp" className="absolute inset-0 w-full h-full object-cover opacity-0 transition-all duration-700 z-10 group-hover:scale-105" alt="Gallery Night" />

                                        <div onClick={toggleGalleryLights} className="absolute bottom-6 right-6 z-20 cursor-pointer group">
                                            <div className="relative bg-black/20 backdrop-blur-md border border-white/30 p-1 rounded-full flex gap-0 justify-between shadow-2xl h-[3.5rem] w-[7.5rem] box-border">
                                                <div id="gal-knob" className="absolute top-1 left-1 w-[2.9rem] h-[2.9rem] bg-white rounded-full shadow-[0_0_10px_rgba(0,0,0,0.2)] transition-transform duration-500 z-0"></div>
                                                <div className="relative z-10 w-full flex-1 flex items-center justify-center -translate-x-1.5">
                                                    <i id="gal-icon-day" data-lucide="sun" className="w-6 h-6 text-primary transition-colors duration-300"></i>
                                                </div>
                                                <div className="relative z-10 w-full flex-1 flex items-center justify-center translate-x-1.5">
                                                    <i id="gal-icon-night" data-lucide="moon" className="w-6 h-6 text-primary/30 transition-colors duration-300"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
                                <div className="h-[300px] rounded-3xl overflow-hidden relative group">
                                    <img src="/assets/projects/kavling12_6.webp" className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
                                </div>
                                <div className="h-[300px] rounded-3xl overflow-hidden relative group">
                                    <img src="/assets/projects/kavling12_7.webp" className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
                                </div>
                                <div className="h-[300px] rounded-3xl overflow-hidden relative group">
                                    <img src="/assets/projects/kavling12_8.webp" className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" alt="Gallery" />
                                </div>
                            </div>
                        </>
                    ) : slug === 'a-home' ? (
                        // A Home alternating grid
                        <div className="grid grid-cols-1 md:grid-cols-10 gap-4 md:gap-6">
                            <div className="md:col-span-3 h-[350px] md:h-[500px] rounded-[2.5rem] overflow-hidden shadow-floating reveal-text group">
                                <img src="/assets/projects/ahome_3.webp" loading="lazy" className="w-full h-full object-cover scale-110 transition-transform duration-700 group-hover:scale-115 select-none" alt="Gallery" />
                            </div>
                            <div className="md:col-span-7 h-[350px] md:h-[500px] rounded-[2.5rem] overflow-hidden shadow-floating reveal-text group">
                                <img src="/assets/projects/ahome_4.webp" loading="lazy" className="w-full h-full object-cover scale-110 transition-transform duration-700 group-hover:scale-115 select-none" alt="Gallery" />
                            </div>
                            <div className="md:col-span-7 h-[350px] md:h-[500px] rounded-[2.5rem] overflow-hidden shadow-floating reveal-text group">
                                <img src="/assets/projects/ahome_5.webp" loading="lazy" className="w-full h-full object-cover scale-110 transition-transform duration-700 group-hover:scale-115 select-none" alt="Gallery" />
                            </div>
                            <div className="md:col-span-3 h-[350px] md:h-[500px] rounded-[2.5rem] overflow-hidden shadow-floating reveal-text group">
                                <img src="/assets/projects/ahome_6.webp" loading="lazy" className="w-full h-full object-cover scale-110 transition-transform duration-700 group-hover:scale-115 select-none" alt="Gallery" />
                            </div>
                        </div>
                    ) : null}
                </section>
            )}

            {/* Door Cursor (Kavling 12 only) */}
            {project.hasDoorCursor && (
                <div id="door-cursor"
                    className="fixed hidden pointer-events-none z-[9999] text-white bg-black/20 backdrop-blur-md p-3 rounded-full border border-white/50 shadow-2xl transform -translate-x-1/2 -translate-y-1/2 transition-transform duration-75">
                    <i data-lucide="door-open" className="w-6 h-6"></i>
                </div>
            )}
        </>
    );
}
